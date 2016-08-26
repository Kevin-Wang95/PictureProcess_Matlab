clear all; close all;
load hall.mat

part = hall_gray(11:18,21:28);
a1 = dct2(part);
a1(1) = a1(1) -128/(1/8);
a2 = dct2(part-128);

ans = norm(a1-a2)

% ans = 3.5762e-13