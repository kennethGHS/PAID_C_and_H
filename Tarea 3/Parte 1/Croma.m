clc;
clear;
close all;
pkg load image;
pkg load video;

%%%% Croma %%%%%

%Read the videos
video_person=VideoReader('Isaac.mp4');
video_background=VideoReader('playa.mp4');

%Get the number of frames of the videos
fr_person=video_person.NumberOfFrames
fr_background=video_background.NumberOfFrames

%Get the eidth and height from the person video
m = video_person.Height;
n = video_person.Width;

%Create a matrix to save the result video
frames_final = uint8(zeros(m,n,3,fr_person));
%Create a video file to store the video result
video=VideoWriter('video_croma.avi');
open(video)

%Loop to get each frame of the videos
for k = 1: fr_person
  %Read each frame from the videos
  frame_p=readFrame(video_person);
  frame_b=readFrame(video_background);
  %Change color of the background person frame to green
  frame_person_green = SelectiveColorTransfer(frame_p);
  %Join the person frame and the background frame
  frames_join = image_background(frame_person_green,frame_b);
  %Get the borders of the person
  border_person=edge(rgb2gray(frame_p),"Canny");
  %Apply convolution between the joined frames and the borders of 
  %the person
  convolution = conv2_border(frames_join,border_person,10);
  %store the results of convolution into the matrix
  frames_final(:,:,1,k) = convolution(:,:,1);
  frames_final(:,:,2,k) = convolution(:,:,2);
  frames_final(:,:,3,k) = convolution(:,:,3);
endfor

%Loop to store data from the matrix to video file
for i=1:fr_person
  writeVideo(video,frames_final(:,:,:,i));
endfor
close(video)
