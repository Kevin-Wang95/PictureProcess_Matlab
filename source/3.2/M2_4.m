clear all; close all;
load hall.mat

part = hall_gray(11:18,21:28);
C = dct2(part - uint8(128));

C0 = C'; C1 = rot90(C); C2 = rot90(C1);
transpose = uint8(idct2(C0) + 128);
rightrot90 = uint8(idct2(C1) + 128);
rightrot180 = uint8(idct2(C2) + 128);

imshow(part);
imwrite(part,'origin_rot.jpg');
figure();
imshow(transpose);
imwrite(transpose, 'transpose.jpg');
figure();
imshow(rightrot90);
imwrite(rightrot90, 'rightrot90.jpg');
figure();
imshow(rightrot180);
imwrite(rightrot180, 'rightrot180.jpg');