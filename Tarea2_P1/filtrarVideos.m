clc; clear;close all; 

pkg load image
pkg load video 

function filtrarVideos()

  NoiseVideo = "./InputVideos/video_con_ruido.avi";

  FMFA_output ="./OutputVideos/video_sin_ruido_alg1_v2.avi";

  HPDBMF_output="./OutputVideos/video_sin_ruido_alg2_v2.avi";
  
  video=VideoReader(NoiseVideo);
  fmfa_result=VideoWriter(FMFA_output,'HFYU'); 
  HPDBMF_result=VideoWriter(HPDBMF_output, 'HFYU'); 
  tic
  parfor k=1:77 %6 seconds to filter
    image = uint8(readFrame(video)); 
    writeVideo(fmfa_result, fast_median_filter_aprox_v2(image(:,:,1))); 
    writeVideo(HPDBMF_result, HPDBMF_v2(image(:,:,1))); 
    
  endparfor
  ExecutionTime=toc
  close(fmfa_result);
  close(HPDBMF_result); 
endfunction


filtrarVideos();
