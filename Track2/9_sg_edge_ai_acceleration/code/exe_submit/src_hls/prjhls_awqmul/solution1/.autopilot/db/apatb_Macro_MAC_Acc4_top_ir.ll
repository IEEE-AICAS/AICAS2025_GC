; ModuleID = '/home/maoyang/aicas_final/QWEN_AWQ_INFER/src_hls/prjhls_awqmul/solution1/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"class.hls::vector<float, 4>" = type { %"struct.std::array<float, 4>" }
%"struct.std::array<float, 4>" = type { [4 x float] }
%"class.hls::vector<unsigned int, 4>" = type { %"struct.std::array<unsigned int, 4>" }
%"struct.std::array<unsigned int, 4>" = type { [4 x i32] }

; Function Attrs: noinline willreturn
define void @apatb_Macro_MAC_Acc4_top_ir(%"class.hls::vector<float, 4>"* noalias nocapture nonnull align 16 %out, %"class.hls::vector<float, 4>"* noalias nocapture nonnull readonly align 16 %xi, %"class.hls::vector<unsigned int, 4>"* noalias nocapture nonnull readonly align 16 %mro0, %"class.hls::vector<unsigned int, 4>"* noalias nocapture nonnull readonly align 16 %mro1, %"class.hls::vector<unsigned int, 4>"* noalias nocapture nonnull readonly align 16 %mro2, %"class.hls::vector<unsigned int, 4>"* noalias nocapture nonnull readonly align 16 %mro3, i16 zeroext %row) local_unnamed_addr #0 {
entry:
  %out_copy = alloca i128, align 512
  %xi_copy = alloca i128, align 512
  %mro0_copy = alloca i128, align 512
  %mro1_copy = alloca i128, align 512
  %mro2_copy = alloca i128, align 512
  %mro3_copy = alloca i128, align 512
  call fastcc void @copy_in(%"class.hls::vector<float, 4>"* nonnull align 16 %out, i128* nonnull align 512 %out_copy, %"class.hls::vector<float, 4>"* nonnull align 16 %xi, i128* nonnull align 512 %xi_copy, %"class.hls::vector<unsigned int, 4>"* nonnull align 16 %mro0, i128* nonnull align 512 %mro0_copy, %"class.hls::vector<unsigned int, 4>"* nonnull align 16 %mro1, i128* nonnull align 512 %mro1_copy, %"class.hls::vector<unsigned int, 4>"* nonnull align 16 %mro2, i128* nonnull align 512 %mro2_copy, %"class.hls::vector<unsigned int, 4>"* nonnull align 16 %mro3, i128* nonnull align 512 %mro3_copy)
  call void @apatb_Macro_MAC_Acc4_top_hw(i128* %out_copy, i128* %xi_copy, i128* %mro0_copy, i128* %mro1_copy, i128* %mro2_copy, i128* %mro3_copy, i16 %row)
  call void @copy_back(%"class.hls::vector<float, 4>"* %out, i128* %out_copy, %"class.hls::vector<float, 4>"* %xi, i128* %xi_copy, %"class.hls::vector<unsigned int, 4>"* %mro0, i128* %mro0_copy, %"class.hls::vector<unsigned int, 4>"* %mro1, i128* %mro1_copy, %"class.hls::vector<unsigned int, 4>"* %mro2, i128* %mro2_copy, %"class.hls::vector<unsigned int, 4>"* %mro3, i128* %mro3_copy)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_in(%"class.hls::vector<float, 4>"* noalias readonly align 16, i128* noalias align 512, %"class.hls::vector<float, 4>"* noalias readonly align 16, i128* noalias align 512, %"class.hls::vector<unsigned int, 4>"* noalias readonly align 16, i128* noalias align 512, %"class.hls::vector<unsigned int, 4>"* noalias readonly align 16, i128* noalias align 512, %"class.hls::vector<unsigned int, 4>"* noalias readonly align 16, i128* noalias align 512, %"class.hls::vector<unsigned int, 4>"* noalias readonly align 16, i128* noalias align 512) unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<float, 4>.51"(i128* align 512 %1, %"class.hls::vector<float, 4>"* align 16 %0)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<float, 4>.51"(i128* align 512 %3, %"class.hls::vector<float, 4>"* align 16 %2)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>.71"(i128* align 512 %5, %"class.hls::vector<unsigned int, 4>"* align 16 %4)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>.71"(i128* align 512 %7, %"class.hls::vector<unsigned int, 4>"* align 16 %6)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>.71"(i128* align 512 %9, %"class.hls::vector<unsigned int, 4>"* align 16 %8)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>.71"(i128* align 512 %11, %"class.hls::vector<unsigned int, 4>"* align 16 %10)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_out(%"class.hls::vector<float, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<float, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<unsigned int, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<unsigned int, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<unsigned int, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<unsigned int, 4>"* noalias align 16, i128* noalias readonly align 512) unnamed_addr #2 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<float, 4>"(%"class.hls::vector<float, 4>"* align 16 %0, i128* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<float, 4>"(%"class.hls::vector<float, 4>"* align 16 %2, i128* align 512 %3)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>"(%"class.hls::vector<unsigned int, 4>"* align 16 %4, i128* align 512 %5)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>"(%"class.hls::vector<unsigned int, 4>"* align 16 %6, i128* align 512 %7)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>"(%"class.hls::vector<unsigned int, 4>"* align 16 %8, i128* align 512 %9)
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>"(%"class.hls::vector<unsigned int, 4>"* align 16 %10, i128* align 512 %11)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::vector<float, 4>"(%"class.hls::vector<float, 4>"* noalias align 16 %dst, i128* noalias readonly align 512 %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::vector<float, 4>"* %dst, null
  %1 = icmp eq i128* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %dst.0.02 = getelementptr %"class.hls::vector<float, 4>", %"class.hls::vector<float, 4>"* %dst, i64 0, i32 0, i32 0
  call void @arraycpy_hls.p0a4f32.46([4 x float]* %dst.0.02, i128* nonnull %src, i64 0, i64 4)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a4f32.46([4 x float]* %dst, i128* readonly %src, i64 %src_idx, i64 %num) local_unnamed_addr #4 {
entry:
  %0 = icmp eq i128* %src, null
  %1 = icmp eq [4 x float]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %dst.addr = getelementptr [4 x float], [4 x float]* %dst, i64 0, i64 %for.loop.idx2
  %3 = mul i64 32, %for.loop.idx2
  %4 = add i64 %src_idx, %3
  %5 = load i128, i128* %src, align 4
  %6 = zext i64 %4 to i128
  %7 = lshr i128 %5, %6
  %.partselect = trunc i128 %7 to i32
  %8 = call float @_llvm.fpga.unpack.bits.f32.i32(i32 %.partselect)
  store float %8, float* %dst.addr, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: alwaysinline nounwind readnone willreturn
define internal float @_llvm.fpga.unpack.bits.f32.i32(i32 %A) #5 {
  %A.cast = bitcast i32 %A to float
  ret float %A.cast
}

