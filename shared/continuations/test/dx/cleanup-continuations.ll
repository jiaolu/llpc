; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 3
; RUN: opt --verify-each -passes='legacy-cleanup-continuations,lint' -S %s 2>%t.stderr | FileCheck %s
; RUN: count 0 < %t.stderr

target datalayout = "e-m:e-p:64:32-p20:32:32-p21:32:32-i1:32-i8:8-i16:32-i32:32-i64:32-f16:32-f32:32-f64:32-v16:32-v32:32-v48:32-v64:32-v80:32-v96:32-v112:32-v128:32-v144:32-v160:32-v176:32-v192:32-v208:32-v224:32-v240:32-v256:32-n8:16:32"

%continuation.token = type { }
%await_with_ret_value.Frame = type { i64 }
%simple_await.Frame = type { i64 }
%simple_await_entry.Frame = type { }

declare %continuation.token* @async_fun()
declare i32 @continuations.getReturnValue.i32() #0
declare void @continuation.return(i64, ...)

; CHECK: @CONTINUATION_STATE = external global [2 x i32]

@RETURN_ADDR = external addrspace(20) global i64

define { i8*, %continuation.token* } @simple_await(i8* %0) !continuation !0 !continuation.registercount !4 {
; CHECK-LABEL: define void @simple_await() !continuation !2 !continuation.registercount !3 !continuation.state !4 !continuation.stacksize !4 {
; CHECK-NEXT:  AllocaSpillBB:
; CHECK-NEXT:    [[CONT_STATE:%.*]] = alloca [2 x i32], align 4
; CHECK-NEXT:    call void @continuation.save.continuation_state()
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = bitcast ptr [[CONT_STATE]] to ptr
; CHECK-NEXT:    [[TMP0:%.*]] = load i64, ptr addrspace(20) @RETURN_ADDR, align 4
; CHECK-NEXT:    [[DOTSPILL_ADDR:%.*]] = getelementptr inbounds [[SIMPLE_AWAIT_FRAME:%.*]], ptr [[FRAMEPTR]], i32 0, i32 0
; CHECK-NEXT:    store i64 [[TMP0]], ptr [[DOTSPILL_ADDR]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], 8
; CHECK-NEXT:    store i32 [[TMP3]], ptr [[TMP1]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    call void (...) @registerbuffer.setpointerbarrier(ptr @CONTINUATION_STATE, ptr [[TMP4]])
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr [[TMP5]], align 4
; CHECK-NEXT:    store i32 [[TMP6]], ptr @CONTINUATION_STATE, align 4
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[TMP7]], align 4
; CHECK-NEXT:    store i32 [[TMP8]], ptr getelementptr inbounds ([2 x i32], ptr @CONTINUATION_STATE, i32 0, i32 1), align 4
; CHECK-NEXT:    [[TMP9:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[TMP9]], align 4
; CHECK-NEXT:    call void (i64, ...) @continuation.continue(i64 ptrtoint (ptr @async_fun to i64), i32 [[TMP10]], i64 ptrtoint (ptr @simple_await.resume.0 to i64)), !continuation.registercount !3, !continuation.returnedRegistercount !3
; CHECK-NEXT:    unreachable
;
AllocaSpillBB:
  %FramePtr = bitcast i8* %0 to %simple_await.Frame*
  %1 = load i64, i64 addrspace(20)* @RETURN_ADDR, align 4
  %.spill.addr = getelementptr inbounds %simple_await.Frame, %simple_await.Frame* %FramePtr, i32 0, i32 0
  store i64 %1, i64* %.spill.addr, align 4
  %tok = call %continuation.token* @async_fun(), !continuation.registercount !4, !continuation.returnedRegistercount !4
  %2 = insertvalue { i8*, %continuation.token* } { i8* bitcast ({ i8*, %continuation.token* } (i8*, i1)* @simple_await.resume.0 to i8*), %continuation.token* undef }, %continuation.token* %tok, 1
  ret { i8*, %continuation.token* } %2
}

define internal { i8*, %continuation.token* } @simple_await.resume.0(i8* noalias nonnull align 16 dereferenceable(8) %0, i1 %1) !continuation !0 {
; CHECK-LABEL: define void @simple_await.resume.0(
; CHECK-SAME: i32 [[TMP0:%.*]]) !continuation !2 !continuation.registercount !3 {
; CHECK-NEXT:  entryresume.0:
; CHECK-NEXT:    [[CONT_STATE:%.*]] = alloca [2 x i32], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr @CONTINUATION_STATE, align 4
; CHECK-NEXT:    store i32 [[TMP2]], ptr [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr getelementptr inbounds ([2 x i32], ptr @CONTINUATION_STATE, i32 0, i32 1), align 4
; CHECK-NEXT:    store i32 [[TMP4]], ptr [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    call void (...) @registerbuffer.setpointerbarrier(ptr @CONTINUATION_STATE, ptr [[TMP5]])
; CHECK-NEXT:    [[TMP6:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = add i32 [[TMP7]], -8
; CHECK-NEXT:    store i32 [[TMP8]], ptr [[TMP6]], align 4
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = bitcast ptr [[CONT_STATE]] to ptr
; CHECK-NEXT:    [[VFRAME:%.*]] = bitcast ptr [[FRAMEPTR]] to ptr
; CHECK-NEXT:    [[DOTRELOAD_ADDR:%.*]] = getelementptr inbounds [[SIMPLE_AWAIT_FRAME:%.*]], ptr [[FRAMEPTR]], i32 0, i32 0
; CHECK-NEXT:    [[DOTRELOAD:%.*]] = load i64, ptr [[DOTRELOAD_ADDR]], align 4
; CHECK-NEXT:    call void @continuation.restore.continuation_state()
; CHECK-NEXT:    [[TMP9:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[TMP9]], align 4
; CHECK-NEXT:    call void (i64, ...) @continuation.continue(i64 [[DOTRELOAD]], i32 [[TMP10]]), !continuation.registercount !3
; CHECK-NEXT:    unreachable
;
entryresume.0:
  %FramePtr = bitcast i8* %0 to %simple_await.Frame*
  %vFrame = bitcast %simple_await.Frame* %FramePtr to i8*
  %.reload.addr = getelementptr inbounds %simple_await.Frame, %simple_await.Frame* %FramePtr, i32 0, i32 0
  %.reload = load i64, i64* %.reload.addr, align 4
  call void (i64, ...) @continuation.return(i64 %.reload), !continuation.registercount !4
  unreachable
}

define { i8*, %continuation.token* } @simple_await_entry(i8* %0) !continuation.entry !2 !continuation !3 !continuation.registercount !4 {
; CHECK-LABEL: define void @simple_await_entry() !continuation !5 !continuation.registercount !3 !continuation.entry !6 !continuation.state !4 !continuation.stacksize !4 {
; CHECK-NEXT:  AllocaSpillBB:
; CHECK-NEXT:    [[CONT_STATE:%.*]] = alloca [2 x i32], align 4
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = bitcast ptr [[CONT_STATE]] to ptr
; CHECK-NEXT:    [[TMP0:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 8
; CHECK-NEXT:    store i32 [[TMP2]], ptr [[TMP0]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    call void (...) @registerbuffer.setpointerbarrier(ptr @CONTINUATION_STATE, ptr [[TMP3]])
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr [[TMP4]], align 4
; CHECK-NEXT:    store i32 [[TMP5]], ptr @CONTINUATION_STATE, align 4
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[TMP6]], align 4
; CHECK-NEXT:    store i32 [[TMP7]], ptr getelementptr inbounds ([2 x i32], ptr @CONTINUATION_STATE, i32 0, i32 1), align 4
; CHECK-NEXT:    [[TMP8:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[TMP8]], align 4
; CHECK-NEXT:    call void (i64, ...) @continuation.continue(i64 ptrtoint (ptr @async_fun to i64), i32 [[TMP9]], i64 ptrtoint (ptr @simple_await_entry.resume.0 to i64)), !continuation.registercount !3, !continuation.returnedRegistercount !3
; CHECK-NEXT:    unreachable
;
AllocaSpillBB:
  %FramePtr = bitcast i8* %0 to %simple_await_entry.Frame*
  %tok = call %continuation.token* @async_fun(), !continuation.registercount !4, !continuation.returnedRegistercount !4
  %1 = bitcast { i8*, %continuation.token* } (i8*, i1)* @simple_await_entry.resume.0 to i8*
  %2 = insertvalue { i8*, %continuation.token* } undef, i8* %1, 0
  %3 = insertvalue { i8*, %continuation.token* } %2, %continuation.token* %tok, 1
  ret { i8*, %continuation.token* } %3
}

define internal { i8*, %continuation.token* } @simple_await_entry.resume.0(i8* noalias nonnull align 16 dereferenceable(8) %0, i1 %1) !continuation.entry !2 !continuation !3 {
; CHECK-LABEL: define void @simple_await_entry.resume.0(
; CHECK-SAME: i32 [[TMP0:%.*]]) !continuation !5 !continuation.registercount !3 {
; CHECK-NEXT:  entryresume.0:
; CHECK-NEXT:    [[CONT_STATE:%.*]] = alloca [2 x i32], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr @CONTINUATION_STATE, align 4
; CHECK-NEXT:    store i32 [[TMP2]], ptr [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr getelementptr inbounds ([2 x i32], ptr @CONTINUATION_STATE, i32 0, i32 1), align 4
; CHECK-NEXT:    store i32 [[TMP4]], ptr [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    call void (...) @registerbuffer.setpointerbarrier(ptr @CONTINUATION_STATE, ptr [[TMP5]])
; CHECK-NEXT:    [[TMP6:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = add i32 [[TMP7]], -8
; CHECK-NEXT:    store i32 [[TMP8]], ptr [[TMP6]], align 4
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = bitcast ptr [[CONT_STATE]] to ptr
; CHECK-NEXT:    [[VFRAME:%.*]] = bitcast ptr [[FRAMEPTR]] to ptr
; CHECK-NEXT:    call void @continuation.complete()
; CHECK-NEXT:    unreachable
;
entryresume.0:
  %FramePtr = bitcast i8* %0 to %simple_await_entry.Frame*
  %vFrame = bitcast %simple_await_entry.Frame* %FramePtr to i8*
  call void (i64, ...) @continuation.return(i64 undef), !continuation.registercount !4
  unreachable
}

define { i8*, %continuation.token* } @await_with_ret_value(i8* %0) !continuation !1 !continuation.registercount !4 {
; CHECK-LABEL: define void @await_with_ret_value() !continuation !7 !continuation.registercount !3 !continuation.state !4 !continuation.stacksize !4 {
; CHECK-NEXT:    [[CONT_STATE:%.*]] = alloca [2 x i32], align 4
; CHECK-NEXT:    call void @continuation.save.continuation_state()
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = bitcast ptr [[CONT_STATE]] to ptr
; CHECK-NEXT:    [[RETADDR:%.*]] = load i64, ptr addrspace(20) @RETURN_ADDR, align 4
; CHECK-NEXT:    [[DOTSPILL_ADDR:%.*]] = getelementptr inbounds [[AWAIT_WITH_RET_VALUE_FRAME:%.*]], ptr [[FRAMEPTR]], i32 0, i32 0
; CHECK-NEXT:    store i64 [[RETADDR]], ptr [[DOTSPILL_ADDR]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], 8
; CHECK-NEXT:    store i32 [[TMP3]], ptr [[TMP1]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    call void (...) @registerbuffer.setpointerbarrier(ptr @CONTINUATION_STATE, ptr [[TMP4]])
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr [[TMP5]], align 4
; CHECK-NEXT:    store i32 [[TMP6]], ptr @CONTINUATION_STATE, align 4
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[TMP7]], align 4
; CHECK-NEXT:    store i32 [[TMP8]], ptr getelementptr inbounds ([2 x i32], ptr @CONTINUATION_STATE, i32 0, i32 1), align 4
; CHECK-NEXT:    [[TMP9:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[TMP9]], align 4
; CHECK-NEXT:    call void (i64, ...) @continuation.continue(i64 ptrtoint (ptr @async_fun to i64), i32 [[TMP10]], i64 ptrtoint (ptr @await_with_ret_value.resume.0 to i64)), !continuation.registercount !3, !continuation.returnedRegistercount !3
; CHECK-NEXT:    unreachable
;
  %FramePtr = bitcast i8* %0 to %await_with_ret_value.Frame*
  %retaddr = load i64, i64 addrspace(20)* @RETURN_ADDR, align 4
  %.spill.addr = getelementptr inbounds %await_with_ret_value.Frame, %await_with_ret_value.Frame* %FramePtr, i32 0, i32 0
  store i64 %retaddr, i64* %.spill.addr, align 4
  %tok = call %continuation.token* @async_fun(), !continuation.registercount !4, !continuation.returnedRegistercount !4
  %res = insertvalue { i8*, %continuation.token* } { i8* bitcast ({ i8*, %continuation.token* } (i8*, i1)* @await_with_ret_value.resume.0 to i8*), %continuation.token* undef }, %continuation.token* %tok, 1
  ret { i8*, %continuation.token* } %res
}

define internal { i8*, %continuation.token* } @await_with_ret_value.resume.0(i8* noalias nonnull align 16 dereferenceable(8) %0, i1 %1) !continuation !1 {
; CHECK-LABEL: define void @await_with_ret_value.resume.0(
; CHECK-SAME: i32 [[TMP0:%.*]], i32 [[RES1:%.*]]) !continuation !7 !continuation.registercount !3 {
; CHECK-NEXT:    [[CONT_STATE:%.*]] = alloca [2 x i32], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr @CONTINUATION_STATE, align 4
; CHECK-NEXT:    store i32 [[TMP3]], ptr [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [2 x i32], ptr [[CONT_STATE]], i32 0, i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr getelementptr inbounds ([2 x i32], ptr @CONTINUATION_STATE, i32 0, i32 1), align 4
; CHECK-NEXT:    store i32 [[TMP5]], ptr [[TMP4]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    call void (...) @registerbuffer.setpointerbarrier(ptr @CONTINUATION_STATE, ptr [[TMP6]])
; CHECK-NEXT:    [[TMP7:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[TMP7]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = add i32 [[TMP8]], -8
; CHECK-NEXT:    store i32 [[TMP9]], ptr [[TMP7]], align 4
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = bitcast ptr [[CONT_STATE]] to ptr
; CHECK-NEXT:    [[VFRAME:%.*]] = bitcast ptr [[FRAMEPTR]] to ptr
; CHECK-NEXT:    [[DOTRELOAD_ADDR:%.*]] = getelementptr inbounds [[AWAIT_WITH_RET_VALUE_FRAME:%.*]], ptr [[FRAMEPTR]], i32 0, i32 0
; CHECK-NEXT:    [[DOTRELOAD:%.*]] = load i64, ptr [[DOTRELOAD_ADDR]], align 4
; CHECK-NEXT:    call void @continuation.restore.continuation_state()
; CHECK-NEXT:    [[TMP10:%.*]] = call ptr @continuation.getContinuationStackOffset()
; CHECK-NEXT:    [[TMP11:%.*]] = load i32, ptr [[TMP10]], align 4
; CHECK-NEXT:    call void (i64, ...) @continuation.continue(i64 [[DOTRELOAD]], i32 [[TMP11]], i32 [[RES1]]), !continuation.registercount !3
; CHECK-NEXT:    unreachable
;
  %FramePtr = bitcast i8* %0 to %await_with_ret_value.Frame*
  %vFrame = bitcast %await_with_ret_value.Frame* %FramePtr to i8*
  %.reload.addr = getelementptr inbounds %await_with_ret_value.Frame, %await_with_ret_value.Frame* %FramePtr, i32 0, i32 0
  %.reload = load i64, i64* %.reload.addr, align 4
  %res = call i32 @continuations.getReturnValue.i32()
  call void (i64, ...) @continuation.return(i64 %.reload, i32 %res), !continuation.registercount !4
  unreachable
}

attributes #0 = { nounwind }

!continuation.stackAddrspace = !{!5}

!0 = !{{ i8*, %continuation.token* } (i8*)* @simple_await}
!1 = !{{ i8*, %continuation.token* } (i8*)* @await_with_ret_value}
!2 = !{}
!3 = !{{ i8*, %continuation.token* } (i8*)* @simple_await_entry}
!4 = !{i32 0}
!5 = !{i32 21}
