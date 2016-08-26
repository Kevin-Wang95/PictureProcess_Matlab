%% Code
Datalenbit = bitget(Datalen,32:-1:1);
Data = uint8(Data);

k = 1;
for i = 1:newhwlen(1)/8
    for j = 1:newhwlen(2)/8
        c = dct2(newimg(8*i-7:8*i,8*j-7:8*j)-128);
        c = round(c ./ QTAB);
        if(k <= Datalen)
            c = int8(c);
            if(i == 1 && j == 1)
                for k = 1:32
                    c(k) = bitset(c(k), 1, Datalenbit(k));
                end
                for k = 33:64
                    temp = bitget(Data(ceil(k/8)-4),8:-1:1);
                    a = mod(k,8); if(a==0) a = 8; end
                    c(k) = bitset(c(k), 1, temp(a));
                end
                k = 4;
            else
                for l = 1:8
                    k = k + 1;
                    if(k > Datalen)
                        break;
                    end
                    temp = bitget(Data(k),8:-1:1);
                    c(8*l - 7:8*l)= bitset(c(8*l - 7:8*l), 1, temp);
                end
            end
        end
        coef(:,(i-1)*newhwlen(2)/8+j) = c(zigzag(8));
    end
end

%% Decode 
% Anti-Qulified && Get Data
GetData = [];
img = zeros(height, width);
numwidth = width/8;
j = 0;
decodeflag = true;
bitoflen = [];
bitofchrac = [];
for i = 1:size(coef,2)
    currentblock(zigzag(8)) = coef(:,i);
    block88 = reshape(currentblock,8,8);
    if(decodeflag)
        if(i == 1)
            for k = 1:32
                temp = bitget(int8(block88(k)),1);
                bitoflen = [bitoflen num2str(temp)];
            end
            bitlen = bin2dec(bitoflen);
            for k = 33:64
                temp = bitget(int8(block88(k)),1);
                bitofchrac = [bitofchrac num2str(temp)];
                if(~mod(k,8))
                    GetData = [GetData char(bin2dec(bitofchrac))];
                    bitofchrac = [];
                end
            end
        else
            for k = 1:64
                if(j*8 + ceil(k/8) > bitlen + 4)
                    decodeflag = false;
                end
                temp = bitget(int8(block88(k)),1);
                bitofchrac = [bitofchrac num2str(temp)];
                if(~mod(k,8))
                    GetData = [GetData char(bin2dec(bitofchrac))];
                    bitofchrac = [];
                end
            end
            
        end
    end
...