; Function Attrs: alwaysinline nounwind readnone willreturn
define internal i32 @_llvm.fpga.pack.bits.i32.f32(float %A) #5 {
  %A.cast = bitcast float %A to i32
  ret i32 %A.cast
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::vector<float, 4>.51"(i128* noalias align 512 %dst, %"class.hls::vector<float, 4>"* noalias readonly align 16 %src) unnamed_addr #3 {
entry:
  %0 = icmp eq i128* %dst, null
  %1 = icmp eq %"class.hls::vector<float, 4>"* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %src.0.01 = getelementptr %"class.hls::vector<float, 4>", %"class.hls::vector<float, 4>"* %src, i64 0, i32 0, i32 0
  call void @arraycpy_hls.p0a4f32.54(i128* nonnull %dst, i64 0, [4 x float]* %src.0.01, i64 4)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a4f32.54(i128* %dst, i64 %dst_idx, [4 x float]* readonly %src, i64 %num) local_unnamed_addr #4 {
entry:
  %0 = icmp eq [4 x float]* %src, null
  %1 = icmp eq i128* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %3 = mul i64 32, %for.loop.idx2
  %4 = add i64 %dst_idx, %3
  %src.addr = getelementptr [4 x float], [4 x float]* %src, i64 0, i64 %for.loop.idx2
  %5 = load float, float* %src.addr, align 4
  %6 = call i32 @_llvm.fpga.pack.bits.i32.f32(float %5)
  %7 = load i128, i128* %dst, align 4
  %8 = zext i64 %4 to i128
  %9 = shl i128 4294967295, %8
  %10 = zext i32 %6 to i128
  %11 = shl i128 %10, %8
  %thr.xor1 = xor i128 %9, -1
  %thr.and2 = and i128 %7, %thr.xor1
  %thr.or3 = or i128 %thr.and2, %11
  store i128 %thr.or3, i128* %dst, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>"(%"class.hls::vector<unsigned int, 4>"* noalias align 16 %dst, i128* noalias readonly align 512 %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::vector<unsigned int, 4>"* %dst, null
  %1 = icmp eq i128* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %dst.0.02 = getelementptr %"class.hls::vector<unsigned int, 4>", %"class.hls::vector<unsigned int, 4>"* %dst, i64 0, i32 0, i32 0
  call void @arraycpy_hls.p0a4i32.66([4 x i32]* %dst.0.02, i128* nonnull %src, i64 0, i64 4)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a4i32.66([4 x i32]* %dst, i128* readonly %src, i64 %src_idx, i64 %num) local_unnamed_addr #4 {
