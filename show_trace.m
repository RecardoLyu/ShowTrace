function CB = show_trace(img, ColorBarWidth, ColorBarHeight)
%SHOW_TRACE 此处显示有关此函数的摘要
%   此处显示详细说明
CB = colorbar;
CB.Parent = img;
CB.TicksMode = "auto";
CB.LimitsMode = "manual";
CB.Limits = [1 113];
CB.Position = [900, 10, ColorBarWidth,ColorBarHeight];
CB.Label.String = 'Time';
CB.set
% 指定为 [left, bottom, width, height] 形式的四元素向量。
% left 和 bottom 元素指定图窗左下角到颜色栏左下角的距离。
% width 和 height 元素指定颜色栏的维度。Units 属性确定位置单位。
end

