function filtrarVideos(nv,fmfa_o,hpdbmf_o,fm)
  %Función que se encarga de hacer el filtrado de los algoritmos FMFA y HPDBMF
  %Entradas: la dirección del video con ruido, el video sin ruido del algoritmo 1
  %          y el video sin ruido del algoritmo 2.
  %Salidas: ninguna

  
  NoiseVideo = nv;
  
  FMFA_output = fmfa_o;
  
  HPDBMF_output = hpdbmf_o;
  
  video=VideoReader(NoiseVideo);
  fmfa_result=VideoWriter(FMFA_output,'HFYU'); 
  HPDBMF_result=VideoWriter(HPDBMF_output, 'HFYU'); 
  tic
  parfor k=1:fm %6 seconds to filter
    image = uint8(readFrame(video)); 
    img = image(:,:,1);
    R1 = filtros(img,1); %Filtrar frame con el algoritmo 1
    R2 = filtros(img,2); %Filtrar frame con el algoritmo 1
    writeVideo(fmfa_result, R1); 
    writeVideo(HPDBMF_result,R2); 
    k
  endparfor
  ExecutionTime=toc
  close(fmfa_result);
  close(HPDBMF_result); 
endfunction



