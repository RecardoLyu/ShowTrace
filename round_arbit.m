function b=round_arbit(a,precision)

%����һ�����ֺ;��ȣ�������Ӧ�Ľ���ֵ������a=1.4,precision=0.5�ͷ���һ��1.5
%����ȡ��matlab��roundn��round������
%a�����ǵ������֣����飬���󣬵ȵ��������

b=round(a/precision);
b=b*precision;

end