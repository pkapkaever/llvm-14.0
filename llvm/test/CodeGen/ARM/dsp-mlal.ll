; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv7m -mattr=+dsp %s -o - | FileCheck %s --check-prefix=DSP
; RUN: llc -mtriple=armv7a %s -o - | FileCheck %s --check-prefix=ARM7
; RUN: llc -mtriple=thumbv7m -mattr=-dsp %s -o - | FileCheck %s --check-prefix=NODSP

define hidden i32 @SMMULR_SMMLAR(i32 %a, i32 %b0, i32 %b1, i32 %Xn, i32 %Xn1) local_unnamed_addr {
; DSP-LABEL: SMMULR_SMMLAR:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    ldr r0, [sp]
; DSP-NEXT:    smmulr r0, r0, r2
; DSP-NEXT:    smmlar r0, r3, r1, r0
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: SMMULR_SMMLAR:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    ldr r0, [sp]
; ARM7-NEXT:    smmulr r0, r0, r2
; ARM7-NEXT:    smmlar r0, r3, r1, r0
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: SMMULR_SMMLAR:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    push {r4, lr}
; NODSP-NEXT:    ldr.w lr, [sp, #8]
; NODSP-NEXT:    movs r0, #0
; NODSP-NEXT:    mov.w r4, #-2147483648
; NODSP-NEXT:    mov.w r12, #-2147483648
; NODSP-NEXT:    smlal r4, r0, lr, r2
; NODSP-NEXT:    smlal r12, r0, r3, r1
; NODSP-NEXT:    pop {r4, pc}
entry:
  %conv = sext i32 %b1 to i64
  %conv1 = sext i32 %Xn1 to i64
  %mul = mul nsw i64 %conv1, %conv
  %add = add nsw i64 %mul, 2147483648
  %0 = and i64 %add, -4294967296
  %conv4 = sext i32 %b0 to i64
  %conv5 = sext i32 %Xn to i64
  %mul6 = mul nsw i64 %conv5, %conv4
  %add7 = add i64 %mul6, 2147483648
  %add8 = add i64 %add7, %0
  %1 = lshr i64 %add8, 32
  %conv10 = trunc i64 %1 to i32
  ret i32 %conv10
}

define hidden i32 @SMMULR(i32 %a, i32 %b) local_unnamed_addr {
; DSP-LABEL: SMMULR:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmulr r0, r1, r0
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: SMMULR:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmulr r0, r1, r0
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: SMMULR:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    movs r2, #0
; NODSP-NEXT:    mov.w r3, #-2147483648
; NODSP-NEXT:    smlal r3, r2, r1, r0
; NODSP-NEXT:    mov r0, r2
; NODSP-NEXT:    bx lr
entry:
  %conv = sext i32 %a to i64
  %conv1 = sext i32 %b to i64
  %mul = mul nsw i64 %conv1, %conv
  %add = add nsw i64 %mul, 2147483648
  %0 = lshr i64 %add, 32
  %conv2 = trunc i64 %0 to i32
  ret i32 %conv2
}

define hidden i32 @SMMUL(i32 %a, i32 %b) local_unnamed_addr {
; DSP-LABEL: SMMUL:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmul r0, r1, r0
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: SMMUL:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmul r0, r1, r0
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: SMMUL:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    smull r1, r0, r1, r0
; NODSP-NEXT:    bx lr
entry:
  %conv = sext i32 %a to i64
  %conv1 = sext i32 %b to i64
  %mul = mul nsw i64 %conv1, %conv
  %0 = lshr i64 %mul, 32
  %conv2 = trunc i64 %0 to i32
  ret i32 %conv2
}

define hidden i32 @SMMLSR(i32 %a, i32 %b, i32 %c) local_unnamed_addr {
; DSP-LABEL: SMMLSR:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmlsr r0, r2, r1, r0
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: SMMLSR:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmlsr r0, r2, r1, r0
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: SMMLSR:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    smull r1, r2, r2, r1
; NODSP-NEXT:    rsbs.w r1, r1, #-2147483648
; NODSP-NEXT:    sbcs r0, r2
; NODSP-NEXT:    bx lr
entry:
  %conv6 = zext i32 %a to i64
  %shl = shl nuw i64 %conv6, 32
  %conv1 = sext i32 %b to i64
  %conv2 = sext i32 %c to i64
  %mul = mul nsw i64 %conv2, %conv1
  %sub = or i64 %shl, 2147483648
  %add = sub i64 %sub, %mul
  %0 = lshr i64 %add, 32
  %conv3 = trunc i64 %0 to i32
  ret i32 %conv3
}

define hidden i32 @NOT_SMMLSR(i32 %a, i32 %b, i32 %c) local_unnamed_addr {
; DSP-LABEL: NOT_SMMLSR:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmulr r1, r2, r1
; DSP-NEXT:    subs r0, r0, r1
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: NOT_SMMLSR:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmulr r1, r2, r1
; ARM7-NEXT:    sub r0, r0, r1
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: NOT_SMMLSR:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    mov.w r12, #0
; NODSP-NEXT:    mov.w r3, #-2147483648
; NODSP-NEXT:    smlal r3, r12, r2, r1
; NODSP-NEXT:    sub.w r0, r0, r12
; NODSP-NEXT:    bx lr
entry:
  %conv = sext i32 %b to i64
  %conv1 = sext i32 %c to i64
  %mul = mul nsw i64 %conv1, %conv
  %add = add nsw i64 %mul, 2147483648
  %0 = lshr i64 %add, 32
  %conv2 = trunc i64 %0 to i32
  %sub = sub nsw i32 %a, %conv2
  ret i32 %sub
}

define hidden i32 @SMMLS(i32 %a, i32 %b, i32 %c) local_unnamed_addr {
; DSP-LABEL: SMMLS:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmls r0, r2, r1, r0
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: SMMLS:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmls r0, r2, r1, r0
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: SMMLS:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    smull r1, r2, r2, r1
; NODSP-NEXT:    rsbs r1, r1, #0
; NODSP-NEXT:    sbcs r0, r2
; NODSP-NEXT:    bx lr
entry:
  %conv5 = zext i32 %a to i64
  %shl = shl nuw i64 %conv5, 32
  %conv1 = sext i32 %b to i64
  %conv2 = sext i32 %c to i64
  %mul = mul nsw i64 %conv2, %conv1
  %sub = sub nsw i64 %shl, %mul
  %0 = lshr i64 %sub, 32
  %conv3 = trunc i64 %0 to i32
  ret i32 %conv3
}

define hidden i32 @NOT_SMMLS(i32 %a, i32 %b, i32 %c) local_unnamed_addr {
; DSP-LABEL: NOT_SMMLS:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmul r1, r2, r1
; DSP-NEXT:    subs r0, r0, r1
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: NOT_SMMLS:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmul r1, r2, r1
; ARM7-NEXT:    sub r0, r0, r1
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: NOT_SMMLS:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    smull r1, r2, r2, r1
; NODSP-NEXT:    subs r0, r0, r2
; NODSP-NEXT:    bx lr
entry:
  %conv = sext i32 %b to i64
  %conv1 = sext i32 %c to i64
  %mul = mul nsw i64 %conv1, %conv
  %0 = lshr i64 %mul, 32
  %conv2 = trunc i64 %0 to i32
  %sub = sub nsw i32 %a, %conv2
  ret i32 %sub
}

define hidden i32 @SMMLA(i32 %a, i32 %b, i32 %c) local_unnamed_addr {
; DSP-LABEL: SMMLA:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmla r0, r1, r2, r0
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: SMMLA:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmla r0, r2, r1, r0
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: SMMLA:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    smull r1, r2, r2, r1
; NODSP-NEXT:    add r0, r2
; NODSP-NEXT:    bx lr
entry:
  %conv = sext i32 %b to i64
  %conv1 = sext i32 %c to i64
  %mul = mul nsw i64 %conv1, %conv
  %0 = lshr i64 %mul, 32
  %conv2 = trunc i64 %0 to i32
  %add = add nsw i32 %conv2, %a
  ret i32 %add
}

define hidden i32 @SMMLAR(i32 %a, i32 %b, i32 %c) local_unnamed_addr {
; DSP-LABEL: SMMLAR:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmlar r0, r2, r1, r0
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: SMMLAR:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmlar r0, r2, r1, r0
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: SMMLAR:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    mov.w r3, #-2147483648
; NODSP-NEXT:    smlal r3, r0, r2, r1
; NODSP-NEXT:    bx lr
entry:
  %conv7 = zext i32 %a to i64
  %shl = shl nuw i64 %conv7, 32
  %conv1 = sext i32 %b to i64
  %conv2 = sext i32 %c to i64
  %mul = mul nsw i64 %conv2, %conv1
  %add = or i64 %shl, 2147483648
  %add3 = add i64 %add, %mul
  %0 = lshr i64 %add3, 32
  %conv4 = trunc i64 %0 to i32
  ret i32 %conv4
}

define hidden i32 @NOT_SMMLA(i32 %a, i32 %b, i32 %c) local_unnamed_addr {
; DSP-LABEL: NOT_SMMLA:
; DSP:       @ %bb.0: @ %entry
; DSP-NEXT:    smmla r0, r1, r2, r0
; DSP-NEXT:    add.w r0, r0, #-2147483648
; DSP-NEXT:    bx lr
;
; ARM7-LABEL: NOT_SMMLA:
; ARM7:       @ %bb.0: @ %entry
; ARM7-NEXT:    smmla r0, r2, r1, r0
; ARM7-NEXT:    add r0, r0, #-2147483648
; ARM7-NEXT:    bx lr
;
; NODSP-LABEL: NOT_SMMLA:
; NODSP:       @ %bb.0: @ %entry
; NODSP-NEXT:    smull r1, r2, r2, r1
; NODSP-NEXT:    add r0, r2
; NODSP-NEXT:    add.w r0, r0, #-2147483648
; NODSP-NEXT:    bx lr
entry:
  %conv = sext i32 %b to i64
  %conv1 = sext i32 %c to i64
  %mul = mul nsw i64 %conv1, %conv
  %0 = lshr i64 %mul, 32
  %conv2 = trunc i64 %0 to i32
  %add = xor i32 %conv2, -2147483648
  %add3 = add i32 %add, %a
  ret i32 %add3
}
