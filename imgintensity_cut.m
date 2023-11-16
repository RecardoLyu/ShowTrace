function img_out=imgintensity_cut(img_in,gray_intensity_min_temp,gray_intensity_max_temp,gamma,output_bit)

%����ͼ���ź�img_in������bit����������ν����������Ҳ����ν�������Ƕ�������ͼ��
%�Ҷ�������gray_intensity_min_temp,gray_intensity_max_temp�����������Ĵ�С����ν��������Զ�ʶ�𣻷�Χ��������Զ����������
%gamma������gamma������Ч���Ǳ���8bit��ͼ�񣬵���ǰ�����ȷ�Χ0-190������������ȷ�Χ������0-190��Ч����������������������ʾgray_intensity_max_temp/65535�����ȣ������������ػ����������16bit���룬���Ҳ��ı������С���ȣ������ͼҲ��16bit����ô������pixel��������ֵ����
%���ͼ���bit����output_bit������2^output_bit-1��Ϊ���Ҷȡ�����1����0-1��Χ��ͼ
%img_out��double����

%img_in, input image
%gray_intensity_min_temp,gray_intensity_max_temp  the max and min intensity threshold for input image
%gamma, gamma value
%output_bit is bit for output image


%2017-12-4���������ʹ��floor��bug�Լ�output_bit<1������������ݵ�bug�������������������������άͼ�����е�֧�֡����������˵���gamma�Ĺ��ܣ�����֮ǰ�ĳ���ܶ���Ҫ���
%������ά���ݵ�֧�֣��Ϳ��Դ���RGB��ɫ�����ˡ�
%2018-05-10�����˶����������ݺ��и���ʱ��֧��


gray_intensity_min=min(gray_intensity_min_temp,gray_intensity_max_temp);
gray_intensity_max=max(gray_intensity_min_temp,gray_intensity_max_temp);
img_in=double(img_in);%����׼��

if gray_intensity_min<0
    gray_intensity_min_temp=gray_intensity_min;
    gray_intensity_min=gray_intensity_min-gray_intensity_min_temp;
    gray_intensity_max=gray_intensity_max-gray_intensity_min_temp;
    img_in=img_in-gray_intensity_min_temp;
end

[nx,ny,nz]=size(img_in);
img_0_1=zeros(nx,ny,nz);

for frame_num=1:nz
    img_in_max=max(max(img_in(:,:,frame_num)));%��ǰͼ������Ҷ�
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
        img_0_1(:,:,frame_num)=imadjust(img_0_1(:,:,frame_num),[zero_point_0_1,1],[0,img_in_max/gray_intensity_max]);%����������0-1��Χ����
    else
        frame_num
        img_in_max
        disp(['Frame-',num2str(frame_num),' setting min_intensity is bigger than max intensity in image, please check!']) %�����������ô������2019-02-16
        return
    end
end

if gamma~=1
    img_0_1_ga=img_0_1.^gamma;
    img_0_1_res=img_0_1_ga*max(max(max(img_0_1)))/max(max(max(img_0_1_ga)));%��ʱimg_0_1_ga/max(max(max(img_0_1_ga)))�ķ�Χ����0-1���ٳ���max(max(max(img_0_1)))�������ֵ�����Ҫ��190��
else
    img_0_1_res=img_0_1;
end

if output_bit>1
    img_out=round(img_0_1_res*(2^output_bit-1));
elseif output_bit==1
    img_out=img_0_1_res;
end

end