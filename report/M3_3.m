UpperT = 6;
%% Code
Data = ['MATLAB (matrix laboratory) is a multi-paradigm numerical computing ' ...
    'environment and fourth-generation programming language.'];

Datalen = length(Data);
Hidebitlen = Datalen * 8 + 8;

Datalenbit = bitget(Datalen,8:-1:1);
Data = uint8(Data);

HiddenData = Datalenbit;
for i = 1:length(Data)
    HiddenData = [HiddenData bitget(Data(i),8:-1:1)];
end

k = 1; l = 0;
for i = 1:newhwlen(1)/8
    for j = 1:newhwlen(2)/8
        c = dct2(newimg(8*i-7:8*i,8*j-7:8*j)-128);
        c = round(c ./ QTAB);
        order = c(zigzag(8));
        pos = find(order >= UpperT | order <= -UpperT + 1);
        if(~isempty(pos))
            for ii = 1:length(pos)
                if(k > Hidebitlen)
                    break;
                end
                if(order(pos(ii))>0)
                    order(pos(ii)) = double(bitset(uint8(order(pos(ii))), 1, HiddenData(k)));
                else
                    tempcom = dec2bin(-order(pos(ii))) - '0';
                    tempcom = 1 - tempcom;
                    tempcom(length(tempcom)) = tempcom(length(tempcom)) + 1;
                    while(~isempty(find(tempcom>1, 1, 'last')))
                        pos2 = find(tempcom>1, 1, 'last');
                        if(pos2~=1)
                            tempcom(pos2) = 0;
                            tempcom(pos2 - 1) = tempcom(pos2 - 1) + 1;
                        else
                            tempcom(pos2) = 0;
                            tempcom = [1 tempcom];
                        end
                    end
                    tempcomlen = length(tempcom);
                    tempcom = bin2dec(num2str(tempcom));
                    tempcom = double(bitset(uint8(tempcom), 1, HiddenData(k)));
                    tempcom = dec2bin(tempcom, tempcomlen) - '0';
                    tempcom = 1 - tempcom;
                    tempcom(length(tempcom)) = tempcom(length(tempcom)) + 1;
                    while(~isempty(find(tempcom>1, 1, 'last')))
                        pos2 = find(tempcom>1, 1, 'last');
                        if(pos2~=1)
                            tempcom(pos2) = 0;
                            tempcom(pos2 - 1) = tempcom(pos2 - 1) + 1;
                        else
                            tempcom(pos2) = 0;
                            tempcom = [1 tempcom];
                        end
                    end
                    tempcom = -bin2dec(num2str(tempcom));
                    order(pos(ii)) = double(tempcom);
                end
                k = k + 1;
            end               
        end
        coef(:,(i-1)*newhwlen(2)/8+j) = double(order);
    end
end
%% Decode
% Anti-Qulified 
img = zeros(height, width);
numwidth = width/8;
j = 0;
decodeBit = [];
for i = 1:size(coef,2)
    temp = coef(:,i);
    pos = find(temp >= UpperT | temp <= -UpperT + 1);
    if(~isempty(pos))
        for ii = 1:length(pos)
            if(temp(pos(ii))>0)
                decodeBit = [decodeBit, num2str(bitget(uint8(temp(pos(ii))), 1))];
            else
                tempcom = dec2bin(-temp(pos(ii))) - '0';
                tempcom = 1 - tempcom;
                tempcom(length(tempcom)) = tempcom(length(tempcom)) + 1;
                decodeBit = [decodeBit, num2str(mod(tempcom(length(tempcom)),2))];
            end
        end
    end

...
    
bitlen = bin2dec(decodeBit(1:8));
bitofchrac = [];
GetData = [];
for i = 1:bitlen
    if(8*i+8>length(decodeBit))
        break;
    end
    GetData = [GetData char(bin2dec(decodeBit(8*i+1:8*i+8)))];
end