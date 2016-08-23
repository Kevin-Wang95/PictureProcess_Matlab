clear all; close all;
load hall.mat

part = hall_gray(11:18,21:28);
N = 8;

D = zeros(N,N);
for i = 1:N
    for j = 1:N
        D(i,j) = cos(pi*(i-1)*(2*j-1)/(2*N));
    end
end
D(1,:) = sqrt(1/2);
D = D *sqrt(2/N);

C = D*double(part)*D';

D1 = rot90(D); D2 = rot90(D1);
rightzeropart = D1'*C*D1;
leftzeropart = D2'*C*D2;

imshow(part);
figure();
imshow(rightzeropart);
figure();
imshow(leftzeropart);