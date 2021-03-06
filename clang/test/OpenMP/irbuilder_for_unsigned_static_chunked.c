// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature --include-generated-funcs
// RUN: %clang_cc1 -fopenmp-enable-irbuilder -verify -fopenmp -fopenmp-version=45 -x c++ -triple x86_64-unknown-unknown -emit-llvm %s -o - | FileCheck %s
// expected-no-diagnostics

#ifndef HEADER
#define HEADER

// CHECK-LABEL: define {{.*}}@workshareloop_unsigned_static_chunked(
// CHECK-NEXT:  [[ENTRY:.*]]:
// CHECK-NEXT:    %[[A_ADDR:.+]] = alloca float*, align 8
// CHECK-NEXT:    %[[B_ADDR:.+]] = alloca float*, align 8
// CHECK-NEXT:    %[[C_ADDR:.+]] = alloca float*, align 8
// CHECK-NEXT:    %[[D_ADDR:.+]] = alloca float*, align 8
// CHECK-NEXT:    %[[I:.+]] = alloca i32, align 4
// CHECK-NEXT:    %[[AGG_CAPTURED:.+]] = alloca %struct.anon, align 8
// CHECK-NEXT:    %[[AGG_CAPTURED1:.+]] = alloca %struct.anon.0, align 4
// CHECK-NEXT:    %[[DOTCOUNT_ADDR:.+]] = alloca i32, align 4
// CHECK-NEXT:    %[[P_LASTITER:.+]] = alloca i32, align 4
// CHECK-NEXT:    %[[P_LOWERBOUND:.+]] = alloca i32, align 4
// CHECK-NEXT:    %[[P_UPPERBOUND:.+]] = alloca i32, align 4
// CHECK-NEXT:    %[[P_STRIDE:.+]] = alloca i32, align 4
// CHECK-NEXT:    store float* %[[A:.+]], float** %[[A_ADDR]], align 8
// CHECK-NEXT:    store float* %[[B:.+]], float** %[[B_ADDR]], align 8
// CHECK-NEXT:    store float* %[[C:.+]], float** %[[C_ADDR]], align 8
// CHECK-NEXT:    store float* %[[D:.+]], float** %[[D_ADDR]], align 8
// CHECK-NEXT:    store i32 33, i32* %[[I]], align 4
// CHECK-NEXT:    %[[TMP0:.+]] = getelementptr inbounds %struct.anon, %struct.anon* %[[AGG_CAPTURED]], i32 0, i32 0
// CHECK-NEXT:    store i32* %[[I]], i32** %[[TMP0]], align 8
// CHECK-NEXT:    %[[TMP1:.+]] = getelementptr inbounds %struct.anon.0, %struct.anon.0* %[[AGG_CAPTURED1]], i32 0, i32 0
// CHECK-NEXT:    %[[TMP2:.+]] = load i32, i32* %[[I]], align 4
// CHECK-NEXT:    store i32 %[[TMP2]], i32* %[[TMP1]], align 4
// CHECK-NEXT:    call void @__captured_stmt(i32* %[[DOTCOUNT_ADDR]], %struct.anon* %[[AGG_CAPTURED]])
// CHECK-NEXT:    %[[DOTCOUNT:.+]] = load i32, i32* %[[DOTCOUNT_ADDR]], align 4
// CHECK-NEXT:    br label %[[OMP_LOOP_PREHEADER:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_LOOP_PREHEADER]]:
// CHECK-NEXT:    store i32 0, i32* %[[P_LOWERBOUND]], align 4
// CHECK-NEXT:    %[[TMP3:.+]] = sub i32 %[[DOTCOUNT]], 1
// CHECK-NEXT:    store i32 %[[TMP3]], i32* %[[P_UPPERBOUND]], align 4
// CHECK-NEXT:    store i32 1, i32* %[[P_STRIDE]], align 4
// CHECK-NEXT:    %[[OMP_GLOBAL_THREAD_NUM:.+]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* @1)
// CHECK-NEXT:    call void @__kmpc_for_static_init_4u(%struct.ident_t* @1, i32 %[[OMP_GLOBAL_THREAD_NUM]], i32 33, i32* %[[P_LASTITER]], i32* %[[P_LOWERBOUND]], i32* %[[P_UPPERBOUND]], i32* %[[P_STRIDE]], i32 1, i32 5)
// CHECK-NEXT:    %[[OMP_FIRSTCHUNK_LB:.+]] = load i32, i32* %[[P_LOWERBOUND]], align 4
// CHECK-NEXT:    %[[OMP_FIRSTCHUNK_UB:.+]] = load i32, i32* %[[P_UPPERBOUND]], align 4
// CHECK-NEXT:    %[[TMP4:.+]] = add i32 %[[OMP_FIRSTCHUNK_UB]], 1
// CHECK-NEXT:    %[[OMP_CHUNK_RANGE:.+]] = sub i32 %[[TMP4]], %[[OMP_FIRSTCHUNK_LB]]
// CHECK-NEXT:    %[[OMP_DISPATCH_STRIDE:.+]] = load i32, i32* %[[P_STRIDE]], align 4
// CHECK-NEXT:    %[[TMP5:.+]] = sub nuw i32 %[[DOTCOUNT]], %[[OMP_FIRSTCHUNK_LB]]
// CHECK-NEXT:    %[[TMP6:.+]] = icmp ule i32 %[[DOTCOUNT]], %[[OMP_FIRSTCHUNK_LB]]
// CHECK-NEXT:    %[[TMP7:.+]] = sub i32 %[[TMP5]], 1
// CHECK-NEXT:    %[[TMP8:.+]] = udiv i32 %[[TMP7]], %[[OMP_DISPATCH_STRIDE]]
// CHECK-NEXT:    %[[TMP9:.+]] = add i32 %[[TMP8]], 1
// CHECK-NEXT:    %[[TMP10:.+]] = icmp ule i32 %[[TMP5]], %[[OMP_DISPATCH_STRIDE]]
// CHECK-NEXT:    %[[TMP11:.+]] = select i1 %[[TMP10]], i32 1, i32 %[[TMP9]]
// CHECK-NEXT:    %[[OMP_DISPATCH_TRIPCOUNT:.+]] = select i1 %[[TMP6]], i32 0, i32 %[[TMP11]]
// CHECK-NEXT:    br label %[[OMP_DISPATCH_PREHEADER:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_DISPATCH_PREHEADER]]:
// CHECK-NEXT:    br label %[[OMP_DISPATCH_HEADER:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_DISPATCH_HEADER]]:
// CHECK-NEXT:    %[[OMP_DISPATCH_IV:.+]] = phi i32 [ 0, %[[OMP_DISPATCH_PREHEADER]] ], [ %[[OMP_DISPATCH_NEXT:.+]], %[[OMP_DISPATCH_INC:.+]] ]
// CHECK-NEXT:    br label %[[OMP_DISPATCH_COND:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_DISPATCH_COND]]:
// CHECK-NEXT:    %[[OMP_DISPATCH_CMP:.+]] = icmp ult i32 %[[OMP_DISPATCH_IV]], %[[OMP_DISPATCH_TRIPCOUNT]]
// CHECK-NEXT:    br i1 %[[OMP_DISPATCH_CMP]], label %[[OMP_DISPATCH_BODY:.+]], label %[[OMP_DISPATCH_EXIT:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_DISPATCH_BODY]]:
// CHECK-NEXT:    %[[TMP12:.+]] = mul i32 %[[OMP_DISPATCH_IV]], %[[OMP_DISPATCH_STRIDE]]
// CHECK-NEXT:    %[[TMP13:.+]] = add i32 %[[TMP12]], %[[OMP_FIRSTCHUNK_LB]]
// CHECK-NEXT:    br label %[[OMP_LOOP_PREHEADER9:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_DISPATCH_INC]]:
// CHECK-NEXT:    %[[OMP_DISPATCH_NEXT]] = add nuw i32 %[[OMP_DISPATCH_IV]], 1
// CHECK-NEXT:    br label %[[OMP_DISPATCH_HEADER]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_DISPATCH_EXIT]]:
// CHECK-NEXT:    call void @__kmpc_for_static_fini(%struct.ident_t* @1, i32 %[[OMP_GLOBAL_THREAD_NUM]])
// CHECK-NEXT:    %[[OMP_GLOBAL_THREAD_NUM10:.+]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* @1)
// CHECK-NEXT:    call void @__kmpc_barrier(%struct.ident_t* @2, i32 %[[OMP_GLOBAL_THREAD_NUM10]])
// CHECK-NEXT:    br label %[[OMP_DISPATCH_AFTER:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_DISPATCH_AFTER]]:
// CHECK-NEXT:    br label %[[OMP_LOOP_AFTER:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_LOOP_PREHEADER9]]:
// CHECK-NEXT:    %[[TMP14:.+]] = add i32 %[[TMP13]], %[[OMP_CHUNK_RANGE]]
// CHECK-NEXT:    %[[OMP_CHUNK_IS_LAST:.+]] = icmp uge i32 %[[TMP14]], %[[DOTCOUNT]]
// CHECK-NEXT:    %[[TMP15:.+]] = sub i32 %[[DOTCOUNT]], %[[TMP13]]
// CHECK-NEXT:    %[[OMP_CHUNK_TRIPCOUNT:.+]] = select i1 %[[OMP_CHUNK_IS_LAST]], i32 %[[TMP15]], i32 %[[OMP_CHUNK_RANGE]]
// CHECK-NEXT:    br label %[[OMP_LOOP_HEADER:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_LOOP_HEADER]]:
// CHECK-NEXT:    %[[OMP_LOOP_IV:.+]] = phi i32 [ 0, %[[OMP_LOOP_PREHEADER9]] ], [ %[[OMP_LOOP_NEXT:.+]], %[[OMP_LOOP_INC:.+]] ]
// CHECK-NEXT:    br label %[[OMP_LOOP_COND:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_LOOP_COND]]:
// CHECK-NEXT:    %[[OMP_LOOP_CMP:.+]] = icmp ult i32 %[[OMP_LOOP_IV]], %[[OMP_CHUNK_TRIPCOUNT]]
// CHECK-NEXT:    br i1 %[[OMP_LOOP_CMP]], label %[[OMP_LOOP_BODY:.+]], label %[[OMP_LOOP_EXIT:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_LOOP_BODY]]:
// CHECK-NEXT:    %[[TMP16:.+]] = add i32 %[[OMP_LOOP_IV]], %[[TMP13]]
// CHECK-NEXT:    call void @__captured_stmt.1(i32* %[[I]], i32 %[[TMP16]], %struct.anon.0* %[[AGG_CAPTURED1]])
// CHECK-NEXT:    %[[TMP17:.+]] = load float*, float** %[[B_ADDR]], align 8
// CHECK-NEXT:    %[[TMP18:.+]] = load i32, i32* %[[I]], align 4
// CHECK-NEXT:    %[[IDXPROM:.+]] = zext i32 %[[TMP18]] to i64
// CHECK-NEXT:    %[[ARRAYIDX:.+]] = getelementptr inbounds float, float* %[[TMP17]], i64 %[[IDXPROM]]
// CHECK-NEXT:    %[[TMP19:.+]] = load float, float* %[[ARRAYIDX]], align 4
// CHECK-NEXT:    %[[TMP20:.+]] = load float*, float** %[[C_ADDR]], align 8
// CHECK-NEXT:    %[[TMP21:.+]] = load i32, i32* %[[I]], align 4
// CHECK-NEXT:    %[[IDXPROM2:.+]] = zext i32 %[[TMP21]] to i64
// CHECK-NEXT:    %[[ARRAYIDX3:.+]] = getelementptr inbounds float, float* %[[TMP20]], i64 %[[IDXPROM2]]
// CHECK-NEXT:    %[[TMP22:.+]] = load float, float* %[[ARRAYIDX3]], align 4
// CHECK-NEXT:    %[[MUL:.+]] = fmul float %[[TMP19]], %[[TMP22]]
// CHECK-NEXT:    %[[TMP23:.+]] = load float*, float** %[[D_ADDR]], align 8
// CHECK-NEXT:    %[[TMP24:.+]] = load i32, i32* %[[I]], align 4
// CHECK-NEXT:    %[[IDXPROM4:.+]] = zext i32 %[[TMP24]] to i64
// CHECK-NEXT:    %[[ARRAYIDX5:.+]] = getelementptr inbounds float, float* %[[TMP23]], i64 %[[IDXPROM4]]
// CHECK-NEXT:    %[[TMP25:.+]] = load float, float* %[[ARRAYIDX5]], align 4
// CHECK-NEXT:    %[[MUL6:.+]] = fmul float %[[MUL]], %[[TMP25]]
// CHECK-NEXT:    %[[TMP26:.+]] = load float*, float** %[[A_ADDR]], align 8
// CHECK-NEXT:    %[[TMP27:.+]] = load i32, i32* %[[I]], align 4
// CHECK-NEXT:    %[[IDXPROM7:.+]] = zext i32 %[[TMP27]] to i64
// CHECK-NEXT:    %[[ARRAYIDX8:.+]] = getelementptr inbounds float, float* %[[TMP26]], i64 %[[IDXPROM7]]
// CHECK-NEXT:    store float %[[MUL6]], float* %[[ARRAYIDX8]], align 4
// CHECK-NEXT:    br label %[[OMP_LOOP_INC]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_LOOP_INC]]:
// CHECK-NEXT:    %[[OMP_LOOP_NEXT]] = add nuw i32 %[[OMP_LOOP_IV]], 1
// CHECK-NEXT:    br label %[[OMP_LOOP_HEADER]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_LOOP_EXIT]]:
// CHECK-NEXT:    br label %[[OMP_DISPATCH_INC]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[OMP_LOOP_AFTER]]:
// CHECK-NEXT:    ret void
// CHECK-NEXT:  }

