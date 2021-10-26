clc; %limpiar consola
clear;%limpiamos variables
close all; %Cierra todas las figuras
pkg load video
pkg load image


originalVideo = "./InputVideos/original_video.avi";
noiseVideoName = "./InputVideos/video_con_ruido.avi";

video=VideoReader(originalVideo); 
finalResult = VideoWriter(noiseVideoName, 'HFYU'); 

m=video.Height; 
n=video.Width; 

frame=uint8(zeros(m,n));


frames =  77; %Change to 250
 
%Add noise and resize video for better filtering
parfor k=1:frames %
   frame = im2uint8(readFrame(video)); 
   imageWNoise = imnoise(frame(:,:,1), "salt & pepper", 0.02);
   writeVideo(finalResult,imageWNoise);
endparfor
 
close(finalResult); 

