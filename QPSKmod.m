%Author: Thomas Mindenhall 
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Dept Technology.
clear;
clc;

%using Exp formatting because it has been working well for digital
load data_2.mat t y;    %our data file from analog EXP form


%INITIALIZE DIGITIZATION%
deltax = 2^(-(8));      %how many  bits/levels
deltaxMax = 1-deltax;   %peak level 
digital_s = [];         %create arrays for our digital values             
digital_time = [];
fc = 10000;                 %Carrier Freq (Cant use 10khz for digital)
delta = 1.25e-7;            %Step Levels
fm = 1/0.01;                %Mod Freq and T0
fs=328000/.041;             %Sample Size
carrier = 2*pi*fc*t;

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
delta = 1.25e-7;
time_bit_stream = 0:delta:1.25e-4-delta;
time_shift_key = 0:delta:0.041-delta;
value_bit = [];
arg=2*pi*fc*time_bit_stream;
v0=cos(arg+.5*pi);
v1=cos(arg-.5*pi);
for i=1:328%000
    if bit_stream(i)=='1';
        value_bit = [value_bit,v1];
    else
        value_bit = [value_bit,v0];
    end
end
%
%DEMOD% %I TRIED TO DEMOD LIKE BPSK AS IT SEEM MOST FITTING%
%start and array to hold the imbedded sin with mod signal
demod_sin=[];

 
 %PLOTTING OUR RESULTS%%
 subplot(2,1,1);                          % data signal plot
plot(t,y);                  
title('Input Data Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')
grid on

subplot(4,1,2);                          % carrier signal plot
plot(t,carrier);               
title('Carrier Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')
grid on

%Because this is so large force our graph to display the first 2ms
subplot(2,1,2);                          % modulated signal plot
plot(time_shift_key,value_bit); 
axis([0 1.5e-3 -1.5 1.5]);
title('Modulated Signal') 
xlabel('Time [s]')
ylabel('Voltage [V]')
grid on

subplot(4,1,4);                          % demodulated signal plot
plot(digital_time,return_signal); 
axis([-20e-3 20e-3 -1 1]);
title('Demodulated Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')
grid on


