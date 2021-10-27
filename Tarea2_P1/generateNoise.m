function generateNoise(ov,nv,fm)
  %originalVideo = "./InputVideos/original_video.avi";
  originalVideo = ov;
  %noiseVideoName = "./InputVideos/video_con_ruido.avi";
  noiseVideoName = nv;

  video=VideoReader(originalVideo); 
  finalResult = VideoWriter(noiseVideoName, 'HFYU'); 

  m=video.Height; 
  n=video.Width; 

  frame=uint8(zeros(m,n));


  
 
  %Add noise and resize video for better filtering
  parfor k=1:fm %
    frame = im2uint8(readFrame(video)); 
    imageWNoise = imnoise(frame(:,:,1), "salt & pepper", 0.02);
    writeVideo(finalResult,imageWNoise);
  endparfor
 
   close(finalResult); 
   
endfunction

