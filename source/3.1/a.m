clear all; close all;
load hall.mat
r = floor(min(size(hall_color(:,:,1)))/2);
center = floor(size(hall_color)/2);
temp_hall = im2double(hall_color);
for i = center(1)-r+1:1:center(1)+r
    for j = 1:size(hall_color(:,:,1),2)
        if((i - center(1))^2 + (j - center(2))^2 <= r^2)
            temp_hall(i,j,1)=255;
            temp_hall(i,j,2)=0;
            temp_hall(i,j,3)=0;
        end
    end
end

imshow(im2uint8(temp_hall));
imwrite(im2uint8(temp_hall), 'a.jpg');