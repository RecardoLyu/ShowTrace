function save_tiff(frame_save,file_output)
[Nx,Ny,~,~]=size(frame_save);
tif_info_struct.ImageLength=Nx; %y dim
tif_info_struct.ImageWidth=Ny;  %x dim
tif_info_struct.Photometric=Tiff.Photometric.RGB;
tif_info_struct.BitsPerSample=8;%8
tif_info_struct.SamplesPerPixel=3;%3
tif_info_struct.SampleFormat=Tiff.SampleFormat.UInt;
tif_info_struct.PlanarConfiguration=Tiff.PlanarConfiguration.Chunky;
tif_info_struct.Software = 'Matlab2023b';
tif_info_struct.Compression=Tiff.Compression.None;
tif_info_temp=Tiff(file_output,'w8');
tif_info_temp.setTag(tif_info_struct);% 赋值头文件
tif_info_temp.write(frame_save);
tif_info_temp.close;
end

