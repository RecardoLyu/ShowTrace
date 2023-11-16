function data = XxReadTiffSmallerThan4GB(TiffPath)

pic_info = imfinfo(TiffPath);
% disp(size(pic_info))
[frame_CCD,~] = size(pic_info);
% disp(['frame_CCD=',num2str(frame_CCD)])
row_CCD = pic_info.Height;
colum_CCD = pic_info.Width;

data = zeros(row_CCD,colum_CCD,frame_CCD);
for frame_temp = 1:frame_CCD
    img_temp = imread(TiffPath,'Index',frame_temp);
    % disp(size(img_temp))
    data(:,:,frame_temp) = img_temp(:,:,1);
end
% data = double(data);

end