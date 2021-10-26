clc; clear; close all;
pkg load image
pkg load video


unshapedVideo="./Videos/image_video.mp4";
resizedVideoName="./InputVideos/original_video.avi";
resizedVideo = VideoWriter(resizedVideoName);
video=VideoReader(unshapedVideo);
m_org=video.Height;
n_org=video.Width;
frames = video.NumberOfFrames;
for k=1:77 %Time for 6 seconds
  image = readFrame(video);
  writeVideo(resizedVideo, imresize(uint8(image), [200 200]));
  k
  endfor
close(resizedVideo);

