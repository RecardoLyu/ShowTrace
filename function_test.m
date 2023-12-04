
%% load data and set ROI
clear
data = XxReadTiffSmallerThan4GB('D:\My_WorkSpace\ShowTrace\data\after\C3-488-560-after-cycletime60s_Red_channel_560nm_0_Fig.4b-after_deconv.tif');
ROI4Zoom_in = [191    91   % 左上
               600   500]; % 右下
data = data(:,:,1:3:337);
%% get the first frame
for save_idx = [103 104 107 111]
close all
raw_image = data(:,:,save_idx);
m = min(min(raw_image))
M = max(max(raw_image))
double_image = imgintensity_cut(raw_image,m,M,1,1);
img_show = fix(double_image * 255);
figure(1),subplot(1,3,1),imshow(uint8(img_show),[],'Border','tight','InitialMagnification',100)
[A, B] = get_boundary(double_image, ROI4Zoom_in, save_idx);
subplot(1,3,2), imshow(A,[],'Border','tight','InitialMagnification',100);
subplot(1,3,3), imshow(B,[],'Border','tight','InitialMagnification',100);
pause(5)
end

