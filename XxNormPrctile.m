function output = XxNormPrctile(img, prctmin, prctmax, intensL, intensH)
img = double(img);
minIntens = prctile(img(:), prctmin);
if minIntens > intensL, minIntens = intensL; end
maxIntens = prctile(img(:), prctmax);
if maxIntens < intensH, maxIntens = intensH; end
output = (img - minIntens) / (maxIntens - minIntens);
end