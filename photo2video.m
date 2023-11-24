%% 把 new_main_dir 中存好的图片制作成视频

video_name = ['.\resource\Movie-v4.3-section-' replace(num2str(section_all),'  ','-') '.mp4'];

animation = VideoWriter(video_name,'MPEG-4');%待合成的视频的文件路径
%%%%%%%%%%%%%%%%%%%%
% 使用VideoWriter建立视频对象 animation，并设置相关参数（例如帧率等）
animation.FrameRate = 20;
animation.Quality = 100;


%%%%%%%%%%%%%%%%%%%%
open(animation);
image_files = dir([DataPath,'frame_save\*.jpg']);
len = size(image_files,1);
image_name = cell(len,1);
folder_img = cell(len,1);
for i=1:len
    image_name{i} = image_files(i).name;
    folder_img{i} = image_files(i).folder;
    %使用imread 读取视频帧图片，并使用writeVideo函数制作成视频
    %%%%%%%%%%%%%%%%%
    A = imread([folder_img{i},'\', image_name{i}]);
    writeVideo(animation, A);
    %%%%%%%%%%%%%%%%%
end
close(animation);