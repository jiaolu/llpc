; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function main --version 2
; RUN: opt --opaque-pointers=0 --verify-each -passes='add-types-metadata,dxil-cont-intrinsic-prepare,lint,dxil-cont-lgc-rt-op-converter,lint,lower-raytracing-pipeline,lint,inline,lint,dxil-cont-pre-coroutine,lint,sroa,lint,lower-await,lint,coro-early,dxil-coro-split,coro-cleanup,lint,cleanup-continuations,lint,register-buffer,lint,save-continuation-state,lint,dxil-cont-post-process,lint,remove-types-metadata' -S %s 2>%t.stderr | FileCheck %s
; RUN: count 0 < %t.stderr

declare i32 @_AmdContPayloadRegistersGetI32(i32)

%struct.DispatchSystemData = type { i32 }
%struct.HitData = type { float, i32 }
%struct.BuiltInTriangleIntersectionAttributes = type { <2 x float> }
declare %struct.DispatchSystemData @_cont_SetupRayGen()
declare i32 @_cont_GetLocalRootIndex(%struct.DispatchSystemData*)
declare %struct.BuiltInTriangleIntersectionAttributes @_cont_GetTriangleHitAttributes(%struct.DispatchSystemData*)
declare i32 @_cont_HitKind(%struct.DispatchSystemData*, %struct.HitData*)

%struct.Payload = type { [8 x i32] }

@debug_global = external global i32

define void @main() {
; CHECK-LABEL: define void @main() !continuation !11 !continuation.entry !12 !continuation.registercount !5 !continuation.state !5 {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SYSTEM_DATA:%.*]] = alloca [[STRUCT_DISPATCHSYSTEMDATA:%.*]], align 8
; CHECK-NEXT:    [[SYSTEM_DATA_ALLOCA:%.*]] = alloca [[STRUCT_DISPATCHSYSTEMDATA]], align 8
; CHECK-NEXT:    [[CONT_STATE:%.*]] = alloca [0 x i32], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = call [[STRUCT_DISPATCHSYSTEMDATA]] @_cont_SetupRayGen()
; CHECK-NEXT:    store [[STRUCT_DISPATCHSYSTEMDATA]] [[TMP0]], %struct.DispatchSystemData* [[SYSTEM_DATA]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast [0 x i32]* [[CONT_STATE]] to i8*
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = bitcast i8* undef to %main.Frame*
; CHECK-NEXT:    [[TMP2:%.*]] = load [[STRUCT_DISPATCHSYSTEMDATA]], %struct.DispatchSystemData* [[SYSTEM_DATA]], align 4
; CHECK-NEXT:    [[DOTFCA_0_EXTRACT:%.*]] = extractvalue [[STRUCT_DISPATCHSYSTEMDATA]] [[TMP2]], 0
; CHECK-NEXT:    [[DOTFCA_0_GEP:%.*]] = getelementptr inbounds [[STRUCT_DISPATCHSYSTEMDATA]], %struct.DispatchSystemData* [[SYSTEM_DATA_ALLOCA]], i32 0, i32 0
; CHECK-NEXT:    store i32 [[DOTFCA_0_EXTRACT]], i32* [[DOTFCA_0_GEP]], align 4
; CHECK-NEXT:    [[LOCAL_ROOT_INDEX:%.*]] = call i32 @_cont_GetLocalRootIndex(%struct.DispatchSystemData* [[SYSTEM_DATA_ALLOCA]])
; CHECK-NEXT:    call void @amd.dx.setLocalRootIndex(i32 [[LOCAL_ROOT_INDEX]])
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32 addrspace(20)* getelementptr inbounds ([30 x i32], [30 x i32] addrspace(20)* @REGISTERS, i32 0, i32 5), align 4
; CHECK-NEXT:    store i32 [[TMP3]], i32* @debug_global, align 4
; CHECK-NEXT:    call void @continuation.complete()
; CHECK-NEXT:    unreachable
;
entry:
  %val = call i32 @_AmdContPayloadRegistersGetI32(i32 5)
  store i32 %val, i32* @debug_global
  ret void
}

; Define hit shader to increase payload size
define void @chit(%struct.Payload* %pl, %struct.Payload* %attrs) {
  ret void
}

!dx.entryPoints = !{!1, !5, !8}

!1 = !{null, !"", null, !3, !2}
!2 = !{i32 0, i64 65536}
!3 = !{!4, null, null, null}
!4 = !{!5}
!5 = !{void ()* @main, !"main", null, null, !6}
!6 = !{i32 8, i32 7, i32 6, i32 16, i32 7, i32 8, i32 5, !7}
!7 = !{i32 0}
!8 = !{void (%struct.Payload*, %struct.Payload*)* @chit, !"chit", null, null, !9}
!9 = !{i32 8, i32 10, i32 6, i32 16, i32 7, i32 8, i32 5, !7}
