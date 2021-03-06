; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=knl | FileCheck %s --check-prefix=CHECK --check-prefix=KNL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=skx | FileCheck %s --check-prefix=CHECK --check-prefix=SKX

declare <16 x i32> @llvm.x86.avx512.mask.prolv.d.512(<16 x i32>, <16 x i32>, <16 x i32>, i16)
declare <16 x i32> @llvm.x86.avx512.mask.prorv.d.512(<16 x i32>, <16 x i32>, <16 x i32>, i16)
declare <8 x i64> @llvm.x86.avx512.mask.prolv.q.512(<8 x i64>, <8 x i64>, <8 x i64>, i8)
declare <8 x i64> @llvm.x86.avx512.mask.prorv.q.512(<8 x i64>, <8 x i64>, <8 x i64>, i8)

declare <8 x i64> @llvm.x86.avx512.maskz.vpermt2var.q.512(<8 x i64>, <8 x i64>, <8 x i64>, i8)
declare <16 x i32> @llvm.x86.avx512.maskz.vpermt2var.d.512(<16 x i32>, <16 x i32>, <16 x i32>, i16)

; Tests showing replacement of variable rotates with immediate splat versions.

define { <16 x i32>, <16 x i32>, <16 x i32> } @test_splat_rol_v16i32(<16 x i32> %x0, <16 x i32> %x1, i16 %x2) {
; KNL-LABEL: test_splat_rol_v16i32:
; KNL:       # %bb.0:
; KNL-NEXT:    vmovdqa64 %zmm1, %zmm3
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vprold $5, %zmm0, %zmm3 {%k1}
; KNL-NEXT:    vprold $6, %zmm0, %zmm1 {%k1} {z}
; KNL-NEXT:    vprold $7, %zmm0, %zmm2
; KNL-NEXT:    vmovdqa64 %zmm3, %zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: test_splat_rol_v16i32:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovdqa64 %zmm1, %zmm3
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vprold $5, %zmm0, %zmm3 {%k1}
; SKX-NEXT:    vprold $6, %zmm0, %zmm1 {%k1} {z}
; SKX-NEXT:    vprold $7, %zmm0, %zmm2
; SKX-NEXT:    vmovdqa64 %zmm3, %zmm0
; SKX-NEXT:    retq
  %res0 = call <16 x i32> @llvm.x86.avx512.mask.prolv.d.512(<16 x i32> %x0, <16 x i32> <i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5>, <16 x i32> %x1, i16 %x2)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.prolv.d.512(<16 x i32> %x0, <16 x i32> <i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6>, <16 x i32> zeroinitializer, i16 %x2)
  %res2 = call <16 x i32> @llvm.x86.avx512.mask.prolv.d.512(<16 x i32> %x0, <16 x i32> <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>, <16 x i32> %x1, i16 -1)
  %res3 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> } poison, <16 x i32> %res0, 0
  %res4 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> }  %res3, <16 x i32> %res1, 1
  %res5 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> }  %res4, <16 x i32> %res2, 2
  ret { <16 x i32>, <16 x i32>, <16 x i32> } %res5
}

