clear all; close all;
load hall.mat

part = hall_gray(11:18,21:28);

C = dct2(part-uint8(128));

C1 = C; C2 = C;
C1(:,5:8) = 0;
C2(:,1:4) = 0;

rightzeropart = uint8(idct2(C1) + 128);
leftzeropart = uint8(idct2(C2) + 128);

imshow(part);
imwrite(part,'origin.jpg');
figure();
imshow(rightzeropart);
imwrite(rightzeropart,'rightzero.jpg');
figure();
imshow(leftzeropart);
imwrite(leftzeropart,'leftzero.jpg')