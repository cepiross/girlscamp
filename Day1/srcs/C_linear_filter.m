% Day 1-C. linear filter - an example of applying filters in an image.
%                                   identity, smoothing, sharpening, 
%                                   and differentiation (edge operation)
% This file is part of inaugural summer camp: 
%            'Girls Solving Societal Problems Through Computer Science.'
% written by Jinhang Choi (jpc5731@cse.psu.edu) 
%            and the Pennsylvania State University.
% More information about this camp is available at: 
% http://www.eecs.psu.edu/community/EECS-Computer-Science-Camp.aspx

clear all; close all;

% Setting image folder
BASE_PATH = '../imgs/c_linear_filter/';

% Setting path to image files
files = dir([BASE_PATH '*.jpg']);
for i=1:numel(files)
    file_names{i} = [BASE_PATH files(i).name];
end

num_files = size(file_names, 2);
for i=1:num_files
    % Read an image
    im = imread(file_names{i});
    clf;
    
    % Display the image
    imshow(im);
    pause; clf;

    % original image
    identity = [0 0 0;
                0 1 0;
                0 0 0];
    % smoothing (blur)
    %	averaging: 3x3
    average = [1/9 1/9 1/9;
               1/9 1/9 1/9;
               1/9 1/9 1/9];
    %	averaging: 5x5
    average2 = [1/25 1/25 1/25 1/25 1/25;
                1/25 1/25 1/25 1/25 1/25;
                1/25 1/25 1/25 1/25 1/25;
                1/25 1/25 1/25 1/25 1/25;
                1/25 1/25 1/25 1/25 1/25];
    %	weighted averaging: 3x3
    weighted_average = [1/16 2/16 1/16;
                        2/16 4/16 2/16;
                        1/16 2/16 1/16];
    %	gaussian approximation: 5x5, sigma=1
    weighted_average2 = [1/273 4/273 7/273 4/273 1/273;
                        4/273 16/273 26/273 16/273 4/273;
                        7/273 26/273 41/273 26/273 7/273;
                        4/273 16/273 26/273 16/273 4/273;
                        1/273 4/273 7/273 4/273 1/273];                    
    % outline = original - blurred image
    outline = [-1 -1 -1;
               -1  8 -1;
               -1 -1 -1];
    % sharpening = original + scaled outline
    sharpen = identity + outline/9;

    % smoothing and differentiation (edge operation)
    %  [1 1 1]^t x [-1 0 1]
    prewitt_vertical = [-1 0 1;
                        -1 0 1;
                        -1 0 1];
    %  [-1 0 1]^t x [1 1 1]
    prewitt_horizontal = [-1 -1 -1;
                           0  0  0;
                           1  1  1];
    %  [1 2 1]^t x [-1 0 1]
    sobel_vertical = [-1 0 1;
                      -2 0 2;
                      -1 0 1];
    %  [-1 0 1]^t x [1 2 1]
    sobel_horizontal = [-1 -2 -1;
                         0  0  0;
                         1  2  1];

    % otherwise, make your own filter!
    your_funny_filter = [1 0 0;
                         0 1 0;
                         0 0 1];
                         
    % configurable parameter
    filter = sobel_vertical;
    % Perform your filter to the image    
    im_filtered = imfilter(im, filter);
    imshow(im_filtered); title('filter result');

    if i ~= num_files
        pause;
    end
end