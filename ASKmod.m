%Author: Thomas Mindenhall 
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Technology Dept.

clear;
clc;

%using Exp formatting because it has been working well for digital
load data_2.mat t y;    %our data file from analog EXP form


%INITIALIZE DIGITIZATION%
deltax = 2^(-(8));      %how many  bits/levels
deltaxMax = 1-deltax;   %peak level 
digital_s = [];         %create arrays for our digital values             
digital_time = [];
fc = 16000;                 %Carrier Freq (Cant use 10khz for digital)
delta = 1.25e-7;            %Step Levels
fm = 1/0.01;                %Mod Freq and T0
fs=328000/.041;             %Sample Size
carrier = cos(2*pi*fc*t);   %Carrier Signal
delta = 1.25e-7;
time_bit_stream = 0:delta:1.25e-4-delta;
time_shift_key = 0:delta:0.041-delta;
value_bit = [];
value_bit_low=1*sin(2*pi*fc*time_bit_stream);%sin(wt)
value_bit_high=2*sin(2*pi*fc*time_bit_stream);%2sin(wt)

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


for i=1:328%000
    if bit_stream(i)=='1';
        value_bit = [value_bit,value_bit_high];
    else
        value_bit = [value_bit,value_bit_low];
    end
end

demod_bit_stream = [];
for i = 126:1000:327126
    if value_bit(i)==1
        demod_bit_stream = [demod_bit_stream,0];
    else
        demod_bit_stream = [demod_bit_stream,1];
    end
end

% we now have a demodulated bit string demod_bit_stream
value_demod_bit_stream = [];
for i=1:328
    if demod_bit_stream(i)==1;
        value_demod_bit_stream = [value_demod_bit_stream,high];
    else
        value_demod_bit_stream = [value_demod_bit_stream,low];
    end
end

% we now have a signal representing the bit string value_demod_bit_stream
r_x=[];
for i=1:41
    for n=1:8
        r_x = [r_x,num2str(demod_bit_stream(8*(i-1)+n))];
    end
    m(i)=bin2dec(r_x);
    r_x = [];
end
%Final Signal
return_signal = [];
 for i=1:41
     return_signal(i) = (m(i)/128)-1;%128 = 2^n \ 2
 end
%PLOTTING THE RESULTS%%
subplot(4,1,1)
plot(t,y);
title('Input Signal');
xlabel('Time [s]')
ylabel('Voltage [V]')

subplot(4,1,2)
plot(t,carrier)
title('Carrier Signal')
axis([0 2e-3 -5 5])
xlabel('Time [s]')
ylabel('Voltage [V]')

subplot(4,1,3)
plot(time_shift_key,value_bit);
axis([0 2e-3 -2 2]);
title('Modulated Signal');
xlabel('Time [s]');
ylabel('Voltage [V]');

subplot(4,1,4)
plot(digital_time,return_signal)
title('Demod Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')
