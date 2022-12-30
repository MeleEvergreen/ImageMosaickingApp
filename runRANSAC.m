function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
%RUNRANSAC
    num_pts = size(Xs, 1);
    pts_id = 1:num_pts;
    inliers_id = [];
    [nums, ~] = size(Xs);
%     [src_pts, dest_pts] = getSIFTMatches(Xs, Xd);
max = 0;
% disp(eps);
%     disp(ransac_n);
%     src_pts = applyHomography(resultToSrc_H, [dest_X(:), dest_Y(:)]);
% get src_img and dest_img and run on SIFT
    for iter = 1:ransac_n
        % ---------------------------
        % START ADDING YOUR CODE HERE
        % ---------------------------

%         if 4 > num_pts
%             inds = [num_pts, num_pts, num_pts, num_pts];
%         else
            inds = randperm(num_pts,4);
%         end

%         invalue = reshape(1:ceil(nums/4), [], 4);
%         disp(size(invalue));
%         inds = inds(transpose(invalue));

%         disp(num_pts);
%         inds = inds(1:ceil(num_pts/eps));
%         inds = randi(length(pts_id),1,3);
%         disp(size(src_pts));
%         disp(size(dest_pts));
%         [src_pts, dest_pts] = genSIFTMatches(Xs, Xd);
        H_apply = computeHomography(Xs(inds, :), Xd(inds, :));
        pts_expected = applyHomography(H_apply, Xs);
        difference = (pts_expected - Xd);
        dist = sqrt(sum(difference.*difference, 2));
        placing = find(dist < eps);
%         disp(size(placing));
%         dist = sqrt(sum((pts_expected - Xd).^2));
%         inliers_id = [inliers_id, transpose(placing)];
%         if length(placing) > max
%             max = length(placing);
%             H = H_apply;

%         inliers_2 = [];
%         for k = 1:num_pts
%             if norm(pts_expected(k,:)-Xd(k,:)) < eps
%                 inliers_2 = [inliers_2, placing];
%             end
%         end

%         if length(inliers_2) > length(inliers_id)
%             H = H_apply;
%             inliers_id = inliers_2;
%         end

           norm = sqrt(sum((pts_expected-Xs).^2));
%            disp(norm);
           



           placing_2 = find(norm > eps);

           if length(placing) > max
               max = length(placing);
                inliers_id = [transpose(placing), inliers_id];
                H = H_apply;
           end

%             inliers = [];
%             X_homo = applyHomography(H_apply, Xs);
%             for i = 1:nums
%                 if norm(X_homo(i,:)-Xd(i,:)) < eps
%                     inliers = [new_inliers, i];
%                 end
%             end
%             
%             if length(inliers_id) <= length(inliers)
%                 H = H_apply;
%                 inliers_id = new_inliers;
%             end
%            if mean(norm) < eps
%                 inliers_id = [transpose(placing), inliers_id];
% %                 max = eps;
%                 H = H_apply;
%                 disp("Hi");
% 
%            end
          
        % ---------------------------
        % END ADDING YOUR CODE HERE
        % ---------------------------
    end 

%     inliers_id = inliers_2;
%     inliers_id = transpose(inliers_id);
%     disp(size(inliers_id));
%     disp(size(src_pts));
%     disp(size(dest_pts));
%     disp(size(H));
%     disp(size(Xs));
%     disp(size(Xd));



end
