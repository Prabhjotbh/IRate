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
  br i1 %2, label %3, label %4

3:                                                ; preds = %1
  br label %10

4:                                                ; preds = %1
  %5 = add i32 %0, -1
  %6 = call i32 @fib(i32 noundef %5)
  %7 = add i32 %0, -2
  %8 = call i32 @fib(i32 noundef %7)
  %9 = add i32 %6, %8
  br label %10

10:                                               ; preds = %4, %3
  %.0 = phi i32 [ %0, %3 ], [ %9, %4 ]
  ret i32 %.0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @fun([256 x i32]* noundef %0, [256 x i32]* noundef %1, [256 x i32]* noundef %2) #0 {
  br label %4

4:                                                ; preds = %32, %3
  %.03 = phi i32 [ 0, %3 ], [ %33, %32 ]
  %5 = icmp ult i32 %.03, 256
  br i1 %5, label %6, label %34

6:                                                ; preds = %4
  br label %7

7:                                                ; preds = %29, %6
  %.02 = phi i32 [ 0, %6 ], [ %30, %29 ]
  %8 = icmp ult i32 %.02, 256
  br i1 %8, label %9, label %31

9:                                                ; preds = %7
  br label %10

10:                                               ; preds = %13, %9
  %.01 = phi i32 [ 0, %9 ], [ %23, %13 ]
  %.0 = phi i32 [ 0, %9 ], [ %24, %13 ]
  %11 = icmp ult i32 %.0, 256
  br i1 %11, label %12, label %25

12:                                               ; preds = %10
  br label %13

13:                                               ; preds = %12
  %14 = zext i32 %.03 to i64
  %15 = zext i32 %.0 to i64
  %16 = getelementptr inbounds [256 x i32], [256 x i32]* %0, i64 %14, i64 %15
  %17 = load i32, i32* %16, align 4
  %18 = zext i32 %.0 to i64
  %19 = zext i32 %.02 to i64
  %20 = getelementptr inbounds [256 x i32], [256 x i32]* %1, i64 %18, i64 %19
  %21 = load i32, i32* %20, align 4
  %22 = mul nsw i32 %17, %21
  %23 = add nsw i32 %.01, %22
  %24 = add nuw nsw i32 %.0, 1
  br label %10, !llvm.loop !6

25:                                               ; preds = %10
  %26 = zext i32 %.03 to i64
  %27 = zext i32 %.02 to i64
  %28 = getelementptr inbounds [256 x i32], [256 x i32]* %2, i64 %26, i64 %27
  store i32 %.01, i32* %28, align 4
  br label %29

29:                                               ; preds = %25
  %30 = add nuw nsw i32 %.02, 1
  br label %7, !llvm.loop !8

31:                                               ; preds = %7
  br label %32

32:                                               ; preds = %31
  %33 = add nuw nsw i32 %.03, 1
  br label %4, !llvm.loop !9

34:                                               ; preds = %4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @filter(i32* noundef %0, i32* noundef %1, i32 noundef %2) #0 {
  br label %4

4:                                                ; preds = %24, %3
  %.0 = phi i32 [ 1, %3 ], [ %25, %24 ]
  %5 = add nsw i32 %2, -1
  %6 = icmp slt i32 %.0, %5
  br i1 %6, label %7, label %26

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
  %22 = zext i32 %.0 to i64
  %23 = getelementptr inbounds i32, i32* %1, i64 %22
  store i32 %21, i32* %23, align 4
  br label %24

24:                                               ; preds = %7
  %25 = add nuw nsw i32 %.0, 1
  br label %4, !llvm.loop !10

26:                                               ; preds = %4
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
