close all; clear all;

load features.mat

L = 5; 
T = 0.78;
square_length = 10;
move_length = 2;

img = imread('sample2.jpg');
img = imrotate(img, 90);
count = 1;
for i = 1:move_length:size(img,1) - square_length
    for j = 1:move_length:size(img,2) - square_length
        sample_img = img(i:i+square_length-1,j:j+square_length-1,:);
        sample_img = quantized_pic(sample_img,  L);
        v = get_feature(sample_img, L);
        temp_dis = mydistance(v, v_mean);
        if(temp_dis < T)
            sample(count).i = i;
            sample(count).j = j;
            sample(count).dis = temp_dis;
            count = count + 1;
        end
    end
end

D = extractfield(sample, 'dis');
[D_sort, D_order] = sort(D);

selected_pos(1).i = sample(D_order(1)).i;
selected_pos(1).j = sample(D_order(1)).j;

for k = 2:length(sample)
    flag = true;
    for p = 1:length(selected_pos)
        if(abs(sample(D_order(k)).i-selected_pos(p).i)<square_length && ...
                abs(sample(D_order(k)).j-selected_pos(p).j)<square_length)
            flag = false;
        end
    end
    if(flag)
        i = sample(D_order(k)).i;
        j = sample(D_order(k)).j;
        selected_pos(length(selected_pos)+1).i = sample(D_order(k)).i;
        selected_pos(length(selected_pos)).j = sample(D_order(k)).j;
        img(i:i+square_length-1,j,1:3) = uint8(255);
        img(i:i+square_length-1,j+square_length-1,1:3) = uint8(255);
        img(i,j:j+square_length-1,1:3) = uint8(255);
        img(i+square_length-1,j:j+square_length-1,1:3) = uint8(255);
%         imshow(img);
    end
end


imshow(img)
saveas(gcf, 'rotation.bmp');