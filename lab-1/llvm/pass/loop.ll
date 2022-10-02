; ModuleID = 'pass.bc'
source_filename = "pass.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local constant i32 10, align 4
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @fib(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = load i32, i32* %3, align 4
  %5 = icmp eq i32 %4, 1
  br i1 %5, label %6, label %7

6:                                                ; preds = %1
  store i32 1, i32* %2, align 4
  br label %13

7:                                                ; preds = %1
  %8 = load i32, i32* %3, align 4
  %9 = load i32, i32* %3, align 4
  %10 = sub nsw i32 %9, 1
  %11 = call i32 @fib(i32 noundef %10)
  %12 = mul nsw i32 %8, %11
  store i32 %12, i32* %2, align 4
  br label %13

13:                                               ; preds = %7, %6
  %14 = load i32, i32* %2, align 4
  ret i32 %14
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @bar() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @foo() #0 {
  call void @bar()
  ret void
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %9 = call noalias i8* @malloc(i64 noundef 40) #3
  %10 = bitcast i8* %9 to i32*
  store i32* %10, i32** %2, align 8
  store i32 100, i32* %3, align 4
  %11 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), i32* noundef %4)
  %12 = load i32, i32* %4, align 4
  switch i32 %12, label %32 [
    i32 1, label %13
    i32 2, label %31
  ]

13:                                               ; preds = %0
  store i32 0, i32* %5, align 4
  br label %14

14:                                               ; preds = %27, %13
  %15 = load i32, i32* %5, align 4
  %16 = icmp slt i32 %15, 10
  br i1 %16, label %17, label %30

17:                                               ; preds = %14
  br label %18

18:                                               ; preds = %22, %17
  %19 = load i32, i32* %3, align 4
  %20 = add nsw i32 %19, -1
  store i32 %20, i32* %3, align 4
  %21 = icmp ne i32 %19, 0
  br i1 %21, label %22, label %26

22:                                               ; preds = %18
  %23 = load i32, i32* %3, align 4
  %24 = call i32 @fib(i32 noundef %23)
  %25 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), i32 noundef %24)
  br label %18, !llvm.loop !6

26:                                               ; preds = %18
  br label %27

27:                                               ; preds = %26
  %28 = load i32, i32* %5, align 4
  %29 = add nsw i32 %28, 1
  store i32 %29, i32* %5, align 4
  br label %14, !llvm.loop !8

30:                                               ; preds = %14
  br label %32

31:                                               ; preds = %0
  call void @foo()
  br label %32

32:                                               ; preds = %31, %30, %0
  store i32 0, i32* %6, align 4
  br label %33

33:                                               ; preds = %43, %32
  %34 = load i32, i32* %6, align 4
  %35 = icmp slt i32 %34, 10
  br i1 %35, label %36, label %46

36:                                               ; preds = %33
  %37 = load i32, i32* %6, align 4
  %38 = call i32 @addi(i32 noundef 0, i32 noundef %37)
  %39 = load i32*, i32** %2, align 8
  %40 = load i32, i32* %6, align 4
  %41 = sext i32 %40 to i64
  %42 = getelementptr inbounds i32, i32* %39, i64 %41
  store i32 %38, i32* %42, align 4
  br label %43

43:                                               ; preds = %36
  %44 = load i32, i32* %6, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, i32* %6, align 4
  br label %33, !llvm.loop !9

46:                                               ; preds = %33
  store i32 0, i32* %7, align 4
  store i32 0, i32* %8, align 4
  br label %47

47:                                               ; preds = %54, %46
  %48 = load i32, i32* %8, align 4
  %49 = icmp slt i32 %48, 10
  br i1 %49, label %50, label %57

50:                                               ; preds = %47
  %51 = load i32, i32* %8, align 4
  %52 = load i32, i32* %7, align 4
  %53 = add nsw i32 %52, %51
  store i32 %53, i32* %7, align 4
  br label %54

54:                                               ; preds = %50
  %55 = load i32, i32* %8, align 4
  %56 = add nsw i32 %55, 1
  store i32 %56, i32* %8, align 4
  br label %47, !llvm.loop !10

57:                                               ; preds = %47
  ret i32 0
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #1

declare i32 @__isoc99_scanf(i8* noundef, ...) #2

declare i32 @printf(i8* noundef, ...) #2

declare i32 @addi(i32 noundef, i32 noundef) #2

attributes #0 = { noinline nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 14.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
