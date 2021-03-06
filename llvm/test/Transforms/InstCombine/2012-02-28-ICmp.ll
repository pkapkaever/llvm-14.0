; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; <rdar://problem/10803154>

; There should be no transformation.
define i1 @f1(i32 %x) {
; CHECK-LABEL: @f1(
; CHECK-NEXT:    [[A:%.*]] = trunc i32 [[X:%.*]] to i8
; CHECK-NEXT:    [[B:%.*]] = icmp ne i8 [[A]], 0
; CHECK-NEXT:    [[C:%.*]] = and i32 [[X]], 16711680
; CHECK-NEXT:    [[D:%.*]] = icmp ne i32 [[C]], 0
; CHECK-NEXT:    [[E:%.*]] = and i1 [[B]], [[D]]
; CHECK-NEXT:    ret i1 [[E]]
;
  %a = trunc i32 %x to i8
  %b = icmp ne i8 %a, 0
  %c = and i32 %x, 16711680
  %d = icmp ne i32 %c, 0
  %e = and i1 %b, %d
  ret i1 %e
}

define i1 @f1_logical(i32 %x) {
; CHECK-LABEL: @f1_logical(
; CHECK-NEXT:    [[A:%.*]] = trunc i32 [[X:%.*]] to i8
; CHECK-NEXT:    [[B:%.*]] = icmp ne i8 [[A]], 0
; CHECK-NEXT:    [[C:%.*]] = and i32 [[X]], 16711680
; CHECK-NEXT:    [[D:%.*]] = icmp ne i32 [[C]], 0
; CHECK-NEXT:    [[E:%.*]] = and i1 [[B]], [[D]]
; CHECK-NEXT:    ret i1 [[E]]
;
  %a = trunc i32 %x to i8
  %b = icmp ne i8 %a, 0
  %c = and i32 %x, 16711680
  %d = icmp ne i32 %c, 0
  %e = select i1 %b, i1 %d, i1 false
  ret i1 %e
}
