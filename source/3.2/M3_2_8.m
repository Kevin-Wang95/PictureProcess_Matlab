clear all; close all;

load hall.mat;
load JpegCoeff.mat;

hwlen = size(hall_gray);
newhwlen = ceil(hwlen/8)*8;
newimg = zeros(newhwlen);

newimg(1:hwlen(1),1:hwlen(2)) = hall_gray;
if(hwlen(1) < newhwlen(1))
    newimg(hwlen(1)+1:newhwlen(1),:) = hall_gray(hwlen(1),:);  
end
if(hwlen(2) < newhwlen(2))
    newimg(:,hwlen(2)+1:newhwlen(2)) = hall_gray(:,hwlen(2));
end

coef = zeros(64,newhwlen(1)*newhwlen(2)/64);

for i = 1:newhwlen(1)/8
    for j = 1:newhwlen(2)/8
        c = dct2(newimg(i:i+7,j:j+7)-128);
        c = round(c ./ QTAB);
        coef(:,(i-1)*8+j) = c(zigzag(8));
    end
end