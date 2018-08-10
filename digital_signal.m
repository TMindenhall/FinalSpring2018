%Author: Thomas Mindenhall 
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Technology Dept.

close all; 
clear;
clc;
load data_2.mat t y %original signal

%INITIALIZE DIGITIZATION%
deltax = 2^(-(8));      %how many  bits/levels
deltaxMax = 1-deltax;   %peak level 
digital_s = [];         %create arrays for our digital values             
digital_time = [];
%fill the array with our values
for i=1:100:4001        
    digital_time = [digital_time,t(i)];
    digital_s = [digital_s,((y(i)+1)/2)*deltaxMax];
end

%NORMALIZE THE VALUES%
for i=1:41
    digital_s(i) = round(digital_s(i)/deltax); 
end


%CONVERT TO BINARY SIGNAL%
bit_stream = [];        %make a binary array
for i=1:41
     bit_stream = [bit_stream,dec2bin(digital_s(i),8)];
end
time_bit_stream(1:1000) = 1;
value_bit_stream = [];              %find the value of the bit stream
low=0*time_bit_stream;              %comparitors
high=1*time_bit_stream;
for i=1:328             %compare
    if bit_stream(i)=='1';
        value_bit_stream = [value_bit_stream,high];
    else
        value_bit_stream = [value_bit_stream,low];
    end
end

scatter(digital_time,digital_s);
title('Digital Sampling of our signal');
xlabel('Time [s]');
ylabel('Digital Level 0-255');



