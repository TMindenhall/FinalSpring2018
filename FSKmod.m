%Author: Thomas Mindenhall 
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Technology Dept.

clear;
clc;
%using Exp formatting because we had problems with Quad in FM
load data_2.mat t y;    %our data file from analog EXP form

%INPUT PARAMETERS%
fm = 1/0.01;                            % data signal frequency
fc = 16000;  %breaks at <:> 16khz       % carrier signal frequency
wc = 2*pi*fc;                           % carrier signal rad frequency  
Ac = 2.5;                               % carrier signal amplitude
carrier = Ac*(cos(wc*t));               % carrier signal
fDev = 1000;
beta = fDev/fm;  

%INITIALIZE DIGITIZATION%
deltax = 2^(-(8));      %how many  bits/levels
deltaxMax = 1-deltax;   %peak level 
digital_s = [];         %create arrays for our digital values             
digital_time = [];
%fill the array with our digital values
for i=1:100:4001        
    digital_time = [digital_time,t(i)];
    digital_s = [digital_s,((y(i)+1)/2)*deltaxMax];
end


%truncate the values%

for i=1:41
    digital_s(i) = round(digital_s(i)/deltax); 
end
%put them in a string
bit_stream = [];        %make a binary array
for i=1:41
     bit_stream = [bit_stream,dec2bin(digital_s(i),8)];
end


%LETS MODULATE%
%pretty much the same as before
%Below is to use the proper freqency for the shift key
time_bit_stream(1:1000) = 1;
value_bit_stream = [];   %find the value of the bit stream
low=0*time_bit_stream;              %comparitors
high=1*time_bit_stream;
for i=1:328%000             %compare
    if bit_stream(i)=='1';
        value_bit_stream = [value_bit_stream,high];
    else
        value_bit_stream = [value_bit_stream,low];
    end
end

delta = 1.25e-7;
time_bits = 0:delta:1.25e-4-delta;
time_shift_key = 0:delta:0.041-delta;%this is to plot the final result
value = [];%array to store our analog value from the comparison
value_low=sin(2*pi*fc*time_bits);
value_high=sin(2*pi*fc*2*time_bits);
for i=1:328
    if bit_stream(i)=='1';
        value = [value,value_high];
    else
        value = [value,value_low];
    end
end


%NOW TO DEMOD%
%just copy/paste from FMmod.m with some minor tweaks
%Not as simple as ASK where we have our envelope

demodsig = diff(value);                     %take a derivitive                 
demodsig=[demodsig,demodsig(1,end)]; 
envel=abs(hilbert(demodsig));           %hilbert transform for the envl
dc=.0125;                              %DC offset
envel=envel-dc;                         %take off the dc                        
demod_scale=100;                         
envel=envel*demod_scale;
[b,a] = butter(10,0.25,'low');          %butterworth to filter 
x = (filtfilt(b,a,envel));


% We now have a string of bits new_bit_stream.
new_bit_stream = [];
for i=500:1000:327500
    new_bit_stream = [new_bit_stream,round(x(i))];
end

r_x=[];%Radix values
for i=1:41
    for n=1:8
        r_x = [r_x,num2str(new_bit_stream(8*(i-1)+n))];
    end
    m(i)=bin2dec(r_x);
    r_x = [];
end

return_signal = [];
 for i=1:41
     return_signal(i) = (m(i)/128)-1;
 end
 
 %PLOTTING OUR RESULTS%%
 subplot(4,1,1);                          % data signal plot
plot(t,y);                  
title('Input Data Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')
grid on

subplot(4,1,2);                          % carrier signal plot
plot(t,carrier);               
title('Carrier Signal')
axis([0 2e-3 -3 3])
xlabel('Time [s]')
ylabel('Voltage [V]')
grid on
%Because this is so large force our graph to display the first 2ms
subplot(4,1,3);                          % modulated signal plot
plot(time_shift_key,value); 
axis([0 2e-3 -2 2]);
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
 
 

