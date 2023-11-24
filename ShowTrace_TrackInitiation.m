%% merge the track data
% v3.4, adjust the width of trace
% v3.5, adjust the colormap
fprintf('TrackInitiation...\n')
Track_data = load(TrackPath,'-mat').track_data;
% Track_data = adjust_trace_width(Track_data(:,1:4));

%% define the colormat of the trace
maxTrackSpots = 113;
maxColorNum = maxTrackSpots*20;
ColorMap = jet(round(maxColorNum*1.8));
% to avoid the overlap of blackground and dark lines
ColorMap = ColorMap(round(maxColorNum*0.4)+1:round(maxColorNum*0.4)+maxColorNum,:);
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