extern "C" void workshareloop_unsigned_static_chunked(float *a, float *b, float *c, float *d) {
#pragma omp for schedule(static, 5)
  for (unsigned i = 33; i < 32000000; i += 7) {
    a[i] = b[i] * c[i] * d[i];
  }
}

#endif // HEADER

// CHECK-LABEL: define {{.*}}@__captured_stmt(
// CHECK-NEXT:  [[ENTRY:.*]]:
// CHECK-NEXT:    %[[DISTANCE_ADDR:.+]] = alloca i32*, align 8
// CHECK-NEXT:    %[[__CONTEXT_ADDR:.+]] = alloca %struct.anon*, align 8
// CHECK-NEXT:    %[[DOTSTART:.+]] = alloca i32, align 4
// CHECK-NEXT:    %[[DOTSTOP:.+]] = alloca i32, align 4
// CHECK-NEXT:    %[[DOTSTEP:.+]] = alloca i32, align 4
// CHECK-NEXT:    store i32* %[[DISTANCE:.+]], i32** %[[DISTANCE_ADDR]], align 8
// CHECK-NEXT:    store %struct.anon* %[[__CONTEXT:.+]], %struct.anon** %[[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    %[[TMP0:.+]] = load %struct.anon*, %struct.anon** %[[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    %[[TMP1:.+]] = getelementptr inbounds %struct.anon, %struct.anon* %[[TMP0]], i32 0, i32 0
// CHECK-NEXT:    %[[TMP2:.+]] = load i32*, i32** %[[TMP1]], align 8
// CHECK-NEXT:    %[[TMP3:.+]] = load i32, i32* %[[TMP2]], align 4
// CHECK-NEXT:    store i32 %[[TMP3]], i32* %[[DOTSTART]], align 4
// CHECK-NEXT:    store i32 32000000, i32* %[[DOTSTOP]], align 4
// CHECK-NEXT:    store i32 7, i32* %[[DOTSTEP]], align 4
// CHECK-NEXT:    %[[TMP4:.+]] = load i32, i32* %[[DOTSTART]], align 4
// CHECK-NEXT:    %[[TMP5:.+]] = load i32, i32* %[[DOTSTOP]], align 4
// CHECK-NEXT:    %[[CMP:.+]] = icmp ult i32 %[[TMP4]], %[[TMP5]]
// CHECK-NEXT:    br i1 %[[CMP]], label %[[COND_TRUE:.+]], label %[[COND_FALSE:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[COND_TRUE]]:
// CHECK-NEXT:    %[[TMP6:.+]] = load i32, i32* %[[DOTSTOP]], align 4
// CHECK-NEXT:    %[[TMP7:.+]] = load i32, i32* %[[DOTSTART]], align 4
// CHECK-NEXT:    %[[SUB:.+]] = sub i32 %[[TMP6]], %[[TMP7]]
// CHECK-NEXT:    %[[TMP8:.+]] = load i32, i32* %[[DOTSTEP]], align 4
// CHECK-NEXT:    %[[SUB1:.+]] = sub i32 %[[TMP8]], 1
// CHECK-NEXT:    %[[ADD:.+]] = add i32 %[[SUB]], %[[SUB1]]
// CHECK-NEXT:    %[[TMP9:.+]] = load i32, i32* %[[DOTSTEP]], align 4
// CHECK-NEXT:    %[[DIV:.+]] = udiv i32 %[[ADD]], %[[TMP9]]
// CHECK-NEXT:    br label %[[COND_END:.+]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[COND_FALSE]]:
// CHECK-NEXT:    br label %[[COND_END]]
// CHECK-EMPTY:
// CHECK-NEXT:  [[COND_END]]:
// CHECK-NEXT:    %[[COND:.+]] = phi i32 [ %[[DIV]], %[[COND_TRUE]] ], [ 0, %[[COND_FALSE]] ]
// CHECK-NEXT:    %[[TMP10:.+]] = load i32*, i32** %[[DISTANCE_ADDR]], align 8
// CHECK-NEXT:    store i32 %[[COND]], i32* %[[TMP10]], align 4
// CHECK-NEXT:    ret void
// CHECK-NEXT:  }


