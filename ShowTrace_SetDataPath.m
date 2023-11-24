%% SetDataPath
% v0.0 Yunhui Lyu, developed on QC's work, 10/27/2023
fprintf('SetDataPath...\n')
DataPath = 'D:\My_WorkSpace\ShowTrace\Data\';
file_output=[DataPath '\Movie-section-' replace(num2str(section_all),'  ','-') '.tif'];

gamma = zeros(2,1);
filePath{1} = [DataPath 'before\C3-488-560-before_Green_channel_488nm_0_deconv.tif'];
% filePath{1} = [DataPath 'before\C3-488-560-before_Red_channel_560nm_0_Fig.4b-before_deconv.tif'];
inten_min{1}(1:2100) = 0;
inten_max{1}(1:2100) = 5638;
gamma(1) = 1;
RGB{1} = [1,1,1];%颜色

filePath{2} = [DataPath 'after\C3-488-Hyperstack_Fig.4b-after_deconv.tif'];

%filePath{2} = [DataPath 'after\C3-488-Hyperstack_Fig.4b-after_deconv_maxmerge.tif'];
inten_min{2}(1:2100) = 0;
inten_max{2}(1:2100) = 65535;
gamma(2) = 1;
RGB{2} = [1,1,1];%颜色


filePath{3} = [DataPath 'after\C3-488-560-after-cycletime60s_Red_channel_560nm_0_Fig.4b-after_deconv.tif'];

%filePath{2} = [DataPath 'after\C3-488-Hyperstack_Fig.4b-after_deconv_maxmerge.tif'];
inten_min{3}(1:2100) = 138;
inten_max{3}(1:2100) = 7829;
gamma(3) = 1;
RGB{3} = [1,1,1];%颜色

%% track data file path
TrackPath = [DataPath 'after\track_data.mat'];
label = {'SpotID','Timepoints','X','Y','Distance','Velocity','Pixel Value'};
fprintf('Finish\n')