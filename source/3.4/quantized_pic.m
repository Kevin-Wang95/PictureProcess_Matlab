function quantized_img = quantized_pic(img, L)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    decrease = 8 - L;
    
    quantized_img = floor(double(img)/2^decrease);
    quantized_img = quantized_img(:,:,1) * 2^(2 * L) + quantized_img(:,:,2) ...
        * 2^L + quantized_img(:,:,3);
    quantized_img = uint32(quantized_img(:,:,1));
    
end

