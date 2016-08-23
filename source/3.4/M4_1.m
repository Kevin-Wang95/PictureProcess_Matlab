clear all; close all;

L = [3,4,5];

common_dir = dir('../../resource/Faces');

for i = length(common_dir):-1:1
    if(strcmp(common_dir(i).name, '.') || strcmp(common_dir(i).name, '..') ...
            || strcmp(common_dir(i).name, '.DS_Store'))
        common_dir(i) = [];
    end
end

for ii = 1:3
v = zeros(length(common_dir), 2^(3 * L(ii)));

for i = 1:length(common_dir)
    img = imread(['../../resource/Faces/' common_dir(i).name]);
    img = quantized_pic(img, L(ii));
    v(i,:) = get_feature(img, L(ii));
end
v_mean = mean(v, 1);
subplot(3,1,ii)
plot(1:length(v_mean),v_mean);
end
save features.mat v_mean
saveas(gcf, 'L_from_three_to_five.bmp');