; This test ensures that when linkonce_odr + unnamed_addr symbols & linkonce_odr
; + local_unnamed_addr constants get promoted to weak symbols, we preserves the
; auto hide property when possible.

; RUN: opt -module-summary %s -o %t.bc
; RUN: opt -module-summary %p/Inputs/linkonce_odr_unnamed_addr.ll -o %t2.bc
; Check old LTO API
; RUN: llvm-lto -thinlto-action=thinlink -o %t3.bc %t.bc %t2.bc
; RUN: llvm-lto -thinlto-action=promote %t.bc -thinlto-index=%t3.bc -o - | llvm-dis -o - | FileCheck %s
; Check new LTO API
; RUN: llvm-lto2 run -save-temps -o %t6.bc %t.bc %t2.bc \
; RUN:   -r=%t.bc,linkonceodrunnamedconst,p \
; RUN:   -r=%t.bc,linkonceodrunnamed,p \
; RUN:   -r=%t.bc,linkonceodrlocalunnamedconst,p \
; RUN:   -r=%t.bc,linkonceodrlocalunnamed,p \
; RUN:   -r=%t.bc,odrunnamed,p \
; RUN:   -r=%t2.bc,linkonceodrunnamedconst \
; RUN:   -r=%t2.bc,linkonceodrunnamed \
; RUN:   -r=%t2.bc,linkonceodrlocalunnamedconst \
; RUN:   -r=%t2.bc,linkonceodrlocalunnamed \
; RUN:   -r=%t2.bc,odrunnamed
; RUN: llvm-dis %t6.bc.1.1.promote.bc -o - | FileCheck %s

; Now test when one module does not have a summary. In that case we must be
; conservative and not auto hide.
; RUN: opt %p/Inputs/linkonce_odr_unnamed_addr.ll -o %t4.bc
; Check new LTO API (old LTO API does not detect this case).
; RUN: llvm-lto2 run -save-temps -o %t6.bc %t.bc %t4.bc \
; RUN:   -r=%t.bc,linkonceodrunnamedconst,p \
; RUN:   -r=%t.bc,linkonceodrunnamed,p \
; RUN:   -r=%t.bc,linkonceodrlocalunnamedconst,p \
; RUN:   -r=%t.bc,linkonceodrlocalunnamed,p \
; RUN:   -r=%t.bc,odrunnamed,p \
; RUN:   -r=%t4.bc,linkonceodrunnamedconst \
; RUN:   -r=%t4.bc,linkonceodrunnamed \
; RUN:   -r=%t4.bc,linkonceodrlocalunnamedconst \
; RUN:   -r=%t4.bc,linkonceodrlocalunnamed \
; RUN:   -r=%t4.bc,odrunnamed
; RUN: llvm-dis %t6.bc.1.1.promote.bc -o - | FileCheck %s --check-prefix=NOSUMMARY

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-grtev4-linux-gnu"

; In this case all copies are linkonce_odr, so it may be hidden.
; CHECK: @linkonceodrunnamedconst = weak_odr hidden unnamed_addr constant i32 0
; CHECK: @linkonceodrunnamed = weak_odr hidden unnamed_addr global i32 0
; CHECK: @linkonceodrlocalunnamedconst = weak_odr hidden local_unnamed_addr constant i32 0
; NOSUMMARY: @linkonceodrunnamedconst = weak_odr unnamed_addr constant i32 0
; NOSUMMARY: @linkonceodrunnamed = weak_odr unnamed_addr global i32 0
; NOSUMMARY: @linkonceodrlocalunnamedconst = weak_odr local_unnamed_addr constant i32 0
@linkonceodrunnamedconst = linkonce_odr unnamed_addr constant i32 0
@linkonceodrunnamed = linkonce_odr unnamed_addr global i32 0
@linkonceodrlocalunnamedconst = linkonce_odr local_unnamed_addr constant i32 0

; In this case, the other copy was weak_odr, so it may not be hidden.
; CHECK: @odrunnamed = weak_odr unnamed_addr constant i32 0
; NOSUMMARY: @odrunnamed = weak_odr unnamed_addr constant i32 0
@odrunnamed = linkonce_odr unnamed_addr constant i32 0

; local_unnamed_addr globals cannot be hidden.
; CHECK: @linkonceodrlocalunnamed = weak_odr local_unnamed_addr global i32 0
; NOSUMMARY: @linkonceodrlocalunnamed = weak_odr local_unnamed_addr global i32 0
@linkonceodrlocalunnamed = linkonce_odr local_unnamed_addr global i32 0
