function img_out=img_crop(img_in,crop_info,crop_info_mode,crop_mode)

%crop图像用的小程序
%img_in是输入数据
%crop_info是crop时候的位置信息，第一个数字大于等于0才进行crop,四个数字，前2定中心坐标，后2定ROI，数字也是image-J读取
%image-J读取的数字换算成c，如果长宽都是偶数，长/宽÷2+顶点数字=center数字，是奇数还没有验证。
%crop_info_mode
%crop_mode，如果是1就img_in就是切割下来的小图像，如果是2就img_out跟img_in相同尺寸但是外面填充上0

%目前测试tif是可以使用这个程序的，但是mrc没有测试，后来测试发现只要matlab显示的图像跟image-J没区别即可工作。
%2019-03-02，大幅度修改这个程序，中心和边界两个模式，

if crop_info(1)<0 %表示不用crop
    img_out=img_in;
else
    [column_amount,row_amount,~]=size(img_in);
    img_dims=ndims(img_in);%矩阵维度
    
    if strcmp(crop_info_mode,'c')==1%表示中心模式
        column1=max(crop_info(2)-ceil(crop_info(4)/2)+1,1);%注意原始iamge-J需要xy互换
        column2=min(crop_info(2)-ceil(crop_info(4)/2)+1+crop_info(4)-1,column_amount);
        row1=max(crop_info(1)-ceil(crop_info(3)/2)+1,1);
        row2=min(crop_info(1)-ceil(crop_info(3)/2)+1+crop_info(3)-1,row_amount);
    else
        disp('crop_info_mode is error')
        return
    end   
    
    
    %分割并输出
    if crop_mode==1 %要小图
        if img_dims==2;
            img_out=img_in(column1:column2,row1:row2);
        elseif img_dims==3;
            img_out=img_in(column1:column2,row1:row2,:);
        elseif img_dims==4;
            img_out=img_in(column1:column2,row1:row2,:,:);
        elseif img_dims==5;
            img_out=img_in(column1:column2,row1:row2,:,:,:);
        elseif img_dims==6;
            img_out=img_in(column1:column2,row1:row2,:,:,:,:);
        end
    elseif crop_mode==2 %要填充了0的大图
        img_out=img_in;
        img_out(:)=0;
        if img_dims==2;
            img_out(column1:column2,row1:row2)=img_in(column1:column2,row1:row2);
        elseif img_dims==3;
            img_out(column1:column2,row1:row2,:)=img_in(column1:column2,row1:row2,:);
        elseif img_dims==4;
            img_out(column1:column2,row1:row2,:,:)=img_in(column1:column2,row1:row2,:,:);
        elseif img_dims==5;
            img_out(column1:column2,row1:row2,:,:,:)=img_in(column1:column2,row1:row2,:,:,:);
        elseif img_dims==6;
            img_out(column1:column2,row1:row2,:,:,:,:)=img_in(column1:column2,row1:row2,:,:,:,:);
        end        
    end   
    
end


end