// CHECK-LABEL: define {{.*}}@__captured_stmt.1(
// CHECK-NEXT:  [[ENTRY:.*]]:
// CHECK-NEXT:    %[[LOOPVAR_ADDR:.+]] = alloca i32*, align 8
// CHECK-NEXT:    %[[LOGICAL_ADDR:.+]] = alloca i32, align 4
// CHECK-NEXT:    %[[__CONTEXT_ADDR:.+]] = alloca %struct.anon.0*, align 8
// CHECK-NEXT:    store i32* %[[LOOPVAR:.+]], i32** %[[LOOPVAR_ADDR]], align 8
// CHECK-NEXT:    store i32 %[[LOGICAL:.+]], i32* %[[LOGICAL_ADDR]], align 4
// CHECK-NEXT:    store %struct.anon.0* %[[__CONTEXT:.+]], %struct.anon.0** %[[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    %[[TMP0:.+]] = load %struct.anon.0*, %struct.anon.0** %[[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    %[[TMP1:.+]] = getelementptr inbounds %struct.anon.0, %struct.anon.0* %[[TMP0]], i32 0, i32 0
// CHECK-NEXT:    %[[TMP2:.+]] = load i32, i32* %[[TMP1]], align 4
// CHECK-NEXT:    %[[TMP3:.+]] = load i32, i32* %[[LOGICAL_ADDR]], align 4
// CHECK-NEXT:    %[[MUL:.+]] = mul i32 7, %[[TMP3]]
// CHECK-NEXT:    %[[ADD:.+]] = add i32 %[[TMP2]], %[[MUL]]
// CHECK-NEXT:    %[[TMP4:.+]] = load i32*, i32** %[[LOOPVAR_ADDR]], align 8
// CHECK-NEXT:    store i32 %[[ADD]], i32* %[[TMP4]], align 4
// CHECK-NEXT:    ret void
// CHECK-NEXT:  }


// CHECK: ![[META0:[0-9]+]] = !{i32 1, !"wchar_size", i32 4}
// CHECK: ![[META1:[0-9]+]] = !{i32 7, !"openmp", i32 45}
// CHECK: ![[META2:[0-9]+]] =
