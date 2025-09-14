#!/usr/bin/env python3
import streamlit as st
import pandas as pd
import plotly.express as px
from difflib import HtmlDiff
import pathlib, subprocess, os, json

st.set_page_config(page_title="Irate Lab", layout="wide")
st.title("⚡ Irate Compiler Pass Explorer")

IRATE_BINARY = "/home/prabhjot/IRate/Irate/IRate/build/opt_ledger"

uploaded_code = st.file_uploader("Upload a C/C++ or .ll file to run Irate")

common_passes = ["mem2reg","instcombine","gvn","adce","inline","loop-unroll","simplifycfg","constmerge"]
selected_passes = st.multiselect("Choose passes", options=common_passes, default=["mem2reg","instcombine"])

if uploaded_code:
    src_path = f"temp_{uploaded_code.name}"
    with open(src_path, "wb") as f:
        f.write(uploaded_code.read())

    if st.button("Run Irate"):
        os.makedirs("irate_output", exist_ok=True)
        passes = ",".join(selected_passes)
        cmd = [IRATE_BINARY,"--input",src_path,"--outdir","irate_output","--passes",passes]
        st.write("Running:", " ".join(cmd))
        result = subprocess.run(cmd, capture_output=True, text=True)
        st.text(result.stdout)
        if result.stderr:
            st.error(result.stderr)

json_path = pathlib.Path("irate_output/ledger.json")
if json_path.exists():
    with open(json_path) as f:
        data = json.load(f)
    df = pd.DataFrame(data)

    df.insert(0, "Index", range(len(df)))
    for base in ["instr","funcs","bbs","size"]:
        if f"after_{base}" in df and f"before_{base}" in df:
            df[f"Δ{base}"] = df[f"after_{base}"] - df[f"before_{base}"]

    st.success("Irate run complete. Showing results…")

    def highlight_delta(val):
        try:
            color = "green" if val < 0 else "red" if val > 0 else "black"
            return f"color: {color}"
        except:
            return ""
    st.dataframe(df.style.applymap(highlight_delta, subset=[c for c in df.columns if c.startswith("Δ")]))


    numeric_cols = [c for c in df.columns if c not in ("Index","pass") and pd.api.types.is_numeric_dtype(df[c])]
    metric = st.selectbox("Metric to plot", numeric_cols, index=0)

    tab1, tab2, tab3 = st.tabs(["📈 Timeline","📝 IR Diff","🔥 Heatmap"])

    with tab1:
        fig = px.line(df, x="Index", y=metric, text="pass", markers=True, title=f"{metric} over passes")
        st.plotly_chart(fig, use_container_width=True)

        # delta bar chart
        delta_col = f"Δ{metric.replace('before_','').replace('after_','')}" if f"Δ{metric}" not in df else f"Δ{metric}"
        if delta_col in df:
            fig2 = px.bar(df, x="pass", y=delta_col,
                          color=df[delta_col] > 0,
                          color_discrete_map={True:"red",False:"green"},
                          title=f"{delta_col} per pass")
            st.plotly_chart(fig2, use_container_width=True)

    with tab2:
        selected_pass = st.selectbox("Select pass for IR diff", df["pass"])
        row = df[df["pass"] == selected_pass].iloc[0]
        before_ir = row.get("before_path")
        after_ir = row.get("after_path")
        if before_ir and after_ir and pathlib.Path(before_ir).exists() and pathlib.Path(after_ir).exists():
            with open(before_ir) as f:
                before_text = f.read()
            with open(after_ir) as f:
                after_text = f.read()
            html_diff = HtmlDiff().make_file(before_text.splitlines(), after_text.splitlines(),
                                             fromdesc="Before IR", todesc="After IR")
            st.components.v1.html(html_diff, height=600, scrolling=True)
        else:
            st.warning("IR files not found for this pass.")

    with tab3:
        delta_cols = [c for c in df.columns if c.startswith("Δ")]
        if delta_cols:
            delta_df = df[delta_cols].copy()
            delta_df.index = df["pass"]
            st.dataframe(delta_df.style.background_gradient(cmap='RdYlGn_r', axis=1))
        else:
            st.info("No delta metrics found to show a heatmap.")
else:
    st.info("Upload a file and run Irate to see results.")
