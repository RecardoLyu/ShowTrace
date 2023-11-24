function [boundary, temp] = get_boundary(img_input, ROI)
%GET_BOUNDARY , Yunhui Lyu, 2023/11/24, detect the boundary of input image,
% then postprocess, ouput a binary image having the same size as raw image.
% img_input: 输入图像，
% ROI: 左上角和右下角坐标
% v1.0, 发现全局方法简单粗暴效果好，别乱试其他方法了

% boundary = zeros(size(img_input));
%% Binarize the image
boundary = imbinarize(img_input,"global");
% disp(["Area of Frontground:", num2str(bwarea(boundary))])

%% BW image morphological operation
% temp = bwmorph(boundary, "close", Inf);
SE = strel("disk", 13);
temp = imclose(boundary, SE);
SE = strel("disk",6);
temp = imopen(temp, SE);
temp = bwmorph(temp, "fill",Inf);
%% Create a mask
mask = zeros(size(img_input));
mask(ROI(1,2):ROI(2,2),ROI(1,1):ROI(2,1)) = 1;
mask = logical(mask);
imwrite(mask, "./resource/mask.png")
% temp = temp.*mask;

%% Edge detection
% boundary = bwmorph(temp,"skeleton", Inf);
boundary = temp;
boundary = ~boundary;
boundary = ~bwareaopen(boundary, 50000,8);
SE = strel("disk",2);
temp_in = imerode(boundary,SE);
boundary = boundary - temp_in;
imwrite(boundary,"./resource/boundary.png")
end

