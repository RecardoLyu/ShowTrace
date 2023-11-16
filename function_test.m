%% clear
clear;clc;
close all;
fclose all;

% NAME = 'NAME';
% path =[pwd, '\',NAME,'\'];%注意文件夹路径的选取，注意该文件夹下需要大量图片，以方便做成动画效果
% %pwd代表当前路径
% dir1 = dir(fullfile(path,'*.tiff'));%如果是别的格式，把这里的tiff改掉。
% fmat=moviein(length(dir1));%动画帧数
%
% for i = 1:length(dir1)
%     img = imread([path dir1(i).name]);
%     %img = rgb2gray(img);
%     imshow(img);title(dir1(i).name);
%     fmat(:,i)=getframe;
%     if i==length(dir1)%第一张图可能出现cdata与其他图像纬度不一致的问题（因为图像太大），此处统一大小。
%         img=imread([path dir1(1).name]);
%         imshow(img);
%         fmat(:,1)=getframe;
%     end
% end
% movie(fmat,1,1);
% %生成视频的参数设定
%  NAME_avi=VideoWriter([NAME,'.avi']);%avi名称
%  NAME_avi.FrameRate=0.75;%播放速度
%  open(NAME_avi);
%  writeVideo(NAME_avi,fmat);
%  close(NAME_avi)
%
% %}
%% merge the track data
track_data_path = 'D:\My_WorkSpace\ShowTrace\Data\after\'
track_data_List  = dir(fullfile(track_data_path, '*.csv'));
track_data_file_names = {track_data_List.name}';
% track_data = cell(size(track_data_file_names));
track_data = [];
for i = 1 : size(track_data_file_names, 1)
track_data = [track_data; readmatrix([track_data_path,track_data_file_names{i}])];
end
save([track_data_path,'track_data.mat'],"track_data",'-mat')
%% load data
DataPath = 'D:\My_WorkSpace\ShowTrace\Data\after\C3-488-Hyperstack_Fig.4b-after_deconv.tif'
file_output = 'D:\My_WorkSpace\ShowTrace\Data\after\C3-488-Hyperstack_Fig.4b-after_deconv_mean_merged.tif'
data_temp = XxReadTiffSmallerThan4GB(DataPath);
disp(['Size of data=',num2str(size(data_temp))])
data = zeros([size(data_temp,[1 2]) 3 113]);
% size(data)
data(:,:,1,:) = data_temp(:,:,1:3:337);
data(:,:,2,:) = data_temp(:,:,2:3:338);
data(:,:,3,:) = data_temp(:,:,3:3:339);

%% reshape
% 最大值合成
% data_save(:,:,:) = uint16(max(data(),[],3));
% 平均值合成
data_save(:,:,:) = uint16(round(mean(data,3)));
disp(['Size of data=',num2str(size(data_save))])
% tif_temp = Tiff(filePath{i});
% data{i} = tif_temp.read();
%% intensity check
gray_range_statistic = [];

gray_range_statistic = [gray_range_statistic; [reshape(min(min(data(:,:,1,:))),[],1) reshape(max(max(data(:,:,1,:))),[],1)]];

%% save new tif
for frame_idx = 1: 113
    [Nx,Ny,~,~]=size(data_save(:,:,frame_idx));
    tif_info_struct.ImageLength=Nx; %y dim
    tif_info_struct.ImageWidth=Ny;  %x dim
    tif_info_struct.Photometric=Tiff.Photometric.MinIsBlack;
    tif_info_struct.BitsPerSample=16;%8
    tif_info_struct.SamplesPerPixel=1;%3
    tif_info_struct.SampleFormat=Tiff.SampleFormat.UInt;
    tif_info_struct.PlanarConfiguration=Tiff.PlanarConfiguration.Chunky;
    tif_info_struct.Software = 'Matlab2022b';
    %tif_info_struct.Compression=Tiff.Compression.PackBits;
    tif_info_struct.Compression=Tiff.Compression.None;
    if frame_idx==1
        tif_info_temp=Tiff(file_output,'w8');
        tif_info_temp.setTag(tif_info_struct);% 赋值头文件
        tif_info_temp.write(data_save(:,:,frame_idx));
        tif_info_temp.close;
    else
        tif_info_temp=Tiff(file_output,'a');
        tif_info_temp.setTag(tif_info_struct);%赋值头文件
        tif_info_temp.write(data_save(:,:,frame_idx));
        tif_info_temp.close;
    end
    frame_idx
end