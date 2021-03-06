; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt < %s -passes=argpromotion -S | FileCheck %s

%struct.ss = type { i32, i64 }

; Don't drop 'byval' on %X here.
define internal void @f(%struct.ss* byval(%struct.ss) align 4 %b, i32* byval(i32) align 4 %X, i32 %i) nounwind {
; CHECK-LABEL: define {{[^@]+}}@f
; CHECK-SAME: (i32 [[B_0:%.*]], i64 [[B_1:%.*]], i32* byval(i32) align 4 [[X:%.*]], i32 [[I:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; CHECK-NEXT:    [[DOT0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B]], i32 0, i32 0
; CHECK-NEXT:    store i32 [[B_0]], i32* [[DOT0]], align 4
; CHECK-NEXT:    [[DOT1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B]], i32 0, i32 1
; CHECK-NEXT:    store i64 [[B_1]], i64* [[DOT1]], align 4
; CHECK-NEXT:    [[TEMP:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B]], i32 0, i32 0
; CHECK-NEXT:    [[TEMP1:%.*]] = load i32, i32* [[TEMP]], align 4
; CHECK-NEXT:    [[TEMP2:%.*]] = add i32 [[TEMP1]], 1
; CHECK-NEXT:    store i32 [[TEMP2]], i32* [[TEMP]], align 4
; CHECK-NEXT:    store i32 0, i32* [[X]], align 4
; CHECK-NEXT:    ret void
;
entry:

  %temp = getelementptr %struct.ss, %struct.ss* %b, i32 0, i32 0
  %temp1 = load i32, i32* %temp, align 4
  %temp2 = add i32 %temp1, 1
  store i32 %temp2, i32* %temp, align 4

  store i32 0, i32* %X
  ret void
}

; Also make sure we don't drop the call zeroext attribute.
define i32 @test(i32* %X) {
; CHECK-LABEL: define {{[^@]+}}@test
; CHECK-SAME: (i32* [[X:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]], align 8
; CHECK-NEXT:    [[TEMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; CHECK-NEXT:    store i32 1, i32* [[TEMP1]], align 8
; CHECK-NEXT:    [[TEMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; CHECK-NEXT:    store i64 2, i64* [[TEMP4]], align 4
; CHECK-NEXT:    [[S_0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; CHECK-NEXT:    [[S_0_VAL:%.*]] = load i32, i32* [[S_0]], align 4
; CHECK-NEXT:    [[S_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; CHECK-NEXT:    [[S_1_VAL:%.*]] = load i64, i64* [[S_1]], align 4
; CHECK-NEXT:    call void @f(i32 [[S_0_VAL]], i64 [[S_1_VAL]], i32* byval(i32) align 4 [[X]], i32 zeroext 0)
; CHECK-NEXT:    ret i32 0
;
entry:
  %S = alloca %struct.ss
  %temp1 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 0
  store i32 1, i32* %temp1, align 8
  %temp4 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 1
  store i64 2, i64* %temp4, align 4

  call void @f( %struct.ss* byval(%struct.ss) align 4 %S, i32* byval(i32) align 4 %X, i32 zeroext 0)

  ret i32 0
}
