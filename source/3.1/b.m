clear all; close all;
load hall.mat
len = size(hall_color);
temp_hall = im2double(hall_color);

for i = 1:len(1)/3
    for j = 1:len(2)/3
        if(mod(i+j,2))
            temp_hall(3*i-2:3*i,3*j-2:3*j,1:3)=0;
        end
    end
end

imshow(im2uint8(temp_hall));
imwrite(im2uint8(temp_hall), 'b.jpg');