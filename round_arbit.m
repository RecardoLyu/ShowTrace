function b=round_arbit(a,precision)

%输入一个数字和精度，返回相应的近似值，比如a=1.4,precision=0.5就返回一个1.5
%用于取代matlab的roundn和round的限制
%a可以是单个数字，数组，矩阵，等等任意变量

b=round(a/precision);
b=b*precision;

end