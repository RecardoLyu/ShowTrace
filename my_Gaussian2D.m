%% my_Gaussian2D: 产生一个2D高斯函数的mask对图像进行幅度调制
function mask_gaussian = my_Gaussian2D(mask_size, center, attenuation_rate)
mask_gaussian = zeros(mask_size);
sigma_x = mask_size(1)/attenuation_rate;
sigma_y = mask_size(2)/attenuation_rate;
center_x = center(1);
center_y = center(2);
for i = 1 : mask_size(1)
    for j = 1 : mask_size(2)
        mask_gaussian(i,j) = 1/(2*pi*sigma_x*sigma_y)*exp(-(sigma_y^2*(i - center_x)^2+sigma_x^2*(j-center_y)^2)/(2*sigma_x^2*sigma_y^2));
    end
end
max_intensity = max(max(mask_gaussian));
min_intensity = min(min(mask_gaussian));
mask_gaussian = 1.5 *(mask_gaussian - min_intensity)/(max_intensity - min_intensity);
end