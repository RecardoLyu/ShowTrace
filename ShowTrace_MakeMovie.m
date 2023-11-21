%% Make Movie File, run this script to make a movie demo
% v0.0 Yunhui Lyu, developed on QC's work, 10/27/2023.
% v1.0, introduce a adaptive method of the gray degree, to avoid some problems due to different gray degree distribution, 10/31/2023.
% v1.1, modify the grayscale distribution strategy, 1/11/2023.
% v1.2, modify the grayscale distribution strategy, ensuring that the image before activation is darker than it after activation 1/11/2023.
% v2.0, get ROI for the first frame of each section, 2/11/2023.
% v3.0, complete the trace display, 9/11/2023
% v3.1, change the distributed trace point into Cubic spline interpolation locus, 10/11/2023
% v3.2, save JPEG frame directly, to speed up and visualize the result.
% v3.4, adjust the width of trace
% v3.5, change the size of video into 16:9
% v3.6, add Section 3
%% Preparations
close all;
clear, clc;

%% Set some parameters
image_write = 0;%1就保存图像数据
save_size = [1052 1052];% 最终保存的图像大小，wh(xy)，空矩阵就表示原始大小
enlarged_size = [900 1600];
fps = 20;%播放速度
ReloadDataFlag = 1;
first_time = 1;
ifROI = 0;
make_video = 1;
savejpeg = 1;
section_all = [1 3 2];% the demo is divided for 2 sections as below
%1 shows a static image for 40 frames, which is before activation
%2 shows dynamic images for 113 frames, which is after activation
section_cnt = 1;
zoom_times = 1;
CropMode = 'c';%center模式：四个数字，前2定中心坐标，后2定ROI，数字也是image-J读取

%% Run these scripts to set parameters
ShowTrace_SetDataPath;
ShowTrace_DefineSection;
ShowTrace_DefineChar;
ShowTrace_TrackInitiation;

%% Load Data

if ReloadDataFlag == 1
    %确认需要的文件
    file_need_all_temp=[];
    frame_raw_end_all=[];
    for section_ii = section_all
        file_need_all_temp=[file_need_all_temp, file_need{section_ii}];
        frame_raw_end_all=[frame_raw_end_all, frame_raw_end{section_ii}];
    end
    file_need=unique(file_need_all_temp(1,:));

    %load date and calculate the grayscale range
    data = cell(size(file_need,2),1);
    gray_range_statistic = [];
    for i = file_need
        fprintf('Reading File #%d/%d\n', i, numel(file_need));
        data{i} = XxReadTiffSmallerThan4GB(filePath{i});
        if i == 2
            data{i} = data{i}(:,:,1:3:337);
        end
        gray_range_statistic = [gray_range_statistic; [reshape(min(min(data{i})),[],1) reshape(max(max(data{i})),[],1)]];
        disp(['Size of data{',num2str(i),'}=',num2str(size(data{i}))])
    end
end
gray_intensity = [min(gray_range_statistic(:,1)), max(gray_range_statistic(:,2))];

%% Show each frame
frame_save_num = 1;%最终保存的录像中，是第几张图
% frame_raw=1;%原始录像中是第多少张图
if isempty(save_size)
    save_size = [Ny,Nx];
end

