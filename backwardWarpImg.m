function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
                                              dest_canvas_width_height)
	src_height = size(src_img, 1);
	src_width = size(src_img, 2);
    src_channels = size(src_img, 3);
    [H, W, P] = size(src_img);
    dest_width = dest_canvas_width_height(1);
	dest_height	= dest_canvas_width_height(2);
    
    result_img = zeros(dest_height, dest_width, src_channels);
    mask = false(dest_height, dest_width);
    
    % this is the overall region covered by result_img
    [dest_X, dest_Y] = meshgrid(1:dest_width, 1:dest_height);
    
    % map result_img region to src_img coordinate system using the given
    % homography.
    src_pts = applyHomography(resultToSrc_H, [dest_X(:), dest_Y(:)]);
    src_X = reshape(src_pts(:,1), dest_height, dest_width);
    src_Y = reshape(src_pts(:,2), dest_height, dest_width);
    
    % ---------------------------
    % START ADDING YOUR CODE HERE
    % ---------------------------
    
    dest_pts = [dest_Y, dest_X];

% getPointsFromUser(img, npts, message)    

    dest_pts_nx2 = reshape(dest_pts, [], 2);
%     disp(size(dest_pts_nx2));
%     disp(size(src_pts));
    src_to_dest_homography = computeHomography(src_pts, dest_pts_nx2);
    dest_to_src_homography = computeHomography(dest_pts_nx2, src_pts);

     dest_to_H = resultToSrc_H * dest_to_src_homography;
%     disp(src_to_dest_homography);
%      disp(dest_to_src_homography);
%      disp(size(dest_to_H));
%     disp(size(src_channels));
%     disp(size(src_img));

%     disp(dest_height);
%     disp(dest_width);

% Turn matrix into a 3xn matrix for calculations

  
%     dest_matrix = zeros(dest_canvas_width_height(2),dest_canvas_width_height(1),3);
%     dest_matrix(:,:,1) = dest_X;
%     dest_matrix(:,:,2) = dest_Y;
%     dest_matrix(:,:,3) = 1;

%     dest_matrix = [dest_X, dest_Y, 1];
    %Reshape from 460, 640, 3 to 3xn matrix
%     disp(size(dest_matrix));
%     dest_matrix = reshape(dest_matrix,[dest_canvas_width_height(1) ...
%         .* dest_canvas_width_height(2), 3])';
% 
%     disp(size(dest_matrix));
% 
% %     disp(Vq);
%     disp(size(Vq));

    
%     src_x = Vq(1,:);
%     src_y = Vq(:,2);
%     disp(size(src_x));
%     disp(size(src_y));
%     disp(size(dest_Y));
%     disp(size(resultToSrc_H));

%     result = resultToSrc_H * dest_matrix;
% 
% 
% 
%     src_matrix = [result(2,:) ./ result(3,:); result(1,:) ./ result(3,:),]';
%     src_matrix = reshape(round(src_matrix), [dest_canvas_width_height(2), dest_canvas_width_height(1),2]);
%     src_matrix(:,:,3) =1;
%     
%     disp(size(src_img));
% 
%     disp(size(src_matrix));
%         disp(size(result_img));
%     
    [sx, sy] = getPointsFromUser(src_img, 4, 'get corners');
    
%     disp(size(sx));
%     disp(size(sy));
%     disp(size(src_img));

    V = peaks(dest_X, dest_Y);

%     interpR = interp2(src_img(:, :, 1), sx, sy);
%     interpG = interp2(src_img(:, :, 2), sx, sy);
%     interpB = interp2(src_img(:, :, 3), sx, sy);

    src_matrix = [src_Y;src_X];
    src_matrix = reshape(round(src_matrix), [dest_canvas_width_height(2), dest_canvas_width_height(1),2]);

%     Vq = interp2(V, sx, sy);
%     disp(size([src_X;src_Y]));
%     disp(dest_height);
%     disp(dest_width);
% 
%     disp(src_width);
%     disp(src_height);
%      disp(size(src_matrix));
%      disp(size(result_img));


%     disp(size(Vq));
%     disp(Vq);

%   disp(size(interpR));
%      disp(size(interpG));
%        disp(size(interpB));
%      disp(interpR(1));
%           disp(interpR(4));

       dx = [];
       dy = [];



     count = 1;
    for i=1:dest_width
        for j=1:dest_height
            x = src_pts(count, 1);
            y = src_pts(count, 2);
%             if 1 < y && y < H && 1 < x && x < W
            if (src_matrix(j, i) > 0 && j < src_height && j > 0 && i < src_width && i > 0) &&...
                (1 < y && y < H && 1 < x && x < W)
                mask(j, i) = 1;

                if count == 1
                    dx = [transpose(sx),x];
                    dy = [transpose(sy), y];
                end

                dx = [dx,x];
                dy = [dy,y];
            end
          count = count + 1;

        end
    end

    interpR = interp2(src_img(:, :, 1), dx, dy);
    interpG = interp2(src_img(:, :, 2), dx, dy);
    interpB = interp2(src_img(:, :, 3), dx, dy);
     
    
%       disp(size(interpR));
%      disp(size(interpG));
%        disp(size(interpB));
%      disp(interpR(1));
%           disp(interpR(4));
    count = 1;
    for i=1:dest_width
        for j=1:dest_height

         
%      if src_matrix(i, j) > 0 && i <= src_height && i > 0 && j <= src_width && j > 0
%                mask(i,j) = 1;
%            end    
%         and if its indices i and j are within the src_width/src_height values, 
% and if so setting the mask(i, j) to 1

            if mask(j, i) == 1
                result_img(j, i, 1) = interpR(count);
                result_img(j, i, 2) = interpG(count);
                result_img(j, i, 3) = interpB(count);
                count = count + 1;
            end     
        end
    end

    result_img(isnan(result_img)) = 0;
% 
%     mask = ~isnan(result_img(:,:,1));
    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------
end