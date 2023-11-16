function img_out=img_crop(img_in,crop_info,crop_info_mode,crop_mode)

%cropͼ���õ�С����
%img_in����������
%crop_info��cropʱ���λ����Ϣ����һ�����ִ��ڵ���0�Ž���crop,�ĸ����֣�ǰ2���������꣬��2��ROI������Ҳ��image-J��ȡ
%image-J��ȡ�����ֻ����c�����������ż������/���2+��������=center���֣���������û����֤��
%crop_info_mode
%crop_mode�������1��img_in�����и�������Сͼ�������2��img_out��img_in��ͬ�ߴ絫�����������0

%Ŀǰ����tif�ǿ���ʹ���������ģ�����mrcû�в��ԣ��������Է���ֻҪmatlab��ʾ��ͼ���image-Jû���𼴿ɹ�����
%2019-03-02��������޸�����������ĺͱ߽�����ģʽ��

if crop_info(1)<0 %��ʾ����crop
    img_out=img_in;
else
    [column_amount,row_amount,~]=size(img_in);
    img_dims=ndims(img_in);%����ά��
    
    if strcmp(crop_info_mode,'c')==1%��ʾ����ģʽ
        column1=max(crop_info(2)-ceil(crop_info(4)/2)+1,1);%ע��ԭʼiamge-J��Ҫxy����
        column2=min(crop_info(2)-ceil(crop_info(4)/2)+1+crop_info(4)-1,column_amount);
        row1=max(crop_info(1)-ceil(crop_info(3)/2)+1,1);
        row2=min(crop_info(1)-ceil(crop_info(3)/2)+1+crop_info(3)-1,row_amount);
    else
        disp('crop_info_mode is error')
        return
    end   
    
    
    %�ָ���
    if crop_mode==1 %ҪСͼ
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
    elseif crop_mode==2 %Ҫ�����0�Ĵ�ͼ
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

