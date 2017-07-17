% Day 1-E. circle detection - an example of circle detection in an image.
%                                       Edge detection, Hough transform,
%                                       Voting, and Thresholding
% This file is part of inaugural summer camp: 
%            'Girls Solving Societal Problems Through Computer Science.'
% written by Jinhang Choi (jpc5731@cse.psu.edu) 
%            and the Pennsylvania State University.
% More information about this camp is available at: 
% http://www.eecs.psu.edu/community/EECS-Computer-Science-Camp.aspx

clear all; close all;

% Setting image folder
BASE_PATH = '../imgs/e_circle_detection/';

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

    % configurable parameters
    sigma = 2.5;
    min_radius = 15;
    max_radius = 200;
    alpha = 0.9;    

    % Scale color space in [0, 1]
    im = single(im)/255;
    
    % find edges
    im = imgaussfilt(rgb2gray(im), sigma);
    im_edge = edge(im, 'canny');    
    imshow(im_edge);
    title('Edges'); pause;
    
    % list valid location indicating a point of edge
    [y, x] = find(im_edge);
    [m, n] = size(im_edge);
    
    % hough map table
    hough = zeros(m, n, max_radius-min_radius+1);

    sz = m * n;
    progress = 0;
    total = length(x);
    disp(['find circles of radius ranging from ' num2str(min_radius) ...
                ' to ' num2str(max_radius)]);
    for point=1:total
        % Display progress of processing hough transform
        if (point/total >= progress)
            disp(['voting circles at edge pixel ' ...
                                    num2str(point) '/' num2str(total)]);
            progress = progress + 0.1;
        end
        
        % vote circles for every pixels in an image.
        for radius=min_radius:max_radius
            % (a,b) = center of a circle
            % a = x - r*cos(theta)
            % b = y - r*sin(theta)
            theta = (1.0:360.0) .* pi/180.0;
            a = (round(x(point) - radius*cos(theta)));
            b = (round(y(point) - radius*sin(theta)));
            
            valid_pos = a > 0 & a < n;
            a = a(valid_pos);
            b = b(valid_pos);
            valid_pos = b > 0 & b < m;
            a = a(valid_pos);
            b = b(valid_pos);

            index = sub2ind([m, n], b, a);
            hough(sz*(radius-min_radius)+index) = ...
                hough(sz*(radius-min_radius)+index) + 1;
        end
    end
    
    % Collect circles : format (a, b, radius, ratio)
    % Assume that Detectable edge pixels should be more than 90%
    % range: min_radius ~ max_radius
    two_pi = 0.9*2*pi;
    max_vote = max(hough(:));
    circles = zeros(0, 4);
    for radius=min_radius:max_radius
        circumference = two_pi * radius;
        threshold = min(circumference, max_vote) * alpha;
        candidates = hough(:,:,radius-min_radius+1);
        candidates(candidates < threshold) = 0;
        [b, a, count] = find(candidates);
        circles = [circles; [a, b, radius*ones(length(a), 1), ...
                            count/circumference]];
    end
    disp(['total ' num2str(size(circles,1)) ' circles are detected.'] );
    viscircles(circles(:,1:2),circles(:,3),'EdgeColor','b');
    title('Circles in edges');
    
    if i ~= num_files
        pause;
    end
end