define { <8 x i64>, <8 x i64>, <8 x i64> } @test_splat_rol_v8i64(<8 x i64> %x0, <8 x i64> %x1, i8 %x2) {
; KNL-LABEL: test_splat_rol_v8i64:
; KNL:       # %bb.0:
; KNL-NEXT:    vmovdqa64 %zmm1, %zmm3
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vprolq $5, %zmm0, %zmm3 {%k1}
; KNL-NEXT:    vprolq $6, %zmm0, %zmm1 {%k1} {z}
; KNL-NEXT:    vprolq $7, %zmm0, %zmm2
; KNL-NEXT:    vmovdqa64 %zmm3, %zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: test_splat_rol_v8i64:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovdqa64 %zmm1, %zmm3
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vprolq $5, %zmm0, %zmm3 {%k1}
; SKX-NEXT:    vprolq $6, %zmm0, %zmm1 {%k1} {z}
; SKX-NEXT:    vprolq $7, %zmm0, %zmm2
; SKX-NEXT:    vmovdqa64 %zmm3, %zmm0
; SKX-NEXT:    retq
  %res0 = call <8 x i64> @llvm.x86.avx512.mask.prolv.q.512(<8 x i64> %x0, <8 x i64> <i64 5, i64 5, i64 5, i64 5, i64 5, i64 5, i64 5, i64 5>, <8 x i64> %x1, i8 %x2)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.prolv.q.512(<8 x i64> %x0, <8 x i64> <i64 6, i64 6, i64 6, i64 6, i64 6, i64 6, i64 6, i64 6>, <8 x i64> zeroinitializer, i8 %x2)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.prolv.q.512(<8 x i64> %x0, <8 x i64> <i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7>, <8 x i64> %x1, i8 -1)
  %res3 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> } poison, <8 x i64> %res0, 0
  %res4 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> }  %res3, <8 x i64> %res1, 1
  %res5 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> }  %res4, <8 x i64> %res2, 2
  ret { <8 x i64>, <8 x i64>, <8 x i64> } %res5
}

define { <16 x i32>, <16 x i32>, <16 x i32> } @test_splat_ror_v16i32(<16 x i32> %x0, <16 x i32> %x1, i16 %x2) {
; KNL-LABEL: test_splat_ror_v16i32:
; KNL:       # %bb.0:
; KNL-NEXT:    vmovdqa64 %zmm1, %zmm3
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vprord $5, %zmm0, %zmm3 {%k1}
; KNL-NEXT:    vprord $6, %zmm0, %zmm1 {%k1} {z}
; KNL-NEXT:    vprord $7, %zmm0, %zmm2
; KNL-NEXT:    vmovdqa64 %zmm3, %zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: test_splat_ror_v16i32:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovdqa64 %zmm1, %zmm3
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vprord $5, %zmm0, %zmm3 {%k1}
; SKX-NEXT:    vprord $6, %zmm0, %zmm1 {%k1} {z}
; SKX-NEXT:    vprord $7, %zmm0, %zmm2
; SKX-NEXT:    vmovdqa64 %zmm3, %zmm0
; SKX-NEXT:    retq
  %res0 = call <16 x i32> @llvm.x86.avx512.mask.prorv.d.512(<16 x i32> %x0, <16 x i32> <i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5>, <16 x i32> %x1, i16 %x2)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.prorv.d.512(<16 x i32> %x0, <16 x i32> <i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6>, <16 x i32> zeroinitializer, i16 %x2)
  %res2 = call <16 x i32> @llvm.x86.avx512.mask.prorv.d.512(<16 x i32> %x0, <16 x i32> <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>, <16 x i32> %x1, i16 -1)
  %res3 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> } poison, <16 x i32> %res0, 0
  %res4 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> }  %res3, <16 x i32> %res1, 1
  %res5 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> }  %res4, <16 x i32> %res2, 2
  ret { <16 x i32>, <16 x i32>, <16 x i32> } %res5
}