for section_ii = section_all
    %确定crop信息
    if numel(crop_info_temp{section_ii}) == 8 %表示两行
        crop_info=zeros(frame_showfig_amount{section_ii},4);
        for ii=1:4
            crop_info(:,ii)=linspace(crop_info_temp{section_ii}(1,ii),crop_info_temp{section_ii}(2,ii),frame_showfig_amount{section_ii});
        end
    else
        crop_info = zeros(TotalFrame,4);
        for ii=1:4
            crop_info(:,ii) = crop_info_temp{section_ii}(:,ii);
        end
    end

    for frame_showfig = 1:frame_showfig_amount{section_ii}
        disp(['section',num2str(section_ii),' fig',num2str(frame_showfig)])

        if frame_showfig_amount{section_ii}==1
            frame_raw = frame_raw_begin{section_ii};
        else
            frame_raw = interp1([1 frame_showfig_amount{section_ii}],[frame_raw_begin{section_ii} frame_raw_end{section_ii}],frame_showfig);
        end
        frame_raw = round(frame_raw);

        % -----------------------------------------------------------
        % Section1 : Show the image before activation
        % -----------------------------------------------------------
        if section_ii==1
            % intensity cut and size crop
            before_data_adjust = imgintensity_cut(data{1}(:,:,frame_raw),gray_range_statistic(1,1),65535,gamma(1),1);%灰度分布0-1
            before_data_adjust = img_crop(before_data_adjust,crop_info(frame_showfig,:),CropMode,1);
            before_data_adjust = repmat(before_data_adjust,1,1,3);
            % [Ny, Nx, ~] = size(before_data_adjust);
            % data_color = ColorMap(floor(before_data_adjust(:)*255)+1,:);
            data_color = before_data_adjust;
            % data_color = imresize(data_color,[save_size(2) save_size(1)],'bicubic');
        % -----------------------------------------------------------
        % Section3: Show ROI
        % -----------------------------------------------------------
        elseif section_ii == 3
            ROI_data = imgintensity_cut(data{2}(:,:,frame_raw), gray_range_statistic(1,1),65535,gamma(1),1);% 调整灰度分布
            ROI_data = img_crop(ROI_data,crop_info(frame_showfig,:),CropMode,1);
            ROI_data = repmat(ROI_data,1,1,3);
            data_color = ROI_data;
        % -----------------------------------------------------------
        % Section2 : 持续播放并且跟踪光点点
        % -----------------------------------------------------------
        elseif section_ii == 2 %持续播放并且跟踪光点点
            % intensity cut and size crop
            after_data_adjust = imgintensity_cut(data{2}(:,:,frame_raw),gray_intensity(1),gray_intensity(2),gamma(2),1);%灰度分布0-1
            after_data_adjust = img_crop(after_data_adjust,crop_info(frame_showfig,:),CropMode,1);
            after_data_adjust = repmat(after_data_adjust,1,1,3);
            % overwrite the pixel with the color determined by ColorMap and our data_draw
            if frame_raw == 1
                for spot_idx = 1: num_spots{frame_raw, 1}
                    after_data_adjust(data_draw{frame_raw}(spot_idx, 4),data_draw{frame_raw}(spot_idx, 3),:) = ColorMap(data_draw{frame_raw}(spot_idx,2),:);
                end
            else  % 使用插值计算连续曲线的位置
                data_draw_temp = data_draw{min(frame_raw + 1, 113)};
                curve_num = numel(num_spots{frame_raw, 2});
                single_curve = cell(curve_num, 1);
                for curve_id = 1: curve_num
                    % single curve 保存的是每条曲线当前的点的数量
                    single_curve{curve_id} = data_draw{frame_raw}(data_draw{frame_raw}(:,1)==num_spots{frame_raw, 2}(curve_id),:);
                    % 生成插值后的节点
                    [xx, yy, tt] = my_interp(single_curve{curve_id}(:,4),single_curve{curve_id}(:,3),3.*single_curve{curve_id}(:,2) - 2,2);
                    xx = round(xx);
                    yy = round(yy);
                    tt = round(tt);
                    % draw a continuous line
                    for i = 1: numel(xx)
                        after_data_adjust(xx(i),yy(i),:) = ColorMap(tt(i),:);
                    end
                end
            end
            data_color = after_data_adjust;
        end

        [Ny, Nx, ~] = size(data_color);
        if section_ii == 2
            % 加上colorbar
            Color_cb = fix(linspace(maxColorNum,1,ColorBar_height));
            Color_cb = ColorMap(Color_cb,:);
            Show_cb = permute(repmat(Color_cb,[1,1,ColorBar_width]),[1,3,2]);
            x_cb = Ny - ColorBar_dispy - ColorBar_height;
            y_cb = Nx - ColorBar_dispx - ColorBar_width;
            data_color(x_cb+1:x_cb+ColorBar_height,y_cb+1:y_cb+ColorBar_width,:) = Show_cb;
        end
        % 将其变为整型
        data_color = fix(data_color * 255);
        % 展示最初图像
        h_fig = figure('Visible', 'off');
        imshow(uint8(data_color),[],'Border','tight','InitialMagnification',100)
        % get ROI on the first image
        if frame_raw == 1 && section_ii == 2 && first_time == 1 && ifROI == 1
            [ROI_x, ROI_y] = my_ginput(2);
            disp("Click at the NorthWestern and the SouthEastern corner of ROI")
            line([ROI_x(1),ROI_x(1),ROI_x(2),ROI_x(2),ROI_x(1)],[ROI_y(1),ROI_y(2),ROI_y(2),ROI_y(1),ROI_y(1)],'Color','red','LineStyle','--')
            disp([ROI_x,ROI_y])
            pause(3)
            first_time = 0;
        end

        % % 标记时间
        % for time_num = 1
        %     text(tp_scale_x(frame_showfig)*Nx*zoom_times,tp_scale_y(frame_showfig)*Ny*zoom_times,{['Frame = ',num2str(frame_real(frame_raw-frame_raw_begin{1}+1))]},'color',bar_color,'FontName',Font_name,'FontSize',Font_Size_time(frame_showfig),'FontWeight','bold')
        %     hold on
        % end

        % for Sbar_num = 1
        %     % 标记scale_bar
        %     Scale_bar(pd,length{section_ii}(frame_showfig,Sbar_num),LineWidth(frame_showfig,Sbar_num),Nx*zoom_times,Ny*zoom_times,(x_scale(frame_showfig)+x_scale_offset(Sbar_num)),y_scale(frame_showfig),bar_color,text_visible,Font_name,Font_Size_Sb(frame_showfig,Sbar_num),text_offset)%自创子函数
        %     hold on
        % end
        % 标记ROI
        if section_ii == 3
            line([ROI4Activation(1,1),ROI4Activation(1,1),ROI4Activation(2,1),ROI4Activation(2,1),ROI4Activation(1,1)], ...
                 [ROI4Activation(1,2),ROI4Activation(2,2),ROI4Activation(2,2),ROI4Activation(1,2),ROI4Activation(1,2)],'Color','red','LineStyle','--','LineWidth',1.5)
        end
        % 标记文字
        for Char_temp=1:numel(section_char{section_ii}(:,1)) %显示所有需要显示的文字
            Char_ii=section_char{section_ii}(Char_temp,1);%当前需要显示那段文字
            if frame_showfig >= section_char{section_ii}(Char_temp,2) && frame_showfig <= section_char{section_ii}(Char_temp,3)%表示这个文字在这个帧数可以显示
                text_x_ratio = interp1([1 frame_showfig_amount{section_ii}], [tl_scale_x1{Char_ii}(frame_showfig) tl_scale_x2{Char_ii}(frame_showfig)], frame_showfig);
                text_x = text_x_ratio * Nx * zoom_times;
                text_y = tl_scale_y{Char_ii}(frame_showfig) * Ny * zoom_times;
                text(text_x,text_y,text_left{Char_ii},'color',tl_color{Char_ii},'FontName',Font_name,'FontSize',Font_Size_tl(frame_showfig),'FontWeight','bold','HorizontalAlignment','center');
                hold on
            end
        end
        if section_ii == 2
            % 标记colorbar的数字和序号
            for cbi = 1:2 % 先标colorbar的数字
                text_x = text_cb_x(cbi) * Nx * zoom_times;
                text_y = text_cb_y(cbi) * Ny * zoom_times;
                text(text_x,text_y,text_cb{cbi},'color',[1,1,1],'FontName',Font_name,'FontSize',text_cb_fontsize,'HorizontalAlignment','center','FontWeight','bold');
                hold on;
            end
        end
        if savejpeg == 1
        f = getframe(h_fig); 
        f_small = f.cdata;
        % size(f_small)
        f_small = imresize(f_small, [900 900], "bicubic");
        f_enlarge = uint8(zeros([enlarged_size 3]));
        f_enlarge(:,351:1250,:) = f_small(:,:,:);
        imwrite(f_enlarge,[DataPath,'frame_save\image_900_',num2str(section_cnt),'_',num2str(frame_showfig,'%03d'),'.jpg']); 
        end
        if image_write==1
            frame=getframe(gcf);
            frame_save=frame.cdata;
            [Nx,Ny,~,~]=size(frame_save);
            tif_info_struct.ImageLength=Nx; %y dim
            tif_info_struct.ImageWidth=Ny;  %x dim
            tif_info_struct.Photometric=Tiff.Photometric.RGB;
            tif_info_struct.BitsPerSample=8;%8
            tif_info_struct.SamplesPerPixel=3;%3
            tif_info_struct.SampleFormat=Tiff.SampleFormat.UInt;
            tif_info_struct.PlanarConfiguration=Tiff.PlanarConfiguration.Chunky;
            tif_info_struct.Software = 'Matlab2022b';
            %tif_info_struct.Compression=Tiff.Compression.PackBits;
            tif_info_struct.Compression=Tiff.Compression.None;
            saveas(gcf,[DataPath,'frame_save\image_',num2str(section_ii),'_',num2str(frame_showfig),'.jpg']); 
            if frame_save_num==1
                tif_info_temp=Tiff(file_output,'w8');
                tif_info_temp.setTag(tif_info_struct);% 赋值头文件
                tif_info_temp.write(frame_save);
                
                for save_11=1:first_frame_stop*fps-1
                    tif_info_temp=Tiff(file_output,'a');
                    tif_info_temp.setTag(tif_info_struct);% 赋值头文件
                    tif_info_temp.write(frame_save);
                end
                close(h_fig);
                tif_info_temp.close;
            else
                tif_info_temp=Tiff(file_output,'a');
                tif_info_temp.setTag(tif_info_struct);%赋值头文件
                tif_info_temp.write(frame_save);
                close(h_fig);
                tif_info_temp.close;
            end
            frame_save_num=frame_save_num+1;
        else
            close(h_fig);
            frame_save_num=frame_save_num+1;
        end

    end
section_cnt = section_cnt + 1;
end

if make_video == 1
photo2video;
end