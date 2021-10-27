clc;
clear;
close all;
%Funcion que realiza el filtro de FMFA y HPDBMF y la comparación entre los videos ingresados
pkg load image
pkg load video

originalVideo = "./InputVideos/original_video.avi";

NoiseVideo = "./InputVideos/video_con_ruido.avi";

FMFA_output ="./OutputVideos/video_sin_ruido_alg1_v2.avi";

HPDBMF_output="./OutputVideos/video_sin_ruido_alg2_v2.avi";


frames=200; %Frames para 6 segundos
M = "Añadiendo ruido tipo sal y pimienta al video"
generateNoise(originalVideo, NoiseVideo,frames); %Generamos el ruido
M = "Filtrando ambos metodos mediante los algoritmos de FMFA y HPDBMF"
filtrarVideos(NoiseVideo, FMFA_output, HPDBMF_output, frames); %Filtramos ambos videos por ambos algoritmos
M = "Realizano el SSIM entre los videos resultantes"
plot_x=1:frames; %Ploteamos para todos los frames
[FMFA_values, HPDBMF_values]=ssim_analysis(originalVideo, FMFA_output, HPDBMF_output);
plot(plot_x, FMFA_values,"-", plot_x, HPDBMF_values, "-");
xlabel("Frames");
ylabel("SSIM");
legend("FMFA", "HPDBMF");
title("FMFA y HPDBMF")