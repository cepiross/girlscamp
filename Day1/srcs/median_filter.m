% median_filter - non-linear filter for reducing noise in an image.
%
% res = median_filter(im, filter_size)
%    take median values from filter_size x filter_size of im blocks.

% This file is part of inaugural summer camp: 
%            'Girls Solving Societal Problems Through Computer Science.'
% written by Jinhang Choi (jpc5731@cse.psu.edu) 
%            and the Pennsylvania State University.
% More information about this camp is available at: 
% http://www.eecs.psu.edu/community/EECS-Computer-Science-Camp.aspx
function res = median_filter(im, filter_size)
    im_rows = size(im, 1);
    im_cols = size(im, 2);
    im_channels = size(im, 3);
    side_length = idivide(filter_size, 2);
    
    res = repmat(uint8(0), size(im));
    for row=1:im_rows
        for col=1:im_cols
            end_row = row + filter_size - side_length - 1;
            end_col = col + filter_size - side_length - 1;
            start_row = end_row - filter_size;
            if (end_row > im_rows)
                end_row = im_rows;
            end
            if (start_row < 1)
                start_row = 1;
            end
            start_col = end_col - filter_size;
            if (end_col > im_cols)
                end_col = im_cols;
            end
            if (start_col < 1)
                start_col = 1;
            end
            
            % Crop filter_size x filter_size matrix at (row, col)
            candidates = im(start_row:end_row, start_col:end_col, :);
            % Sort the numbers in order
            candidates = sort(reshape(candidates, 1, [], im_channels));
            % Take a median and store it at (row, col)
            midpoint = idivide(int32(size(candidates, 2)), 2);
            res(row, col, :) = candidates(1, midpoint, :);
        end
    end
end