; ModuleID = '../test.ll'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@main.A = internal global [256 x [256 x i32]] zeroinitializer, align 16
@main.B = internal global [256 x [256 x i32]] zeroinitializer, align 16
@main.C = internal global [256 x [256 x i32]] zeroinitializer, align 16
@main.X = internal global [1024 x i32] zeroinitializer, align 16
@main.Y = internal global [1024 x i32] zeroinitializer, align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = load i32, i32* %3, align 4
  %5 = icmp ult i32 %4, 2
  br i1 %5, label %6, label %8

6:                                                ; preds = %1
  %7 = load i32, i32* %3, align 4
  store i32 %7, i32* %2, align 4
  br label %16

8:                                                ; preds = %1
  %9 = load i32, i32* %3, align 4
  %10 = sub i32 %9, 1
  %11 = call i32 @fib(i32 noundef %10)
  %12 = load i32, i32* %3, align 4
  %13 = sub i32 %12, 2
  %14 = call i32 @fib(i32 noundef %13)
  %15 = add i32 %11, %14
  store i32 %15, i32* %2, align 4
  br label %16

16:                                               ; preds = %8, %6
  %17 = load i32, i32* %2, align 4
  ret i32 %17
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @fun([256 x i32]* noundef %0, [256 x i32]* noundef %1, [256 x i32]* noundef %2) #0 {
  %4 = alloca [256 x i32]*, align 8
  %5 = alloca [256 x i32]*, align 8
  %6 = alloca [256 x i32]*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store [256 x i32]* %0, [256 x i32]** %4, align 8
  store [256 x i32]* %1, [256 x i32]** %5, align 8
  store [256 x i32]* %2, [256 x i32]** %6, align 8
  store i32 0, i32* %7, align 4
  br label %11

11:                                               ; preds = %58, %3
  %12 = load i32, i32* %7, align 4
  %13 = icmp slt i32 %12, 256
  br i1 %13, label %14, label %61

14:                                               ; preds = %11
  store i32 0, i32* %8, align 4
  br label %15

15:                                               ; preds = %54, %14
  %16 = load i32, i32* %8, align 4
  %17 = icmp slt i32 %16, 256
  br i1 %17, label %18, label %57

18:                                               ; preds = %15
  store i32 0, i32* %9, align 4
  store i32 0, i32* %10, align 4
  br label %19

19:                                               ; preds = %42, %18
  %20 = load i32, i32* %10, align 4
  %21 = icmp slt i32 %20, 256
  br i1 %21, label %22, label %45

22:                                               ; preds = %19
  %23 = load [256 x i32]*, [256 x i32]** %4, align 8
  %24 = load i32, i32* %7, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds [256 x i32], [256 x i32]* %23, i64 %25
  %27 = load i32, i32* %10, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [256 x i32], [256 x i32]* %26, i64 0, i64 %28
  %30 = load i32, i32* %29, align 4
  %31 = load [256 x i32]*, [256 x i32]** %5, align 8
  %32 = load i32, i32* %10, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [256 x i32], [256 x i32]* %31, i64 %33
  %35 = load i32, i32* %8, align 4
  %36 = sext i32 %35 to i64
  %37 = getelementptr inbounds [256 x i32], [256 x i32]* %34, i64 0, i64 %36
  %38 = load i32, i32* %37, align 4
  %39 = mul nsw i32 %30, %38
  %40 = load i32, i32* %9, align 4
  %41 = add nsw i32 %40, %39
  store i32 %41, i32* %9, align 4
  br label %42

42:                                               ; preds = %22
  %43 = load i32, i32* %10, align 4
  %44 = add nsw i32 %43, 1
  store i32 %44, i32* %10, align 4
  br label %19, !llvm.loop !6

45:                                               ; preds = %19
  %46 = load i32, i32* %9, align 4
  %47 = load [256 x i32]*, [256 x i32]** %6, align 8
  %48 = load i32, i32* %7, align 4
  %49 = sext i32 %48 to i64
  %50 = getelementptr inbounds [256 x i32], [256 x i32]* %47, i64 %49
  %51 = load i32, i32* %8, align 4
  %52 = sext i32 %51 to i64
  %53 = getelementptr inbounds [256 x i32], [256 x i32]* %50, i64 0, i64 %52
  store i32 %46, i32* %53, align 4
  br label %54

54:                                               ; preds = %45
  %55 = load i32, i32* %8, align 4
  %56 = add nsw i32 %55, 1
  store i32 %56, i32* %8, align 4
  br label %15, !llvm.loop !8

57:                                               ; preds = %15
  br label %58

58:                                               ; preds = %57
  %59 = load i32, i32* %7, align 4
  %60 = add nsw i32 %59, 1
  store i32 %60, i32* %7, align 4
  br label %11, !llvm.loop !9

61:                                               ; preds = %11
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @filter(i32* noundef %0, i32* noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32*, align 8
  %5 = alloca i32*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32* %0, i32** %4, align 8
  store i32* %1, i32** %5, align 8
  store i32 %2, i32* %6, align 4
  store i32 1, i32* %7, align 4
  br label %8

8:                                                ; preds = %38, %3
  %9 = load i32, i32* %7, align 4
  %10 = load i32, i32* %6, align 4
  %11 = sub nsw i32 %10, 1
  %12 = icmp slt i32 %9, %11
  br i1 %12, label %13, label %41

13:                                               ; preds = %8
  %14 = load i32*, i32** %4, align 8
  %15 = load i32, i32* %7, align 4
  %16 = sub nsw i32 %15, 1
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds i32, i32* %14, i64 %17
  %19 = load i32, i32* %18, align 4
  %20 = load i32*, i32** %4, align 8
  %21 = load i32, i32* %7, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds i32, i32* %20, i64 %22
  %24 = load i32, i32* %23, align 4
  %25 = add nsw i32 %19, %24
  %26 = load i32*, i32** %4, align 8
  %27 = load i32, i32* %7, align 4
  %28 = add nsw i32 %27, 1
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds i32, i32* %26, i64 %29
  %31 = load i32, i32* %30, align 4
  %32 = add nsw i32 %25, %31
  %33 = sdiv i32 %32, 3
  %34 = load i32*, i32** %5, align 8
  %35 = load i32, i32* %7, align 4
  %36 = sext i32 %35 to i64
  %37 = getelementptr inbounds i32, i32* %34, i64 %36
  store i32 %33, i32* %37, align 4
  br label %38

38:                                               ; preds = %13
  %39 = load i32, i32* %7, align 4
  %40 = add nsw i32 %39, 1
  store i32 %40, i32* %7, align 4
  br label %8, !llvm.loop !10

41:                                               ; preds = %8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @fun([256 x i32]* noundef getelementptr inbounds ([256 x [256 x i32]], [256 x [256 x i32]]* @main.A, i64 0, i64 0), [256 x i32]* noundef getelementptr inbounds ([256 x [256 x i32]], [256 x [256 x i32]]* @main.B, i64 0, i64 0), [256 x i32]* noundef getelementptr inbounds ([256 x [256 x i32]], [256 x [256 x i32]]* @main.C, i64 0, i64 0))
  call void @filter(i32* noundef getelementptr inbounds ([1024 x i32], [1024 x i32]* @main.X, i64 0, i64 0), i32* noundef getelementptr inbounds ([1024 x i32], [1024 x i32]* @main.Y, i64 0, i64 0), i32 noundef 1024)
  %2 = call i32 @fib(i32 noundef 15)
  ret i32 %2
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Debian clang version 14.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