define { <8 x i64>, <8 x i64>, <8 x i64> } @test_splat_ror_v8i64(<8 x i64> %x0, <8 x i64> %x1, i8 %x2) {
; KNL-LABEL: test_splat_ror_v8i64:
; KNL:       # %bb.0:
; KNL-NEXT:    vmovdqa64 %zmm1, %zmm3
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vprorq $5, %zmm0, %zmm3 {%k1}
; KNL-NEXT:    vprorq $6, %zmm0, %zmm1 {%k1} {z}
; KNL-NEXT:    vprorq $7, %zmm0, %zmm2
; KNL-NEXT:    vmovdqa64 %zmm3, %zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: test_splat_ror_v8i64:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovdqa64 %zmm1, %zmm3
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vprorq $5, %zmm0, %zmm3 {%k1}
; SKX-NEXT:    vprorq $6, %zmm0, %zmm1 {%k1} {z}
; SKX-NEXT:    vprorq $7, %zmm0, %zmm2
; SKX-NEXT:    vmovdqa64 %zmm3, %zmm0
; SKX-NEXT:    retq
  %res0 = call <8 x i64> @llvm.x86.avx512.mask.prorv.q.512(<8 x i64> %x0, <8 x i64> <i64 5, i64 5, i64 5, i64 5, i64 5, i64 5, i64 5, i64 5>, <8 x i64> %x1, i8 %x2)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.prorv.q.512(<8 x i64> %x0, <8 x i64> <i64 6, i64 6, i64 6, i64 6, i64 6, i64 6, i64 6, i64 6>, <8 x i64> zeroinitializer, i8 %x2)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.prorv.q.512(<8 x i64> %x0, <8 x i64> <i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7>, <8 x i64> %x1, i8 -1)
  %res3 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> } poison, <8 x i64> %res0, 0
  %res4 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> }  %res3, <8 x i64> %res1, 1
  %res5 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> }  %res4, <8 x i64> %res2, 2
  ret { <8 x i64>, <8 x i64>, <8 x i64> } %res5
}

; Tests showing replacement of out-of-bounds variable rotates with in-bounds immediate splat versions.

define { <16 x i32>, <16 x i32>, <16 x i32> } @test_splat_bounds_rol_v16i32(<16 x i32> %x0, <16 x i32> %x1, i16 %x2) {
; KNL-LABEL: test_splat_bounds_rol_v16i32:
; KNL:       # %bb.0:
; KNL-NEXT:    vmovdqa64 %zmm1, %zmm3
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vprold $1, %zmm0, %zmm3 {%k1}
; KNL-NEXT:    vprold $31, %zmm0, %zmm1 {%k1} {z}
; KNL-NEXT:    vprold $30, %zmm0, %zmm2
; KNL-NEXT:    vmovdqa64 %zmm3, %zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: test_splat_bounds_rol_v16i32:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovdqa64 %zmm1, %zmm3
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vprold $1, %zmm0, %zmm3 {%k1}
; SKX-NEXT:    vprold $31, %zmm0, %zmm1 {%k1} {z}
; SKX-NEXT:    vprold $30, %zmm0, %zmm2
; SKX-NEXT:    vmovdqa64 %zmm3, %zmm0
; SKX-NEXT:    retq
  %res0 = call <16 x i32> @llvm.x86.avx512.mask.prolv.d.512(<16 x i32> %x0, <16 x i32> <i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33>, <16 x i32> %x1, i16 %x2)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.prolv.d.512(<16 x i32> %x0, <16 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, <16 x i32> zeroinitializer, i16 %x2)
  %res2 = call <16 x i32> @llvm.x86.avx512.mask.prolv.d.512(<16 x i32> %x0, <16 x i32> <i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534>, <16 x i32> %x1, i16 -1)
  %res3 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> } poison, <16 x i32> %res0, 0
  %res4 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> }  %res3, <16 x i32> %res1, 1
  %res5 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> }  %res4, <16 x i32> %res2, 2
  ret { <16 x i32>, <16 x i32>, <16 x i32> } %res5
}

