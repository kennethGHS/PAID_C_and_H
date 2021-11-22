function R = SelectiveColor(A)
  hsvImage = rgb2hsv(A);         % Convert the image to HSV space
  hPlane = 360.*hsvImage(:, :, 1);  % Get the hue plane scaled from 0 to 360
  sPlane = hsvImage(:, :, 2);        % Get the saturation plane
  nonColorIndex1 = (hPlane > 270) & ...  % Select "non-color selected" pixels
                (hPlane <= 360);
  sPlane(nonColorIndex1) = 0; 
  hsvImage(:, :, 2) = sPlane;        % Update the saturation plane
  nonColorIndex2 = (hPlane >= 0) & ...  % Select "non-color selected" pixels
                (hPlane < 180);
  sPlane(nonColorIndex2) = 0;          % Set the selected pixel saturations to 0
  hsvImage(:, :, 2) = sPlane;        % Update the saturation plane
  R = hsv2rgb(hsvImage);      % Convert the image back to RGB space
endfunction


%https://stackoverflow.com/questions/4063965/how-can-i-convert-an-rgb-image-to-grayscale-but-keep-one-color