For academic integery purposes:
Over the course of this, I used a bunch of outside material
to assist in my learning. 
It includes matlab sites/forums, method explanations,
concept explantions, etc. 
I do not have all the links on hand as there was too many
But I did want to include this for the purposes of
acknowledging this fact

BackwardWarpImg.m
calculate the dest_pts
rehape it to be an nx2 matrix
calculate the src_to_dest homography
calculate the dest_to_src homography
calculate the dest_to_H by multiplying the 
	resultToSrc_H by the dest_to_src homography
get the points from the user using the 
	getPointsFromUser method and let that be sx and sy
calculate the peaks from dest using peaks
Create a src_matrix from src_X and src_Y
reshape it to fit the dest canvas
create a matrix of dx and dy
create a count variable
loop through size dest_width and dest_height
get the src_pts and allocate them to x and y
see if the values at src_matrix are within the boundries
	of src_height and src_width
if so, assign binary mask == 1 at i,j
if count == 1, then first allocate dx and dy to 
	the transpose sx and sy and x and y
else, continue adding on to dx and dy

Allocate the RGB of the images using interp2, src_img
	dx and dy

loop through size dest_width and dest_height
	if masks == 1
	set the RGB to result image respectively and independently

runRANSAC.m
set the indices variable to randperm of num_pts and of 4 instances
compute the homogrpahy using the given Xs and Xd
compute the expected points
compute the difference
compute the ecludian distance using the geometric difference
calculate the placing of the points using the find method
	in MATLAB
if the length of placing is greate that max -- which is
	initliazed to 1 -- then we update max to current length of placing
	add transpose placing to inliers_id
	update H to the computed homography of that iteration


blendImagePair.m
Create amplifiers of masks through im2single using the given
	masks and maskd
Calculate bitwise differences
compute the ecluidain distance
	Either do this manually or using bwdist
Use either on to calcalaure masks_2 and maskd_2
	The formula for this is given
	(max(bwdist) - bwdist) ./ max(bwdist) .* binary_mask) + single(mask)
Now store this information in the RGB channels of the images by
	using a bitwise operation
	The formula for this is given -- use mask 2
	(wrapped_img .* masks + wrapped_img .* maskd) ./ (masks + maskd)
Lastly, we assign the channel out
	out_img(:,:,c) = channel_out;

stitchImg.m
run runRANSAC on kp_stitiched, kp_n using a ransac_n and eps
	of your choice
compute the homography
get the dest_canvas_width_height using the given stitched_img
create a mask and dest_img using backwardWarpImg
Superimpose the images by creating a zeros matrix of the stitiched images
	Then do the same same but with ones
	Next call the blendImagePair to do blend the image
	Save this as the new stitched_img
Do the optional section to remove excess padding from output

challenge1e
Do the same methods for challenge1d, but 
	using the image of your choice