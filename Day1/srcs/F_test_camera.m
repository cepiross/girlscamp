% Day 1-E. Test Camera - an example of retreiving an image from USB camera
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
    %cam.ExposureMode = 'auto';
    %cam.WhiteBalanceMode = 'auto';
    preview(cam);
    
    %snapshot a single image
    pause;
    im = snapshot(cam);
    imshow(im);
    closePreview(cam);
    
    %store the originam image
    imwrite(im, '../imgs/f_test_camera/original.jpg');    
    pause;
    
    %put and test code A ~ E here! :D
     % configurable parameters
    sigma = 1.05;
    threshold_alpha = 1.7;
    threshold_beta = 0.5;

    % Implementation of canny edge detector
    
    %  [-1 0 1]^t x [1 2 1]
    sobel_horizontal = [-1 -2 -1;
                         0  0  0;
                         1  2  1];
    %  [1 2 1]^t x [-1 0 1]
    sobel_vertical = [-1 0 1;
                      -2 0 2;
                      -1 0 1];
    dx_filter = sobel_horizontal;
    dy_filter = sobel_vertical;
    
    % Scale color space in [0, 1]
    im = single(im)/255;
    
    % A. Smoothing: Gaussian filter
    if (sigma > 0)
        im = imgaussfilt(im, sigma);
    end
    
    % B-I. Gradient Computation: x-axis/y-axis derivates of an image
    im_dx = imfilter(im, dx_filter, 'replicate');
    im_dy = imfilter(im, dy_filter, 'replicate');
    
    % B-II. Compute magnitude (element-wise norm of gradient) in an image
    %  original canny : magnitude = sqrt(dx^2 + dy^2)
    %  multivariate canny : magnitude = |Jacobian'*Jacobian|
    %  J'*J = [ rx, gx, bx     [ rx, ry 
    %           ry, gy, by ] *   gx, gy
    %                            bx, by ]
    %       = [ rx^2+gx^2+bx^2   , rx*ry+gx*gy+bx*by   = [ Jxx , Jxy
    %           rx*ry+gx*gy+bx*by, ry^2+gy^2+by^2    ]     Jxy,  Jyy ]    
    Jxx = sum(im_dx.^2, 3);
    Jyy = sum(im_dy.^2, 3);
    Jxy = sum(im_dx.*im_dy, 3);    
    %  calculate the largest eigenvalue of J'*J
    %  abs is needed for round-off errors
    D = abs(Jxx.^2 - 2*Jxx.*Jyy + Jyy.^2 + 4*Jxy.^2);
    eigen = (Jxx + Jyy + sqrt(D))/2;
    im_mag = sqrt(eigen);
    imshow(im_mag);
    title('smoothing + sobel operator'); pause;
    
    % B-III. Compute orientation in an image
    %  original canny : theta = arctan(dy/dx)*(180.0/pi)
    %  multivariate canny : theta = arctan(eigenvector tangent)*(180.0/pi)
    %                       eigenvector (u, v) = (Jxy, eigen-Jxx)
    im_slope = Jxy./(eigen-Jxx);
    im_ori = atan(im_slope)*180.0/pi;  
    %  change orientation space from [-90, 90] degrees to [0, 180] degrees
    ori_neg = im_ori<0;
    im_ori(ori_neg) = im_ori(ori_neg) + 180;
    %  and bin directions in one of four orientations.
    im_binned_ori = zeros(size(im_ori));
    im_binned_ori(im_ori<45 & im_ori>=180) = 1;
    im_binned_ori(im_ori>=45 & im_ori<90) = 2;
    im_binned_ori(im_ori>=90 & im_ori<135) = 3;
    im_binned_ori(im_ori>=135 & im_ori<180) = 4;
    %  set 1-pix boaundaries (do not take account of them)
    im_binned_ori(1,:) = 0;
    im_binned_ori(end,:) = 0;
    im_binned_ori(:,1) = 0;
    im_binned_ori(:,end) = 0;
    
    % C. Interpolation-based Non-Maximal Suppression on 8 neighbors
    im_candidates = zeros(size(im_ori));
    rows = size(im_candidates, 1);
    %  Case 1: 0-45 degree.
    indices = find(im_binned_ori == 1);
    slopes = im_slope(indices);
    %   Interpolation btw (i+1,j+1) and (i,j+1)
    diff1 = slopes.*(im_mag(indices)-im_mag(indices+rows+1)) + ...
            (1-slopes).*(im_mag(indices)-im_mag(indices+1));
    %   Interpolation btw (i-1,j-1) and (i,j-1)
    diff2 = slopes.*(im_mag(indices)-im_mag(indices-rows-1)) + ...
            (1-slopes).*(im_mag(indices)-im_mag(indices-1));
    %   pass a candidate only if (i,j) is a local maximum.
    im_candidates(indices(diff1 >=0 & diff2 >= 0)) = 1;

    %  Case 2: 45-90 degree.
    indices = find(im_binned_ori == 2);
    slopes_inverse = 1./im_slope(indices);
    %   Interpolation btw (i+1,j+1) and (i+1,j)
    diff1 = slopes_inverse.*(im_mag(indices)-im_mag(indices+rows+1)) + ...
            (1-slopes_inverse).*(im_mag(indices)-im_mag(indices+rows));
    %   Interpolation btw (i-1,j-1) and (i-1,j)
    diff2 = slopes_inverse.*(im_mag(indices)-im_mag(indices-rows-1)) + ...
            (1-slopes_inverse).*(im_mag(indices)-im_mag(indices-rows));
    %   pass a candidate only if (i,j) is a local maximum.
    im_candidates(indices(diff1 >=0 & diff2 >= 0)) = 1;

    %  Case 3: 90-135 degree.
    indices = find(im_binned_ori == 3);
    slopes_inverse = abs(1./im_slope(indices));
    %   Interpolation btw (i+1,j-1) and (i+1,j)
    diff1 = slopes_inverse.*(im_mag(indices)-im_mag(indices+rows-1)) + ...
            (1-slopes_inverse).*(im_mag(indices)-im_mag(indices+rows));
    %   Interpolation btw (i-1,j+1) and (i-1,j)
    diff2 = slopes_inverse.*(im_mag(indices)-im_mag(indices-rows+1)) + ...
            (1-slopes_inverse).*(im_mag(indices)-im_mag(indices-rows));
    %   pass a candidate only if (i,j) is a local maximum.
    im_candidates(indices(diff1 >=0 & diff2 >= 0)) = 1;

    %  Case 4: 135-180 degree.
    indices = find(im_binned_ori == 4);
    slopes = abs(im_slope(indices));
    %   Interpolation btw (i+1,j-1) and (i,j-1)
    diff1 = slopes.*(im_mag(indices)-im_mag(indices+rows-1)) + ...
            (1-slopes).*(im_mag(indices)-im_mag(indices-1));
    %   Interpolation btw (i-1,j+1) and (i,j+1)
    diff2 = slopes.*(im_mag(indices)-im_mag(indices-rows+1)) + ...
            (1-slopes).*(im_mag(indices)-im_mag(indices+1));
    %   pass a candidate only if (i,j) is a local maximum.
    im_candidates(indices(diff1 >=0 & diff2 >= 0)) = 1;
    
    % D. Hysteresis thresholding
    mag_mean = mean(im_mag(:));
    mag_highth = threshold_alpha * mag_mean;
    mag_lowth = threshold_beta * mag_mean;
    
    im_candidates = im_candidates * 0.6;
    im_candidates(im_mag >= mag_highth) = 1;
    im_candidates(im_mag < mag_lowth) = 0;
    im_candidates(1,:) = 0;
    im_candidates(end,:) = 0;
    im_candidates(:,1) = 0;
    im_candidates(:,end) = 0;
    
    prev_candidates = [];
    curr_candidates = find(im_candidates == 1);
    while (size(prev_candidates, 1) ~= size(curr_candidates, 1))
        prev_candidates = curr_candidates;
        indices_neighbors = [curr_candidates+rows+1, ...
                             curr_candidates+rows, ...
                             curr_candidates+rows-1, ...
                             curr_candidates+1, ...
                             curr_candidates-1, ...
                             curr_candidates-rows+1, ...
                             curr_candidates-rows, ...
                             curr_candidates-rows-1];
        for idx=1:size(indices_neighbors,2)
            indices = find(im_candidates(indices_neighbors(:,idx))==0.6);
            im_candidates(indices_neighbors(indices,idx)) = ...
                        im_candidates(indices_neighbors(indices,idx))+0.4;
            im_candidates(im_candidates == 0.4) = 0;
        end
        im_candidates(im_candidates > 1) = 1;
        curr_candidates = find(im_candidates == 1);
    end
    im_candidates(im_candidates ~= 1) = 0;
    imshow(im_candidates);
    title('Non-Maximal Suppression + Hysteresis thresholding');
    
    %done
end