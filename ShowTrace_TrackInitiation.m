%% merge the track data
% track_data_path = 'D:\My_WorkSpace\ShowTrace\Data\after\'
% track_data_List  = dir(fullfile(track_data_path, '*.csv'));
% track_data_file_names = {track_data_List.name}';
% % track_data = cell(size(track_data_file_names));
% track_data = [];
% for i = 1 : size(track_data_file_names, 1)
% track_data = [track_data; readmatrix([track_data_path,track_data_file_names{i}])];
% end
% save([track_data_path,'track_data.mat'],"track_data",'-mat')
% clc;
% clear;
% fclose all;
fprintf('TrackInitiation...\n')
Track_data = load(TrackPath,'-mat').track_data;
%% define the colormat of the trace
maxTrackSpots = 113;
maxColorNum = maxTrackSpots * 3;
ColorMap = jet(round(maxColorNum*1.3));
% to avoid the overlap of blackground and dark lines
ColorMap = ColorMap(round(maxColorNum*0.15)+1:round(maxColorNum*0.15)+maxColorNum,:);
%% data
idx = cell(1,113);
data_draw = cell(1, maxTrackSpots);
num_spots = cell(maxTrackSpots,2);
for i = 1: 113
    idx{i} = find(Track_data(:,2) <= i);
    % rearrange the data,the i is the idx of spot
    data_draw{i} = Track_data(Track_data(:, 2) <= i, 1:4 );
    % in num_spots we save the number of points and the number of traces
    num_spots{i, 2} = unique(data_draw{i}(:,1));
    num_spots{i, 1} = size(data_draw{i}, 1);
end
clear Track_data
fprintf('Finish\n')
%% function test
