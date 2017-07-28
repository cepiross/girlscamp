% Day 3b. Capture 1280x360 - an example of retreiving a 640x360 image
% from USB camera, and then save it as 1280x360. (Centered Image will be placed.)
%
% This file is part of inaugural summer camp: 
%            'Girls Solving Societal Problems Through Computer Science.'
% written by Jinhang Choi (jpc5731@cse.psu.edu) 
%            and the Pennsylvania State University.
% More information about this camp is available at: 
% http://www.eecs.psu.edu/community/EECS-Computer-Science-Camp.aspx

% Test your own image
if (size(webcamlist, 1) > 0)
    %close camera
    clear all;

    %open camera
    cam = webcam(1);
    cam.Resolution = '640x360';
    cam.ExposureMode = 'auto';
    cam.WhiteBalanceMode = 'auto';
    preview(cam);
    
    %snapshot a single image
    pause;
    im = snapshot(cam);
    imshow(im);
    closePreview(cam);
    
    %store the original image as 1280x360
    height = size(im, 1);
    width = size(im, 2);
    channels = size(im, 3);
    startcol = idivide(width, int32(2));
    dst = uint8(zeros(height, width*2, channels));
    dst(:, startcol:startcol+width-1, :) = im; 
    imwrite(dst, 'img_1280x360.jpg');
    %done
end