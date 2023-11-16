%% GWG_script
x = -2000:0.1:2000;
y = 0.01 * (sinc(x/10).^2 + 0.25*sinc(x/10-100).^2 + 0.25*sinc(x/10+100).^2);
figure(),plot(x, y),xlim([-1100, 1100]),title("Intensity(x_f, y_f)")
imwrite(gcf,"Intensity.ipg")