function [boundary, temp] = get_boundary(img_input, ROI, save_idx)
%GET_BOUNDARY , Yunhui Lyu, 2023/11/24, detect the boundary of input image,
% then postprocess, ouput a binary image having the same size as raw image.
% img_input: 输入图像，
% ROI: 左上角和右下角坐标
% v1.0, 发现全局方法简单粗暴效果好，别乱试其他方法了
% v1.1, 添加了高斯滤波对图像进行平滑，并且对于一些图像加入了OTSU阈值法计算的二值化阈值
% v1.2, 需要对二值化图像进行腐蚀，二值化前景大了一圈，考虑只取最大连通域
% boundary = zeros(size(img_input));
%% Gaussian filter process
W = fspecial('gaussian', [6, 6], 65);
img_gaussian = imfilter(img_input, W, 'replicate');

%% Binarize the image
if save_idx ~= [103 104 107 111] % global function is invalid for these pictures 
    boundary = imbinarize(img_gaussian,"global");
    % disp(["Area of Frontground:", num2str(bwarea(boundary))])
else
    level = graythresh(img_gaussian);
    boundary = imbinarize(img_gaussian,level);
end
%% BW image morphological operation
% temp = bwmorph(boundary, "close", Inf);
SE = strel("disk", 13);
temp = imclose(boundary, SE);
SE = strel("disk",6);
temp = imopen(temp, SE);
temp = bwmorph(temp, "fill",Inf);
temp = imerode(temp,SE);
SE = strel("disk",3);
temp = imopen(temp, SE);
%% Create a mask
mask = zeros(size(img_input));
mask(ROI(1,2):ROI(2,2),ROI(1,1):ROI(2,1)) = 1;
mask = logical(mask);
imwrite(mask, ['./resource/mask.png'])
% temp = temp.*mask;

%% Edge detection
% boundary = bwmorph(temp,"skeleton", Inf);
boundary = temp;
boundary = ~boundary;
boundary = ~bwareaopen(boundary, 50000,8);
SE = strel("disk",2);
temp_in = imerode(boundary,SE);
boundary = boundary - temp_in;
% imwrite(boundary,['./resource/boundary_',num2str(save_idx),'.png'])
end

