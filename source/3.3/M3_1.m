%% Hide and Fetch
% Hide
clear all; close all;

load hall.mat

Data = ['MATLAB (matrix laboratory) is a multi-paradigm numerical computing ' ...
    'environment and fourth-generation programming language. A proprietary ' ...
    'programming language developed by MathWorks, MATLAB allows matrix ' ...
    'manipulations, plotting of functions and data, implementation of ' ...
    'algorithms, creation of user interfaces, and interfacing with programs' ...
    'written in other languages, including C, C++, Java, Fortran and Python.'];

Datalen = length(Data);
Hidebitlen = Datalen * 8 + 32;
hw = size(hall_gray); 
if(hw(1)*hw(2) < Hidebitlen)
    error 'Image not enough to hid';
end

Bitleninbit = bitget(Datalen, 32:-1:1);
afterimg = hall_gray;

afterimg(1:32) = bitset(hall_gray(1:32), 1, Bitleninbit(1:32));

for i = 1:Datalen
    Databit = bitget(uint8(Data(i)),8:-1:1);
    afterimg(8*(i+4)-7:8*(i+4)) = bitset(hall_gray(8*(i+4)-7:8*(i+4)),1,Databit);
end

figure(1)
imshow(hall_gray);
imwrite(hall_gray,'hallgray.jpg');
figure(2)
imshow(afterimg);
imwrite(afterimg,'Afterhidden.jpg')

% Fetch
fetchbit = [];
for i = 1:32
    temp = bitget(afterimg(i),8:-1:1);
    fetchbit = [fetchbit num2str(temp(8))];
end

bitlen = bin2dec(fetchbit);
tempchara = [];
chara = [];
for i = 1:bitlen*8
    temp = bitget(afterimg(i+32),8:-1:1);
    tempchara = [tempchara num2str(temp(8))];
    if(~mod(i,8))
        singlechara = char(bin2dec(tempchara));
        chara = [chara singlechara];
        tempchara = [];
    end
end

%% Jepg Code and Decode
CodeJepg = Jepg(afterimg);
DocodeJepg = DeJepg(CodeJepg);

% Fetch
fetchbit2 = [];
for i = 1:32
    temp = bitget(DocodeJepg(i),8:-1:1);
    fetchbit2 = [fetchbit2 num2str(temp(8))];
end

bitlen = bin2dec(fetchbit2);
if (bitlen*8 > numel(DocodeJepg))
    display('Wrong! Exist!');
end
data = [];
tempchara = [];
for i = 1:min(bitlen*8, numel(DocodeJepg)-32)
    temp = bitget(DocodeJepg(i+32),8:-1:1);
    tempchara = [tempchara num2str(temp(8))];
    if(~mod(i,8))
        singlechara = char(bin2dec(tempchara));
        data = [data singlechara];
        tempchara = [];
    end
end