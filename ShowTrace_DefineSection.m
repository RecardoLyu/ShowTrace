%% Define the effects and parameters of each section
% V0.0 Yunhui Lv, developed on QC's work, 10/27/2023
% v3.6, add Section 3
% v3.7, update Zoom in
fprintf('DefineSection...\n')

%% ROI
ROI4Zoom_in = [201    91   % 左上
               600   490]; % 右下
ROI4Activation = [231   281
                  490   450];

%% Section 1: before activation
first_frame_stop = 1;
file_need{1} = [1];% the idx of file needed
frame_raw_begin{1} = 1;
frame_raw_end{1} = 1;%原始数据是那几张？
frame_showfig_amount{1} = 2*fps; %对应要产生多少张图，比上面的张数多的话，会自动匹配
section_char{1} = [1 1 frame_showfig_amount{1}];%%第一段展示那几个字符,字符在后面几行123，每一行是一种，每一行的后两个数字是这个文字出现在fig多少张
crop_info_temp{1} = [526 526 1052 1052];%行表示保持这个crop状态，两行为首位中间状态自动插值。side模式：直接从image-J读的四个参数(起始列，起始行，总列数，总行数)
length{1}(1:frame_showfig_amount{1}+1e2,1) = 3000;%scale_bar长度nm

%% Section 3: Show activation ROI and Zoom in
file_need{3} = [2];% the idx of file needed
frame_raw_begin{3} = 1;
frame_raw_end{3} = 1;
frame_showfig_amount{3} = 3*fps; %对应要产生多少张图，比上面的张数多的话，会自动匹配
section_char{3} = [3 1 frame_showfig_amount{3}];%%第一段展示那几个字符,字符在后面几行123，每一行是一种，每一行的后两个数字是这个文字出现在fig多少张
crop_info_temp{3} = [526 526 1052 1052;
                    round(mean(ROI4Zoom_in, 1)),round(ROI4Zoom_in(2,:)-ROI4Zoom_in(1,:)+1)];%行表示保持这个crop状态，两行为首位中间状态自动插值。side模式：直接从image-J读的四个参数(起始列，起始行，总列数，总行数)
length{3}(1:frame_showfig_amount{1}+1e2,1) = 3000;%scale_bar长度nm

%% Section 2: after activation
file_need{2} = [2];% the idx of file needed
% raw frame range
frame_raw_begin{2} = 1;
frame_raw_end{2} = 113;
frame_showfig_amount{2} = 3*(frame_raw_end{2} - frame_raw_begin{2} + 1);
section_char{2} = [2 1 frame_showfig_amount{2}];
crop_info_temp{2} = [526 526 1052 1052];%行表示保持这个crop状态，两行为首位中间状态自动插值。side模式：直接从image-J读的四个参数(起始列，起始行，总列数，总行数)
length{2}(1:frame_showfig_amount{1}+1e3,1) = 3000;%scale_bar长度nm
CTG = round(mean(ROI4Activation, 1) - ROI4Zoom_in(1,:));
CTG(1) = CTG(1)-80;
CTG(2) = CTG(2)+30;
mask_gaussian = my_Gaussian2D(ROI4Zoom_in(2,:)-ROI4Zoom_in(1,:)+1,CTG,attenuation_rate);
fprintf('Finish\n')