% Day 3b. Capture 480x480 - an example of retreiving a 640x480 image
% from USB camera, and then save it as 480x480. (Centered Image will be cropped.)
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
    %cam.Resolution = '640x480';
    %cam.ExposureMode = 'auto';
    %cam.WhiteBalanceMode = 'auto';
    preview(cam);
    
    %snapshot a single image
    pause;
    im = snapshot(cam);
    imshow(im);
    closePreview(cam);
    
    %store the original image as 480x480
    height = size(im, 1);
    width = size(im, 2);
    channels = size(im, 3);
    startcol = idivide(width - height, int32(2));
    dst = uint8(zeros(height, height, channels));
    dst = im(:, startcol:startcol+height-1, :); 
    imwrite(dst, 'img_480x480.jpg');    
    %done
end