function stitched_img = stitchImg(varargin)
%STITCHIMG stitch multiple images into a single mosaic
% 
% GENERAL NOTE: Feel free to change all of this file, not just the
%               "ADD YOUR CODE HERE" sections. We're just trying to help
%               get you started.
    
    % The code below makes sure there is a very large canvas for us to put
    % the stitched image in. It's height is twice the sum of the heights of
    % the input images, and its width is twice the sum of their widths.
    % 
    % This makes the image really large, so you might want to crop the
    % blank borders at the end, using the helper function bbox_crop.
    H_stitched = sum(cellfun(@(x) size(x, 1), varargin));
    W_stitched = sum(cellfun(@(x) size(x, 2), varargin));
    % Images should be all grayscale or all colour
    assert(max(cellfun(@(x) size(x, 3), varargin)...
            == min(cellfun(@(x) size(x, 3), varargin))));
    C_stitched = size(varargin{1}, 3);
    stitched_img = zeros(H_stitched, W_stitched, C_stitched);
    
    % NOTE: The scaffolding code given below assumes that the reference
    % image is the "middle" image in the image sequence passed in through
    % 'varargin'. So if you call this function like:
    %       stitchImg(img_l, img_c, img_r)
    % for images taken left-to-right in the sequence [img_l, img_c, img_r],
    % this code will assume img_c is the reference and it covers the middle
    % of the canvas.
    % 
    % If you'd like to do something else, you will have to change the
    % scaffolding code in addition to the new code that you add.    
    num_imgs = numel(varargin);
    middle_idx = round((num_imgs + 1) / 2);
    % NOTE: you can put a different value here if you want!
    ref_idx = middle_idx;
    
    % paste the reference image into the output canvas.
    ref_img = varargin{ref_idx};
    H_ref = size(ref_img, 1);
    W_ref = size(ref_img, 2);
    ref_start_x = 1 + floor((W_stitched - W_ref) / 2);
    ref_start_y = 1 + floor((H_stitched - H_ref) / 2);
    stitched_img(ref_start_y : ref_start_y + H_ref - 1,...
                 ref_start_x : ref_start_x + W_ref - 1,...
                 :) = ref_img;
             
    stitch_mask = false(H_stitched, W_stitched);
    stitch_mask(ref_start_y : ref_start_y + H_ref - 1,...
                ref_start_x : ref_start_x + W_ref - 1) = true;
             
    for n = 1:num_imgs
        if n == ref_idx
            continue
        end
        img_n = varargin{n};
        [kp_stitched, kp_n] = genSIFTMatches(stitched_img, img_n);
        % ---------------------------------------
        % ADD YOUR CODE HERE
        % ---------------------------------------
        % Blend img_n into stitched_img, after finding the right homography
        % to register it, and warping it with the reverse transformation 
        % (backward warp). 
        % Use RANSAC to avoid problems caused by outliers.
       
%       accept an arbitrary number of images 
%       Use varargin to take variable number of inputs
%       Assume order of the images matches the order you wish to stitch
%       the images.
%       stitch images of a single row/column
%       use blend mode to blend the image when calling blendImagePair

        %run ransac 
%         disp("stitched: " + kp_stitched);
%         disp("n: " + kp_n);
        [inliers_id, H_3x3] = runRANSAC(kp_stitched, kp_n, 4000, 3);
%       pts_expected = applyHomography(H, )
        H = computeHomography(kp_stitched(inliers_id, :), kp_n(inliers_id, :));

    dest_canvas_width_height = [size(stitched_img, 2), size(stitched_img, 1)];
    [mask, dest_img] = backwardWarpImg(ref_img, inv(H_3x3), dest_canvas_width_height);

    % Superimposement 
    bin = zeros(size(stitched_img, 1), size(stitched_img, 2), 3);
    bin(:, 1:end, :) = stitched_img;
    bin_mask = zeros(size(stitched_img, 1), size(stitched_img, 2));
    bin_mask(:, 1:end) = ones(size(stitched_img, 1), size(stitched_img, 2));

    stitched_img = blendImagePair(dest_img, mask, bin, bin_mask,'blend');

        % ---------------------------------------
        % END ADD YOUR CODE HERE
        % ---------------------------------------
    end
    
    % OPTIONAL: remove excess padding from the output
     stitched_img = bbox_crop(stitched_img);
end