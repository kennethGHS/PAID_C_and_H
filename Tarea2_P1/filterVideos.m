clc; clear;close all; 

pkg load image
pkg load video 

function filterVideos(video_input, video_output_fmf, video_output_iam, frames)

  V=VideoReader(video_input);
  m=V.Height; 
  n=V.Width; 
  video_result_fmf=VideoWriter(video_output_fmf); 
  video_result_HPDBMF=VideoWriter(video_output_iam); 
 
  parfor k=1:frames 
    Frame_k = uint8(readFrame(V)); 
    tic
    writeVideo(video_result_fmf, fast_median_filter_aprox_v2(Frame_k(:,:,1))); 
    writeVideo(video_result_HPDBMF, HPDBMF_v2(Frame_k(:,:,1))); 
    t1=toc
  endparfor
  close(video_result_fmf);
  close(video_result_HPDBMF); 
endfunction

frames=77;

video_ruido="video_con_ruido.avi";

video_limpio_fmf="video_sin_ruido_alg1_v2.avi";

video_limpio_iam="video_sin_ruido_alg2_v2.avi";

filterVideos(video_ruido, video_limpio_fmf, video_limpio_iam, frames);

%filterVideos("video_con_ruido.mp4", "video_sin_ruido_alg1_v2.mp4", "video_sin_ruido_alg2_v2.mp4", 77)