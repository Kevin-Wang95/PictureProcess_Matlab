clear all; close all;

load hall.mat
load jpegcodes.mat

ratio = size(hall_gray,1)*size(hall_gray,2)*8/length([Dc_ceof Ac_ceof])

% Ac_coef 1*23072
% Dc_coef 1*2031
% hall_gray 120*168
% ratio = 6.4247