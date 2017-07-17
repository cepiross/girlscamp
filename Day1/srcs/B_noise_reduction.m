% Day 1-B. noise_reduction - an example of reducing noises in an image.
%                                   Blur (linear), and Medium (non-linear)
% This file is part of inaugural summer camp: 
%            'Girls Solving Societal Problems Through Computer Science.'
% written by Jinhang Choi (jpc5731@cse.psu.edu) 
%            and the Pennsylvania State University.
% More information about this camp is available at: 
% http://www.eecs.psu.edu/community/EECS-Computer-Science-Camp.aspx

clear all; close all;
  
% Setting image folder
BASE_PATH = '../imgs/b_noise_reduction/';

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

    % configurable parameter
    filter_size = 3;

    % linear filter (blur)
    blur = fspecial('average', filter_size);    
    im_filtered = imfilter(im, blur);
    subplot(1,2,1); imshow(im_filtered); title('blur (linear)');
    
    % non-linear filter
    disp('Median filter (Processing takes time...)');
    im_filtered = median_filter(im, int32(filter_size));
    subplot(1,2,2); imshow(im_filtered); title('median (non-linear)');
    
    if i ~= num_files
        pause;
    end
end