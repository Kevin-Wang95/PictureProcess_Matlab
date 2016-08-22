function DocodeJepg = DeJepg(CodeJepg)
    load JpegCoeff.mat
    Dc_ceof = CodeJepg{1};
    Ac_ceof = CodeJepg{2};
    height = CodeJepg{3};
    width = CodeJepg{4};
    
    coef = zeros(64, height*width/64);
    diff = zeros(1, height*width/64);
    DC_Huff = DCTAB(:,2:size(DCTAB,2));
    for i =1:size(DCTAB,1)
        DC_Huff(i, DCTAB(i,1)+1) = inf;
        DC_Huff(i, DCTAB(i,1)+2) = i;
    end
    AC_Huff = ACTAB(:,4:size(ACTAB,2));
    for i =1:size(ACTAB,1)
        AC_Huff(i, ACTAB(i,3)+1) = inf;
        AC_Huff(i, ACTAB(i,3)+2) = i;
    end
    AC_Huff(size(AC_Huff,1)+1,1:11) = [1 1 1 1 1 1 1 1 0 0 1];
    AC_Huff(size(AC_Huff,1),12) = inf;
    AC_Huff(size(AC_Huff,1),13) = size(AC_Huff,1);
    AC_Huff(size(AC_Huff,1)+1,1:4) = [1 0 1 0];
    AC_Huff(size(AC_Huff,1),5) = inf;
    AC_Huff(size(AC_Huff,1),6) = -inf;

    %% Process DC 
    point = 1;
    while(~isempty(Dc_ceof))
        temp_DC = DC_Huff;
        while(size(temp_DC,1)~=1)
            for i = size(temp_DC,1):-1:1
                if(temp_DC(i,1) ~= Dc_ceof(1))
                    temp_DC(i,:) = [];
                end
            end
            temp_DC(:,1) = [];
            Dc_ceof(1) = [];
         end
        pos = find(temp_DC==inf);
        if(pos~=1)
            Dc_ceof(:,1:pos-1) = [];
        end

        if(temp_DC(pos+1)~=1)
            bin = Dc_ceof(1,1:(temp_DC(pos+1)-1));
            if(bin(1)==0)
                bin = ~bin;
                sign = false;
            else
                sign = true;
            end
            Dc_ceof(:,1:length(bin)) = [];
            bin = num2str(bin);
            dec = bin2dec(bin);
            if(sign)
                diff(1,point) = dec;
            else
                diff(1,point) = -dec;
            end
        else
            diff(1,point) = 0;
        end
        point = point + 1;
    end

    coef(1,1) = diff(1,1); 
    for i = 2:length(diff)
        coef(1,i) = coef(1,i-1) - diff(1,i);
    end

    %% Process AC
    point = 1;
    rownum = 2;
    while(~isempty(Ac_ceof))
        temp_AC = AC_Huff;
        while(size(temp_AC,1)~=1)
            for i = size(temp_AC,1):-1:1
                if(temp_AC(i,1) ~= Ac_ceof(1))
                    temp_AC(i,:) = [];
                end
            end
            temp_AC(:,1) = [];
            Ac_ceof(1) = [];
        end
        pos = find(temp_AC==inf);
        if(pos~=1)
            Ac_ceof(:,1:pos-1) = [];
        end
        if(temp_AC(pos+1)==-inf)
            point = point + 1;
            rownum = 2;
        else
            numsize = mod(temp_AC(pos+1),10);
            numrun = floor(temp_AC(pos+1)/10);
            if(numsize == 0)
                numsize = 10;
                numrun = numrun - 1;
            end
            if(numrun == 16)
                rownum = rownum + numrun;
            else 
                bin = Ac_ceof(1,1:numsize);
                Ac_ceof(:,1:numsize) = [];
                if(bin(1)~=0)
                    sign = true;
                else
                    sign = false;
                    bin = ~bin;
                end
                bin = num2str(bin);
                dec = bin2dec(bin);
                if(sign)
                    coef(rownum+numrun,point) = dec;
                else
                    coef(rownum+numrun,point) = -dec;
                end
                rownum = rownum + numrun + 1;
            end
        end
    end

    %% Anti-Qulified 
    img = zeros(height, width);
    numwidth = width/8;
    j = 0;
    for i = 1:size(coef,2)
        currentblock(zigzag(8)) = coef(:,i);
        block88 = reshape(currentblock,8,8);
        block88 = round(block88 .* QTAB);
        imgblock = idct2(block88);
        tempw = mod(j,numwidth) + 1;
        temph = floor(j/numwidth) + 1;
        img(8*temph-7:8*temph,8*tempw-7:8*tempw) = imgblock;
        j = j + 1;
    end
    img = img + 128;
    DocodeJepg = uint8(img);