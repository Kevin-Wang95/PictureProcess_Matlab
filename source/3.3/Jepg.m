function CodeJepg = Jepg(hall_gray)
    load JpegCoeff.mat;

    hwlen = size(hall_gray);
    newhwlen = ceil(hwlen/8)*8;
    newimg = zeros(newhwlen);

    newimg(1:hwlen(1),1:hwlen(2)) = hall_gray;
    if(hwlen(1) < newhwlen(1))
        newimg(hwlen(1)+1:newhwlen(1),:) = hall_gray(hwlen(1),:);  
    end
    if(hwlen(2) < newhwlen(2))
        newimg(:,hwlen(2)+1:newhwlen(2)) = hall_gray(:,hwlen(2));
    end

    coef = zeros(64,newhwlen(1)*newhwlen(2)/64);

    for i = 1:newhwlen(1)/8
        for j = 1:newhwlen(2)/8
            c = dct2(newimg(8*i-7:8*i,8*j-7:8*j)-128);
            c = round(c ./ QTAB);
            coef(:,(i-1)*newhwlen(2)/8+j) = c(zigzag(8));
        end
    end

    %% DC coef

    DC = coef(1,:);
    % DC = [10 8 60];
    Diff = zeros(size(DC));
    Diff(1) = DC(1);
    for i = 2:length(Diff)
        Diff(i) = DC(i-1) - DC(i);
    end
    Dc_ceof = [];
    Category_DC = ceil(log2(abs(Diff)+1));
    for i = 1:length(Category_DC)
        huff = DCTAB(Category_DC(i)+1, 2:1+DCTAB(Category_DC(i)+1,1));
        dc = Diff(i);
        if(dc==0)
            Dc_ceof = [Dc_ceof huff];
        else
            amp = dec2bin(abs(dc)) - '0';
            if(dc<0)
                amp = 1 - amp;
            end
            Dc_ceof = [Dc_ceof huff amp];
        end
    end

    %% AC coef
    AC = coef(2:64,:);
    % AC = [10 3 0 0 2 zeros(1,20) 1 zeros(1,37)]';
    Ac_ceof = [];

    for i = 1:size(AC,2);
        currentAC = AC(:,i);
        pos = find(currentAC~=0);
        if(~isempty(pos))
            previous = 1;
            for j = 1:length(pos)
                ac = currentAC(pos(j));
                run = pos(j)-previous;
                while(run>15)
                    Ac_ceof = [Ac_ceof 1 1 1 1 1 1 1 1 0 0 1];
                    run = run - 16;
                end
                amp = dec2bin(abs(ac)) - '0';
                if(ac<0)
                    amp = 1 - amp;
                end
                Huff = ACTAB(run*10+length(amp),4:ACTAB(run*10+length(amp),3)+3);
                Ac_ceof = [Ac_ceof Huff amp];
                previous = pos(j) + 1;
            end
        end
        Ac_ceof = [Ac_ceof 1 0 1 0];
    end
    height = newhwlen(1);
    width = newhwlen(2);
    CodeJepg = {Dc_ceof, Ac_ceof, height, width};