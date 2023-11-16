function img_out=imgintensity_cut(img_in,gray_intensity_min_temp,gray_intensity_max_temp,gamma,output_bit)

%输入图像信号img_in，多少bit的数据无所谓，数据类型也无所谓，可以是多张数据图；
%灰度上下限gray_intensity_min_temp,gray_intensity_max_temp，这两个数的大小无所谓，下面会自动识别；范围外的亮度自动变成上下限
%gamma，调节gamma，调节效果是比如8bit的图像，调节前的亮度范围0-190，调整后的亮度范围依旧是0-190，效果就是最亮的像素依旧显示gray_intensity_max_temp/65535的亮度，但是弱的像素会变亮。比如16bit输入，并且不改变最大最小亮度，输出的图也是16bit，那么最亮的pixel的亮度数值不变
%输出图像的bit数，output_bit，就是2^output_bit-1作为最大灰度。等于1就是0-1范围的图
%img_out是double类型

%img_in, input image
%gray_intensity_min_temp,gray_intensity_max_temp  the max and min intensity threshold for input image
%gamma, gamma value
%output_bit is bit for output image


%2017-12-4修正了最后使用floor的bug以及output_bit<1会输出错误数据的bug，此外增加了这个函数对于三维图像序列的支持。晚上增加了调节gamma的功能，导致之前的程序很多需要大改
%对于三维数据的支持，就可以处理RGB三色数据了。
%2018-05-10增加了对于输入数据含有负数时的支持


gray_intensity_min=min(gray_intensity_min_temp,gray_intensity_max_temp);
gray_intensity_max=max(gray_intensity_min_temp,gray_intensity_max_temp);
img_in=double(img_in);%数据准备

if gray_intensity_min<0
    gray_intensity_min_temp=gray_intensity_min;
    gray_intensity_min=gray_intensity_min-gray_intensity_min_temp;
    gray_intensity_max=gray_intensity_max-gray_intensity_min_temp;
    img_in=img_in-gray_intensity_min_temp;
end

[nx,ny,nz]=size(img_in);
img_0_1=zeros(nx,ny,nz);

for frame_num=1:nz
    img_in_max=max(max(img_in(:,:,frame_num)));%当前图像的最大灰度
    if img_in_max==0
        img_0_1(:,:,frame_num)=0;
        continue
    end
    img_0_1(:,:,frame_num)=img_in(:,:,frame_num)/img_in_max;%0-1
    zero_point_0_1 = gray_intensity_min/img_in_max;
    bri_point_0_1  = gray_intensity_max/img_in_max;
    if zero_point_0_1<0 || bri_point_0_1<0
        disp(['Frame-',num2str(frame_num),' setting max/min_intensity is smaller than 0, please check!'])
        return
    elseif bri_point_0_1<=1
        img_0_1(:,:,frame_num)=imadjust(img_0_1(:,:,frame_num),[zero_point_0_1,bri_point_0_1],[0,1]);
    elseif bri_point_0_1>1 && zero_point_0_1<1
        img_0_1(:,:,frame_num)=imadjust(img_0_1(:,:,frame_num),[zero_point_0_1,1],[0,img_in_max/gray_intensity_max]);%这个结果就是0-1范围的了
    else
        frame_num
        img_in_max
        disp(['Frame-',num2str(frame_num),' setting min_intensity is bigger than max intensity in image, please check!']) %这个限制有用么？？？2019-02-16
        return
    end
end

if gamma~=1
    img_0_1_ga=img_0_1.^gamma;
    img_0_1_res=img_0_1_ga*max(max(max(img_0_1)))/max(max(max(img_0_1_ga)));%此时img_0_1_ga/max(max(max(img_0_1_ga)))的范围就是0-1，再乘以max(max(max(img_0_1)))就是最大值变成需要的190了
else
    img_0_1_res=img_0_1;
end

if output_bit>1
    img_out=round(img_0_1_res*(2^output_bit-1));
elseif output_bit==1
    img_out=img_0_1_res;
end

end