define { <8 x i64>, <8 x i64>, <8 x i64> } @test_splat_bounds_rol_v8i64(<8 x i64> %x0, <8 x i64> %x1, i8 %x2) {
; KNL-LABEL: test_splat_bounds_rol_v8i64:
; KNL:       # %bb.0:
; KNL-NEXT:    vmovdqa64 %zmm1, %zmm3
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vprolq $62, %zmm0, %zmm3 {%k1}
; KNL-NEXT:    vprolq $1, %zmm0, %zmm1 {%k1} {z}
; KNL-NEXT:    vprolq $63, %zmm0, %zmm2
; KNL-NEXT:    vmovdqa64 %zmm3, %zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: test_splat_bounds_rol_v8i64:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovdqa64 %zmm1, %zmm3
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vprolq $62, %zmm0, %zmm3 {%k1}
; SKX-NEXT:    vprolq $1, %zmm0, %zmm1 {%k1} {z}
; SKX-NEXT:    vprolq $63, %zmm0, %zmm2
; SKX-NEXT:    vmovdqa64 %zmm3, %zmm0
; SKX-NEXT:    retq
  %res0 = call <8 x i64> @llvm.x86.avx512.mask.prolv.q.512(<8 x i64> %x0, <8 x i64> <i64 65534, i64 65534, i64 65534, i64 65534, i64 65534, i64 65534, i64 65534, i64 65534>, <8 x i64> %x1, i8 %x2)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.prolv.q.512(<8 x i64> %x0, <8 x i64> <i64 65, i64 65, i64 65, i64 65, i64 65, i64 65, i64 65, i64 65>, <8 x i64> zeroinitializer, i8 %x2)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.prolv.q.512(<8 x i64> %x0, <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>, <8 x i64> %x1, i8 -1)
  %res3 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> } poison, <8 x i64> %res0, 0
  %res4 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> }  %res3, <8 x i64> %res1, 1
  %res5 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> }  %res4, <8 x i64> %res2, 2
  ret { <8 x i64>, <8 x i64>, <8 x i64> } %res5
}

define { <16 x i32>, <16 x i32>, <16 x i32> } @test_splat_bounds_ror_v16i32(<16 x i32> %x0, <16 x i32> %x1, i16 %x2) {
; KNL-LABEL: test_splat_bounds_ror_v16i32:
; KNL:       # %bb.0:
; KNL-NEXT:    vmovdqa64 %zmm1, %zmm3
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vprord $1, %zmm0, %zmm3 {%k1}
; KNL-NEXT:    vprord $31, %zmm0, %zmm1 {%k1} {z}
; KNL-NEXT:    vprord $30, %zmm0, %zmm2
; KNL-NEXT:    vmovdqa64 %zmm3, %zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: test_splat_bounds_ror_v16i32:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovdqa64 %zmm1, %zmm3
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vprord $1, %zmm0, %zmm3 {%k1}
; SKX-NEXT:    vprord $31, %zmm0, %zmm1 {%k1} {z}
; SKX-NEXT:    vprord $30, %zmm0, %zmm2
; SKX-NEXT:    vmovdqa64 %zmm3, %zmm0
; SKX-NEXT:    retq
  %res0 = call <16 x i32> @llvm.x86.avx512.mask.prorv.d.512(<16 x i32> %x0, <16 x i32> <i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33, i32 33>, <16 x i32> %x1, i16 %x2)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.prorv.d.512(<16 x i32> %x0, <16 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, <16 x i32> zeroinitializer, i16 %x2)
  %res2 = call <16 x i32> @llvm.x86.avx512.mask.prorv.d.512(<16 x i32> %x0, <16 x i32> <i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534, i32 65534>, <16 x i32> %x1, i16 -1)
  %res3 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> } poison, <16 x i32> %res0, 0
  %res4 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> }  %res3, <16 x i32> %res1, 1
  %res5 = insertvalue { <16 x i32>, <16 x i32>, <16 x i32> }  %res4, <16 x i32> %res2, 2
  ret { <16 x i32>, <16 x i32>, <16 x i32> } %res5
}

