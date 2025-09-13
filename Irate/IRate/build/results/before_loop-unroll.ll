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
  %2 = icmp ult i32 %0, 2
  br i1 %2, label %9, label %3

3:                                                ; preds = %1
  %4 = add i32 %0, -1
  %5 = call i32 @fib(i32 noundef %4)
  %6 = add i32 %0, -2
  %7 = call i32 @fib(i32 noundef %6)
  %8 = add i32 %5, %7
  br label %9

9:                                                ; preds = %1, %3
  %.0 = phi i32 [ %8, %3 ], [ %0, %1 ]
  ret i32 %.0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @fun([256 x i32]* noundef %0, [256 x i32]* noundef %1, [256 x i32]* noundef %2) #0 {
  br label %4

4:                                                ; preds = %26, %3
  %.03 = phi i32 [ 0, %3 ], [ %27, %26 ]
  %5 = icmp ult i32 %.03, 256
  br i1 %5, label %6, label %28

6:                                                ; preds = %4, %21
  %.02 = phi i32 [ %25, %21 ], [ 0, %4 ]
  %7 = icmp ult i32 %.02, 256
  br i1 %7, label %8, label %26

8:                                                ; preds = %6, %10
  %.01 = phi i32 [ %19, %10 ], [ 0, %6 ]
  %.0 = phi i32 [ %20, %10 ], [ 0, %6 ]
  %9 = icmp ult i32 %.0, 256
  br i1 %9, label %10, label %21

10:                                               ; preds = %8
  %11 = zext i32 %.03 to i64
  %12 = zext i32 %.0 to i64
  %13 = getelementptr inbounds [256 x i32], [256 x i32]* %0, i64 %11, i64 %12
  %14 = load i32, i32* %13, align 4
  %15 = zext i32 %.02 to i64
  %16 = getelementptr inbounds [256 x i32], [256 x i32]* %1, i64 %12, i64 %15
  %17 = load i32, i32* %16, align 4
  %18 = mul nsw i32 %14, %17
  %19 = add nsw i32 %.01, %18
  %20 = add nuw nsw i32 %.0, 1
  br label %8, !llvm.loop !6

21:                                               ; preds = %8
  %22 = zext i32 %.03 to i64
  %23 = zext i32 %.02 to i64
  %24 = getelementptr inbounds [256 x i32], [256 x i32]* %2, i64 %22, i64 %23
  store i32 %.01, i32* %24, align 4
  %25 = add nuw nsw i32 %.02, 1
  br label %6, !llvm.loop !8

26:                                               ; preds = %6
  %27 = add nuw nsw i32 %.03, 1
  br label %4, !llvm.loop !9

28:                                               ; preds = %4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @filter(i32* noundef %0, i32* noundef %1, i32 noundef %2) #0 {
  br label %4

4:                                                ; preds = %7, %3
  %.0 = phi i32 [ 1, %3 ], [ %16, %7 ]
  %5 = add nsw i32 %2, -1
  %6 = icmp slt i32 %.0, %5
  br i1 %6, label %7, label %23

7:                                                ; preds = %4
  %8 = add nsw i32 %.0, -1
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds i32, i32* %0, i64 %9
  %11 = load i32, i32* %10, align 4
  %12 = zext i32 %.0 to i64
  %13 = getelementptr inbounds i32, i32* %0, i64 %12
  %14 = load i32, i32* %13, align 4
  %15 = add nsw i32 %11, %14
  %16 = add nuw nsw i32 %.0, 1
  %17 = zext i32 %16 to i64
  %18 = getelementptr inbounds i32, i32* %0, i64 %17
  %19 = load i32, i32* %18, align 4
  %20 = add nsw i32 %15, %19
  %21 = sdiv i32 %20, 3
  %22 = getelementptr inbounds i32, i32* %1, i64 %12
  store i32 %21, i32* %22, align 4
  br label %4, !llvm.loop !10

23:                                               ; preds = %4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  call void @fun([256 x i32]* noundef getelementptr inbounds ([256 x [256 x i32]], [256 x [256 x i32]]* @main.A, i64 0, i64 0), [256 x i32]* noundef getelementptr inbounds ([256 x [256 x i32]], [256 x [256 x i32]]* @main.B, i64 0, i64 0), [256 x i32]* noundef getelementptr inbounds ([256 x [256 x i32]], [256 x [256 x i32]]* @main.C, i64 0, i64 0))
  call void @filter(i32* noundef getelementptr inbounds ([1024 x i32], [1024 x i32]* @main.X, i64 0, i64 0), i32* noundef getelementptr inbounds ([1024 x i32], [1024 x i32]* @main.Y, i64 0, i64 0), i32 noundef 1024)
  %1 = call i32 @fib(i32 noundef 15)
  ret i32 %1
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
