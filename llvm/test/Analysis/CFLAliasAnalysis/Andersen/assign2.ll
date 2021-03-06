; This testcase ensures that CFL AA handles assignment in an inclusion-based 
; manner

; RUN: opt < %s -aa-pipeline=cfl-anders-aa -passes=aa-eval -print-all-alias-modref-info -disable-output 2>&1 | FileCheck %s

; CHECK-LABEL: Function: test_assign2
; CHECK: NoAlias: i64* %a, i32* %b
; CHECK: NoAlias: i32* %b, i32* %c
; CHECK: NoAlias: i32* %b, i32* %d
; CHECK: MayAlias: i64* %a, i32* %e
; CHECK: MayAlias: i32* %b, i32* %e
; CHECK: MayAlias: i32* %c, i32* %e
; CHECK: MayAlias: i32* %d, i32* %e
define void @test_assign2(i1 %cond) {
	%a = alloca i64, align 8
	%b = alloca i32, align 4

	%c = bitcast i64* %a to i32*
	%d = bitcast i64* %a to i32*
	%e = select i1 %cond, i32* %c, i32* %b
  load i64, i64* %a
  load i32, i32* %b
  load i32, i32* %c
  load i32, i32* %d
  load i32, i32* %e
	ret void
}
