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

C_my = D*double(part)*D';
C = dct2(part);

norm(C_my-C)
