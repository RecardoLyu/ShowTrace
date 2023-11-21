%% Define the charactors in the Video
% v0.0 Yunhui Lv, developed on QC's work, 10/27/2023
% v3.3, upgrade the Chars
% v3.6, add Section 3
fprintf('DefineChar\n')
TotalFrame = 0;
for i = 1:size(frame_showfig_amount,2)
    TotalFrame = TotalFrame + frame_showfig_amount{i};
end
Font_Size_tl(1:TotalFrame)=18;%字体大小
% x grows from left to right, ranging from 0 to 1
% y grows from top to bottom, ranging from 0 to 1
text_left{1}='Before 405nm activation';%不动的Before Activation
tl_scale_x1{1}(1:TotalFrame) = 0.5;%x的1 表示最右边
tl_scale_x2{1}(1:TotalFrame) = 0.5;
tl_scale_y{1}(1:TotalFrame) = 0.05;%y的1 表示最下边
tl_color{1}=[255 255 255]/255;%紫色[255,0,255]；绿色[0,255,0]；灰色[255,255,255]

text_left{2}='After 405nm activation';%播放的After Activation
tl_scale_x1{2}(1:TotalFrame) = 0.5;
tl_scale_x2{2}(1:TotalFrame) = 0.5;
tl_scale_y{2}(1:TotalFrame) = 0.05;%第2段文字的坐标
tl_color{2}=[255,255,255]/255;%紫色[255,0,255]；绿色[0,255,0]；灰色[255,255,255]


text_left{3} = "ROI of 405nm activation"; % 固定播放2s的激发区域然后Zoom in到ROI
tl_scale_x1{3}(1:TotalFrame) = 0.5;
tl_scale_x2{3}(1:TotalFrame) = 0.5;
tl_scale_y{3}(1:TotalFrame) = 0.05;%第3段文字的坐标
tl_color{3}=[255,255,255]/255;%紫色[255,0,255]；绿色[0,255,0]；灰色[255,255,255]

% ---------------------------------------------
%                     时间参数
% ---------------------------------------------
frame_speed(1) = [1/7];%拍摄速度fps，2scyc=0.5fps，不管
frame_start = 0;%起始张数是0还是1，不管

frame_real(1:TotalFrame,1) = frame_start:1:(frame_start+TotalFrame-1);%真实的帧数，不管

tp_scale_x(1:TotalFrame)=0.01;%x的1 表示最右边
tp_scale_y(1:TotalFrame)=0.06;%y的1 表示最下边

Font_Size_time(1:TotalFrame)=16;%字符大小
Font_name='SansSerif';%字体，不管

% ---------------------------------------------
%                scalebar相关
% ---------------------------------------------
x_scale(1:TotalFrame) = 0.93;%[0~1] in real image, Far left is 0 default 0.903
y_scale(1:TotalFrame) = 0.93;%[0~1] in real image, uppermost is 0 default 0.95

LineWidth(1:TotalFrame,1) = 3;%线宽，单位pixel
pd_raw = 92.6 * 2/3;%
Font_Size_Sb(1:TotalFrame,1) = 16;%字体大小
x_scale_offset(1) = 0;%，不管
x_scale_offset(5) = 0.005;%，不管
bar_color = 'w';%，不管
text_visible = 'down';%'off'= non text,'up' = show up,'down' = show down ，不管
text_offset = 25;%文字跟bar间隔多远

% ---------------------------------------------
%                colorbar相关
% ---------------------------------------------
ColorBar_width = 40; %colorbar的宽度
ColorBar_height = 350; %colorbar的高度
ColorBar_dispx = 30; %colorbar与底角的距离
ColorBar_dispy = 50; %colorbar与底角的距离

text_cb_fontsize = 17;

text_cb = cell(1,2);
text_cb_x = zeros(1,2);
text_cb_y = zeros(1,2);

text_cb{1} = '113';%colorbar 上限
text_cb_x(1) = 0.95;
text_cb_y(1) = 0.603;

text_cb{2} = '0';%colorbar 下限
text_cb_x(2) = 0.95;
text_cb_y(2) = 0.972;

% ROI
ROI4Zoom_in = [212    91
               604   458];
ROI4Activation = [227   283
                  491   451];

fprintf('Finish\n')