define { <8 x i64>, <8 x i64>, <8 x i64> } @test_splat_bounds_ror_v8i64(<8 x i64> %x0, <8 x i64> %x1, i8 %x2) {
; KNL-LABEL: test_splat_bounds_ror_v8i64:
; KNL:       # %bb.0:
; KNL-NEXT:    vmovdqa64 %zmm1, %zmm3
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vprorq $62, %zmm0, %zmm3 {%k1}
; KNL-NEXT:    vprorq $1, %zmm0, %zmm1 {%k1} {z}
; KNL-NEXT:    vprorq $63, %zmm0, %zmm2
; KNL-NEXT:    vmovdqa64 %zmm3, %zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: test_splat_bounds_ror_v8i64:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovdqa64 %zmm1, %zmm3
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vprorq $62, %zmm0, %zmm3 {%k1}
; SKX-NEXT:    vprorq $1, %zmm0, %zmm1 {%k1} {z}
; SKX-NEXT:    vprorq $63, %zmm0, %zmm2
; SKX-NEXT:    vmovdqa64 %zmm3, %zmm0
; SKX-NEXT:    retq
  %res0 = call <8 x i64> @llvm.x86.avx512.mask.prorv.q.512(<8 x i64> %x0, <8 x i64> <i64 65534, i64 65534, i64 65534, i64 65534, i64 65534, i64 65534, i64 65534, i64 65534>, <8 x i64> %x1, i8 %x2)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.prorv.q.512(<8 x i64> %x0, <8 x i64> <i64 65, i64 65, i64 65, i64 65, i64 65, i64 65, i64 65, i64 65>, <8 x i64> zeroinitializer, i8 %x2)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.prorv.q.512(<8 x i64> %x0, <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>, <8 x i64> %x1, i8 -1)
  %res3 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> } poison, <8 x i64> %res0, 0
  %res4 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> }  %res3, <8 x i64> %res1, 1
  %res5 = insertvalue { <8 x i64>, <8 x i64>, <8 x i64> }  %res4, <8 x i64> %res2, 2
  ret { <8 x i64>, <8 x i64>, <8 x i64> } %res5
}

; Constant folding
; We also test with a target shuffle so that this can't be constant folded upon creation, it must
; wait until the target shuffle has been constant folded in combineX86ShufflesRecursively.

define <8 x i64> @test_fold_rol_v8i64() {
; CHECK-LABEL: test_fold_rol_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps {{.*#+}} zmm0 = [1,2,4,9223372036854775808,2,4611686018427387904,9223372036854775808,9223372036854775808]
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.prolv.q.512(<8 x i64> <i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1>, <8 x i64> <i64 0, i64 1, i64 2, i64 63, i64 65, i64 65534, i64 65535, i64 -1>, <8 x i64> zeroinitializer, i8 -1)
  ret <8 x i64> %res
}

define <16 x i32> @test_fold_rol_v16i32(<16 x i32> %x0, <16 x i32> %x1) {
; CHECK-LABEL: test_fold_rol_v16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} zmm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; CHECK-NEXT:    vprolvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %res0 = call <16 x i32> @llvm.x86.avx512.maskz.vpermt2var.d.512(<16 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8>, <16 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, <16 x i32> zeroinitializer, i16 -1)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.prolv.d.512(<16 x i32> %res0, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>, <16 x i32> zeroinitializer, i16 -1)
  ret <16 x i32> %res1
}

define <8 x i64> @test_fold_ror_v8i64() {
; CHECK-LABEL: test_fold_ror_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastq {{.*#+}} zmm0 = [1,1,1,1,1,1,1,1]
; CHECK-NEXT:    vprorvq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %res0 = call <8 x i64> @llvm.x86.avx512.maskz.vpermt2var.q.512(<8 x i64> <i64 undef, i64 6, i64 5, i64 4, i64 3, i64 2, i64 1, i64 0>, <8 x i64> <i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1>, <8 x i64> zeroinitializer, i8 -1)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.prorv.q.512(<8 x i64> %res0, <8 x i64> <i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7>, <8 x i64> zeroinitializer, i8 -1)
  ret <8 x i64> %res1
}

define <16 x i32> @test_fold_ror_v16i32(<16 x i32> %x0, <16 x i32> %x1) {
; CHECK-LABEL: test_fold_ror_v16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} zmm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; CHECK-NEXT:    vprorvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %res0 = call <16 x i32> @llvm.x86.avx512.maskz.vpermt2var.d.512(<16 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8>, <16 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, <16 x i32> zeroinitializer, i16 -1)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.prorv.d.512(<16 x i32> %res0, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>, <16 x i32> zeroinitializer, i16 -1)
  ret <16 x i32> %res1
}
