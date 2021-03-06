; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=newgvn -S | FileCheck %s

define i32 @test1(i32 %arg) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[ARG:%.*]], 5
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret i32 [[ARG]]
;
  %cmp = icmp sge i32 %arg, 5
  call void @llvm.assume(i1 %cmp)
  ret i32 %arg
}

define i32 @test2(i32 %arg, i1 %b) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ 1, [[TMP0:%.*]] ], [ 2, [[BB]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ARG:%.*]], [[A]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    br i1 [[B:%.*]], label [[BB]], label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    ret i32 [[ARG]]
;
  br label %bb

bb:
  %a = phi i32 [ 1, %0 ], [ 2, %bb ]
  %cmp = icmp eq i32 %arg, %a
  call void @llvm.assume(i1 %cmp)
  br i1 %b, label %bb, label %end

end:
  ret i32 %arg
}

declare void @llvm.assume(i1 %cond)
