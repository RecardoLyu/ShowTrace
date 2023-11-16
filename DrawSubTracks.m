clc, clear;

%% 读取数据
imgFile = 'E:\2D_long\FigData\Clathrin\3Power\3Power_cell12\Select_Final\ShowFrame\Frame18_GT.tif';
trackFile = 'E:\2D_long\FigData\Clathrin\3Power\3Power_cell12\Select_Final\c12_GT_ManualTracks.mat';
% imgFile = 'E:\2D_long\FigData\Clathrin\3Power\3Power_cell12\Select_Final\ShowFrame\Frame18_rDL.tif';
% trackFile = 'E:\2D_long\FigData\Clathrin\3Power\3Power_cell12\Select_Final\c12_MYPRCAN_High_ManualTracks.mat';
% imgFile = 'E:\2D_long\FigData\Clathrin\3Power\3Power_cell12\Select_Final\ShowFrame\Frame18_HS.tif';
% trackFile = 'E:\2D_long\FigData\Clathrin\3Power\3Power_cell12\Select_Final\c12_HS_High_ManualTracks.mat';
img = imread(imgFile);
load(trackFile);
tracks = result;

%% 绘制轨迹

tracks = tracks([1,3]);
nTracks = size(tracks,2);
dxy = 0.0313;
scale = 8;
Rect1 = [122,207,71,101] * scale;
Rect2 = [131,216,236,266] * scale;

TrackBeginID = 18;
for i = 1:nTracks
    tracks{i} = tracks{i}(TrackBeginID:end,:);
    tracks{i}(:,1) = tracks{i}(:,1) - tracks{i}(1,1) + 1;
end
[TrackInfo, TrackTrace] = XxCalTrackInfo(tracks, dxy, scale);
colordata = repmat(imresize(XxNorm(img),scale,'nearest'), 1,1,3);

maxTrackSpots = max(TrackInfo(:,1));
maxcolornum = maxTrackSpots * 20;
colormap = jet(round(maxcolornum*1.3));
colormap = colormap(round(maxcolornum*0.15)+1:round(maxcolornum*0.15)+maxcolornum,:);



for i = 1:nTracks
    nSpots = TrackInfo(i,1);
    Track = tracks{i};
    curSpot = 0;
    for j = 1:nSpots-1
        fprintf('Draw spots No. %d/%d\n',j,nSpots-1);
        curtrace = TrackTrace{i}{j};
        l_curtrace = size(curtrace,1);
        colorstart = round(curSpot / maxTrackSpots * maxcolornum) + 1;
        curSpot = curSpot + 1;
        colorend = round(curSpot / maxTrackSpots * maxcolornum) +1;
        curcolormap = colormap(ceil(linspace(colorstart,colorend,l_curtrace)),:);
        for k = 1:l_curtrace-1
%             curx = curtrace(k,1);
%             cury = curtrace(k,2);
%             colordata(cury,curx,:) = curcolormap(k,:);
            curP = [curtrace(k,1) curtrace(k,2)];
            nextP = [curtrace(k+1,1) curtrace(k+1,2)];
            colordata = insertShape(colordata, 'Line', [curP nextP], 'Color', curcolormap(k,:), 'LineWidth', 2);
        end
    end
end


CropArea1 = colordata(Rect1(1):Rect1(2),Rect1(3):Rect1(4),:);
CropArea2 = colordata(Rect2(1):Rect2(2),Rect2(3):Rect2(4),:);

% figure(1);
% imshow(colordata,[]);
% figure(2);
% subplot(1,2,1), imshow(CropArea1,[]);
% subplot(1,2,2), imshow(CropArea2,[]);

SaveFile1 = [imgFile(1:end-4) '_Crop1.tif'];
SaveFile2 = [imgFile(1:end-4) '_Crop2.tif'];
imwrite(CropArea1, SaveFile1);
imwrite(CropArea2, SaveFile2);



