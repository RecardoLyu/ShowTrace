function [xx, yy, tt] = my_interp(x,y,t,n)
%MY_INTERP 在x, y两个数组的相邻量之间插入n个点的函数
% 请输入列向量
% n表示相邻两个点之间想要插入点的数量
% 返回插值结果（基于相邻2点的线性插值）
%% size check
if size(x) ~= size(y)
    fprintf('size error')
else
    nx = size(x, 1);
    ny = size(y, 1);
    xx = zeros((nx-1) * (n + 1) + 1, 1);
    [X, ~] = size(xx);
    yy = zeros((ny-1) * (n + 1) + 1, 1);
    [Y, ~] = size(yy);
    % for i = 0: n
    % xx(i+1: (n+1): (X-n+i)) = x(:)./(n+1);
    % yy(i+1: (n+1): (Y-n+i)) = y(:)./(n+1);
    % end
    xx = [];yy = [];tt = [];
    for i = 1 : (ny-1) * (n + 1)
        tt = [tt t(ceil(i/(n+1))) * ((n+1) - mod(i-1,n+1)) / (n+1) + t(ceil(i/(n+1))+1) * mod(i-1,n+1)/(n+1)];
        xx = [xx x(ceil(i/(n+1))) * ((n+1) - mod(i-1,n+1)) / (n+1) + x(ceil(i/(n+1))+1) * mod(i-1,n+1)/(n+1)];
        yy = [yy y(ceil(i/(n+1))) * ((n+1) - mod(i-1,n+1)) / (n+1) + y(ceil(i/(n+1))+1) * mod(i-1,n+1)/(n+1)];
    end
    xx = [xx x(end)]';
    yy = [yy y(end)]';
    tt = [tt t(end)]';
end

