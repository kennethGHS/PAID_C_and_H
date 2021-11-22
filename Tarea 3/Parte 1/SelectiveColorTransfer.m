function R = SelectiveColorTransfer(A)
  R=A;
  %Get the colors of each pixel
  rPlane = R(:,:,1); 
  gPlane = R(:,:,2);
  bPlane = R(:,:,3);
  %Get only the pixels with color selected
  ColorIndex = ((bPlane-gPlane)>=50);
  %Change the color of the selected pixels of the image to green
  rPlane(ColorIndex) = 0;
  gPlane(ColorIndex) = 255;
  bPlane(ColorIndex) = 0; 
  R(:,:, 1) = rPlane;
  R(:,:, 2) = gPlane; 
  R(:,:, 3) = bPlane; 
endfunction