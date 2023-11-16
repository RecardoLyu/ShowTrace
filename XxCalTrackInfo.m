function [TrackInfo, TrackTrace] = XxCalTrackInfo(TrackData, dxy, scale)

nTracks = size(TrackData,2);
TrackInfo = zeros(nTracks,2); % 记录每个track的spot数量和绘制的轨迹点总数
TrackTrace = cell(nTracks, 1); % 记录每个track的轨迹点
for i = 1:nTracks
    Track = TrackData{i};
    nSpots = size(Track,1);
    TrackInfo(i,1) = nSpots;
    totalpoint = 0;
    for j = 1:nSpots-1
        curSpot = fix([Track(j,2) Track(j,3)] / dxy * scale);
        nextSpot = fix([Track(j+1,2) Track(j+1,3)] / dxy * scale);
        dist = sqrt(sum((curSpot-nextSpot).^2));
        numpoint = round(dist*2);
        if numpoint == 0
            numpoint = 2;
            xx = fix(linspace(curSpot(1),nextSpot(1),numpoint));
            yy = fix(linspace(curSpot(2),nextSpot(2),numpoint));
            point = [xx' yy'];
            totalpoint = totalpoint + size(point,1) - 1;
            pointcell = cell(1,1);
            pointcell{1} = point;
            TrackTrace{i} = [TrackTrace{i},pointcell];
        else
            xx = fix(linspace(curSpot(1),nextSpot(1),numpoint));
            yy = fix(linspace(curSpot(2),nextSpot(2),numpoint));
            point = [xx' yy'];
            point = unique(point, 'rows', 'stable');
            totalpoint = totalpoint + size(point,1) - 1;
            pointcell = cell(1,1);
            pointcell{1} = point;
            TrackTrace{i} = [TrackTrace{i},pointcell];
        end
    end
    TrackInfo(i,2) = totalpoint;
end

end