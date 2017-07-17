% Day 1-A. read_img - an example of reading and displaying an image.
%                               RGB Channels, Grayscale, and thresholding
% This file is part of inaugural summer camp: 
%            'Girls Solving Societal Problems Through Computer Science.'
% written by Jinhang Choi (jpc5731@cse.psu.edu) 
%            and the Pennsylvania State University.
% More information about this camp is available at: 
% http://www.eecs.psu.edu/community/EECS-Computer-Science-Camp.aspx

clear all; close all;

% Setting image folder
BASE_PATH = '../imgs/a_read_img/';

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
    % Matrix shape: width x height x channel(RGB)
    imshow(im);
    pause; 
    % Clear figure
    clf; 
    
    % Display Red Channel
    im_dup = im;
    im_dup(:,:,2) = 0; % Set green channel as empty
    im_dup(:,:,3) = 0; % Set blue channel as empty
    subplot(2, 2, 1); imshow(im_dup); title('red channel');
    
    % Display Green Channel
    im_dup = im;
    im_dup(:,:,1) = 0; % Set red channel as empty
    im_dup(:,:,3) = 0; % Set blue channel as empty
    subplot(2, 2, 2); imshow(im_dup); title('green channel');

    % Display Blue Channel
    im_dup = im;
    im_dup(:,:,1) = 0; % Set red channel as empty
    im_dup(:,:,2) = 0; % Set green channel as empty
    subplot(2, 2, 3); imshow(im_dup); title('blue channel');
    
    % Display Simple Gray=scale Image
    % 0.4 x Red + 0.4 x Green + 0.2 x Blue
    im_gray = 0.4*im(:,:,1) + 0.4*im(:,:,2) + 0.2*im(:,:,3);
    subplot(2, 2, 4); imshow(im_gray); title('grayscale image');
    pause;
    
    % configurable parameter
    threshold = 128;
    % Display Thresholding    
    indices = im_gray(:,:,:) <= threshold;
    im_gray(indices) = 0;
    im_gray(~indices) = 255;
    subplot(2, 2, 4); imshow(im_gray); title('image thresholding');
    
    if i ~= num_files
        pause;
    end
end