function [fmfSsim, hpdbmfSsim] = ssim_analysis(refVideo, FMFA_out, HPDBMF_out)
  %Funcion encargado de llamar a la funcion de SSIM la cual realiza la comparación.
  %Entradas: - El video de referencia  
  %          - Video resultante del FMFA
  %          - Video resultante de HPDBMF
  %Salida: - Array con resultados de la comparación estructural del FMFA
  %        - Array con resultados de la comparación estructural del HPDBMF
  originalVideo=VideoReader(refVideo); 
  fmfaVideo = VideoReader(FMFA_out); 
  hpdbmfVideo = VideoReader(HPDBMF_out); 
  frames = fmfaVideo.NumberOfFrames; 
  fmfSsim=zeros(1,frames);
  hpdbmfSsim=zeros(1,frames);
  for k=1:frames
    originalImage = im2uint8(readFrame(originalVideo)); 
    fmfaImage = im2uint8(readFrame(fmfaVideo)); 
    hpdbmfImage = im2uint8(readFrame(hpdbmfVideo)); 
    fmfSsim(k) = ssim(originalImage(:,:,1), fmfaImage(:,:,1)); 
    hpdbmfSsim(k) = ssim(originalImage(:,:,1), hpdbmfImage(:,:,1)); 
  endfor 
  
endfunction