entry:
  %0 = icmp eq i128* %src, null
  %1 = icmp eq [4 x i32]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %dst.addr = getelementptr [4 x i32], [4 x i32]* %dst, i64 0, i64 %for.loop.idx2
  %3 = mul i64 32, %for.loop.idx2
  %4 = add i64 %src_idx, %3
  %5 = load i128, i128* %src, align 4
  %6 = zext i64 %4 to i128
  %7 = lshr i128 %5, %6
  %.partselect = trunc i128 %7 to i32
  store i32 %.partselect, i32* %dst.addr, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::vector<unsigned int, 4>.71"(i128* noalias align 512 %dst, %"class.hls::vector<unsigned int, 4>"* noalias readonly align 16 %src) unnamed_addr #3 {
entry:
  %0 = icmp eq i128* %dst, null
  %1 = icmp eq %"class.hls::vector<unsigned int, 4>"* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %src.0.01 = getelementptr %"class.hls::vector<unsigned int, 4>", %"class.hls::vector<unsigned int, 4>"* %src, i64 0, i32 0, i32 0
  call void @arraycpy_hls.p0a4i32.74(i128* nonnull %dst, i64 0, [4 x i32]* %src.0.01, i64 4)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a4i32.74(i128* %dst, i64 %dst_idx, [4 x i32]* readonly %src, i64 %num) local_unnamed_addr #4 {
entry:
  %0 = icmp eq [4 x i32]* %src, null
  %1 = icmp eq i128* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %3 = mul i64 32, %for.loop.idx2
  %4 = add i64 %dst_idx, %3
  %src.addr = getelementptr [4 x i32], [4 x i32]* %src, i64 0, i64 %for.loop.idx2
  %5 = load i32, i32* %src.addr, align 4
  %6 = load i128, i128* %dst, align 4
  %7 = zext i64 %4 to i128
  %8 = shl i128 4294967295, %7
  %9 = zext i32 %5 to i128
  %10 = shl i128 %9, %7
  %thr.xor1 = xor i128 %8, -1
  %thr.and2 = and i128 %6, %thr.xor1
  %thr.or3 = or i128 %thr.and2, %10
  store i128 %thr.or3, i128* %dst, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_Macro_MAC_Acc4_top_hw(i128*, i128*, i128*, i128*, i128*, i128*, i16)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_back(%"class.hls::vector<float, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<float, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<unsigned int, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<unsigned int, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<unsigned int, 4>"* noalias align 16, i128* noalias readonly align 512, %"class.hls::vector<unsigned int, 4>"* noalias align 16, i128* noalias readonly align 512) unnamed_addr #2 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::vector<float, 4>"(%"class.hls::vector<float, 4>"* align 16 %0, i128* align 512 %1)
  ret void
}

