function Scale_bar(pd,length,LineWidth,x_pixel,y_pixel,x_scale,y_scale,bar_color,text_visible,Font_name,Font_Size,text_offset)
%label the scale bar on image
%pd = pixel size (nm)
%length = total length of scale bar(nm)
%LineWidth = width of scale bar
%
%x_pixel,y_pixel = amount pixel of
%frame,x_pixel=colum,y_pixel=row，完全符合下面的顺序
%
%x_scale = x position scale [0~1] in real image, Far left is 0
%y_scale = y position scale [0~1] in real image, uppermost is 0
%bar_color = color of scale, char or [num num num]

%text_visible = whether show text, show unit um,
%'off'= non text,'up' = show up,'down' = show down

length_pixel=length/pd;
start_point=[x_pixel*x_scale,y_pixel*y_scale];
end_point=[x_pixel*x_scale+length_pixel,y_pixel*y_scale];

plot([start_point(1) end_point(1)],[start_point(2) end_point(2)],'linewidth',LineWidth,'color',bar_color)
if strcmp(text_visible,'off')==1
elseif strcmp(text_visible,'up')==1
    text(x_pixel*x_scale+length_pixel*0.5,y_pixel*y_scale-text_offset,[num2str(length/1000),' μm'],'HorizontalAlignment','center','color',bar_color,'FontName',Font_name,'FontSize',Font_Size,'FontWeight','bold')
elseif strcmp(text_visible,'down')==1
    text(x_pixel*x_scale+length_pixel*0.5,y_pixel*y_scale+text_offset,[num2str(length/1000),' μm'],'HorizontalAlignment','center','color',bar_color,'FontName',Font_name,'FontSize',Font_Size,'FontWeight','bold')
end

end