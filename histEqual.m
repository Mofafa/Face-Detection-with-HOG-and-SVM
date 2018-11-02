function [ o_im ] = histEqual( inputfile )
%HISTEQU_11410595 此处显示有关此函数的摘要
%   此处显示详细说明
% L = double(max(max(inputfile))); %L-1
L=255;
inputfile = im2uint8(inputfile);
si = size(inputfile);
total = si(1)*si(2);
xbins = double(0:L);
x = double(inputfile);
x = reshape(x,[1,total]);
[count,center] = hist(x,xbins);
% figure(1);
% bar(center,count);
% title('Histogram of the orgin image');
% xlabel('intensity');
% ylabel('number of pixels');
sum = 0;
for r=1:L+1
    sum = sum + count(r);
    s(r) = L*sum/total;
end
 s = round(s);
for i = 1:si(1)
    for j = 1:si(2)
        out(i,j) = s(inputfile(i,j)+1);
    end
end
o_im = uint8(out);
% out = reshape(out,[1,total]);
% [ocount,ocenter] = hist(out,xbins);
% figure(2)
% o_hist = bar(ocenter,ocount);
% title('Histogram of the processed image');
% xlabel('intensity');
% ylabel('number of pixels');
end