declare void @Macro_MAC_Acc4_top_hw_stub(%"class.hls::vector<float, 4>"* noalias nocapture nonnull, %"class.hls::vector<float, 4>"* noalias nocapture nonnull readonly, %"class.hls::vector<unsigned int, 4>"* noalias nocapture nonnull readonly, %"class.hls::vector<unsigned int, 4>"* noalias nocapture nonnull readonly, %"class.hls::vector<unsigned int, 4>"* noalias nocapture nonnull readonly, %"class.hls::vector<unsigned int, 4>"* noalias nocapture nonnull readonly, i16 zeroext)

define void @Macro_MAC_Acc4_top_hw_stub_wrapper(i128*, i128*, i128*, i128*, i128*, i128*, i16) #6 {
entry:
  %7 = call i8* @malloc(i64 16)
  %8 = bitcast i8* %7 to %"class.hls::vector<float, 4>"*
  %9 = call i8* @malloc(i64 16)
  %10 = bitcast i8* %9 to %"class.hls::vector<float, 4>"*
  %11 = call i8* @malloc(i64 16)
  %12 = bitcast i8* %11 to %"class.hls::vector<unsigned int, 4>"*
  %13 = call i8* @malloc(i64 16)
  %14 = bitcast i8* %13 to %"class.hls::vector<unsigned int, 4>"*
  %15 = call i8* @malloc(i64 16)
  %16 = bitcast i8* %15 to %"class.hls::vector<unsigned int, 4>"*
  %17 = call i8* @malloc(i64 16)
  %18 = bitcast i8* %17 to %"class.hls::vector<unsigned int, 4>"*
  call void @copy_out(%"class.hls::vector<float, 4>"* %8, i128* %0, %"class.hls::vector<float, 4>"* %10, i128* %1, %"class.hls::vector<unsigned int, 4>"* %12, i128* %2, %"class.hls::vector<unsigned int, 4>"* %14, i128* %3, %"class.hls::vector<unsigned int, 4>"* %16, i128* %4, %"class.hls::vector<unsigned int, 4>"* %18, i128* %5)
  call void @Macro_MAC_Acc4_top_hw_stub(%"class.hls::vector<float, 4>"* %8, %"class.hls::vector<float, 4>"* %10, %"class.hls::vector<unsigned int, 4>"* %12, %"class.hls::vector<unsigned int, 4>"* %14, %"class.hls::vector<unsigned int, 4>"* %16, %"class.hls::vector<unsigned int, 4>"* %18, i16 %6)
  call void @copy_in(%"class.hls::vector<float, 4>"* %8, i128* %0, %"class.hls::vector<float, 4>"* %10, i128* %1, %"class.hls::vector<unsigned int, 4>"* %12, i128* %2, %"class.hls::vector<unsigned int, 4>"* %14, i128* %3, %"class.hls::vector<unsigned int, 4>"* %16, i128* %4, %"class.hls::vector<unsigned int, 4>"* %18, i128* %5)
  call void @free(i8* %7)
  call void @free(i8* %9)
  call void @free(i8* %11)
  call void @free(i8* %13)
  call void @free(i8* %15)
  call void @free(i8* %17)
  ret void
}

attributes #0 = { noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyout" }
attributes #3 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #4 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
attributes #5 = { alwaysinline nounwind readnone willreturn }
attributes #6 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
