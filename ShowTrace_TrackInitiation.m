%% merge the track data
% v3.4, adjust the width of trace
% v3.5, adjust the colormap
% v5,5, 
fprintf('TrackInitiation...\n')
Track_data = load(TrackPath,'-mat').track_data;
% Track_data = adjust_trace_width(Track_data(:,1:4));

%% define the colormat of the trace
maxTrackSpots = 47;
maxColorNum = maxTrackSpots;
ColorMap = jet(round(maxColorNum*1.8));
% to avoid the overlap of blackground and dark lines
ColorMap = ColorMap(round(maxColorNum*0.4)+1:round(maxColorNum*0.4)+maxColorNum,:);
%% data: 最终的数据结构是一个113*4的cell，其中每一行是一个插值之后产生的连续轨迹的数组
idx = cell(1,maxTrackSpots);
data_draw = cell(maxTrackSpots,1);
num_spots = cell(maxTrackSpots,1);
for i = 1: maxTrackSpots
    idx{i} = find(Track_data(:,2) <= i);
    % rearrange the data,the i is the idx of spot
    data_draw_all = Track_data(Track_data(:, 2) <= i, 1:4 );
    % reorder the trace data into m*n*4, in which m is for the number of traces
    spot_draw = unique(data_draw_all(:,1));
    data_draw{i} = cell(size(spot_draw, 1), 1);
    for spot_idx = 1:size(spot_draw, 1)
        data_draw{i}{spot_idx} = data_draw_all(data_draw_all(:,1) == spot_draw(spot_idx), 1:4);

        n_Spots = size(data_draw{i}{spot_idx},1);
        totalpoint = 0;
        if n_Spots > 1
            for j = 1:n_Spots-1
                curSpot = data_draw{i}{spot_idx}(j,:);
                nextSpot = data_draw{i}{spot_idx}(j+1,:);
                dist = sqrt(sum((curSpot-nextSpot).^2));
                numpoint = round(dist*2);
                if numpoint == 0
                    numpoint = 2;
                    ss = fix(linspace(curSpot(1), nextSpot(1), numpoint));
                    tt = fix(linspace(curSpot(2), nextSpot(2), numpoint));
                    xx = fix(linspace(curSpot(3), nextSpot(3), numpoint));
                    yy = fix(linspace(curSpot(4), nextSpot(4), numpoint));
                    point = [ss' tt' xx' yy'];
                    totalpoint = totalpoint + size(point,1) - 1;
                    data_draw{i}{spot_idx} = [data_draw{i}{spot_idx}(:,:);point];
                else
                    ss = fix(linspace(curSpot(1), nextSpot(1), numpoint));
                    tt = fix(linspace(curSpot(2), nextSpot(2), numpoint));
                    xx = fix(linspace(curSpot(3), nextSpot(3), numpoint));
                    yy = fix(linspace(curSpot(4), nextSpot(4), numpoint));
                    point = [ss' tt' xx' yy'];
                    point = unique(point, 'rows', 'stable');
                    totalpoint = totalpoint + size(point,1) - 1;
                    data_draw{i}{spot_idx} = [data_draw{i}{spot_idx}(:,:);point];
                end
            end
        end
    end
    data_draw{i} = cell2mat(data_draw{i});
    num_spots{i} = size(data_draw{i}, 1);
end
% clear Track_data
fprintf('Finish\n')
%% function test
