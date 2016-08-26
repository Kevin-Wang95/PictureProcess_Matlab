%% Code
Data = ['MATLAB is paradigm numerical computing'];

Datalen = length(Data);
Hidebitlen = Datalen * 8 + 8;
Datalenbit = bitget(Datalen,8:-1:1);
Datalenbit(Datalenbit==0) = -1;
Data = uint8(Data);

k = 1; l = 0;
for i = 1:newhwlen(1)/8
    for j = 1:newhwlen(2)/8
        c = dct2(newimg(8*i-7:8*i,8*j-7:8*j)-128);
        c = round(c ./ QTAB);
        order = c(zigzag(8));
        pos = find(order~=0);
        if(k <= Datalen)
            if(i == 1 && j <= 8)
                if(pos(length(pos))==64)
                    order(64) = Datalenbit(j);
                else
                    order(pos(length(pos))+1) = Datalenbit(j);
                end
                k = 1;
            else
                if(k > Datalen)
                    break;
                end
                temp = bitget(Data(k),8:-1:1);
                temp = double(temp);
                temp(temp==0) = -1;
                if(pos(length(pos))==64)
                    order(64) = temp(l+1);
                else
                    order(pos(length(pos))+1) = temp(l+1);
                end
                l = l + 1;
                if(~mod(l,8))
                    k = k + 1;
                    l = 0;
                end
            end
        end
        coef(:,(i-1)*newhwlen(2)/8+j) = order;
    end
end
%% Decode
% Anti-Qulified 
img = zeros(height, width);
numwidth = width/8;
j = 0;
decodeflag = true;
bitoflen = [];
bitofchrac = [];
GetData = [];
for i = 1:size(coef,2)
    if(decodeflag)
        temp = coef(:,i);
        pos = find(temp~=0);
        temp = temp(pos(length(pos)));
        if(temp == -1)
            temp = 0;
        end
        if(i <= 8)
            bitoflen = [bitoflen num2str(temp)];
            if(i == 8)
                bitlen = bin2dec(bitoflen);
            end
        else
            if(i > (bitlen + 1)*8)
                decodeflag = false;
            end
            bitofchrac = [bitofchrac num2str(temp)];
            if(~mod(i,8))
                GetData = [GetData char(bin2dec(bitofchrac))];
                bitofchrac = [];
            end
        end
    end
    currentblock(zigzag(8)) = coef(:,i);
...