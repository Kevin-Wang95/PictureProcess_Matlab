clear all; close all;

load hall.mat
load jpegcodes.mat

ratio = size(hall_gray,1)*size(hall_gray,2)*8/length([Dc_ceof Ac_ceof])