%Author: Thomas Mindenhall 
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Technology Dept.

clear;
clc;
%using Exp formatting because we had problems with Quad in FM
load data_2.mat t y;    %our data file from analog EXP form


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
fc = 16000;                 %Carrier Freq
delta = 1.25e-7;            %Step Levels
fm = 1/0.01;                %Mod Freq
fs=328000/.041;             %Sample Size
carrier = cos(2*pi*fc.*t);

%Times for bit stream
time_per_bit = 0:delta:1.25e-4-delta;
time_shift_key = 0:delta:0.041-delta

%NORMALIZE THE VALUES%

for i=1:41
    digital_s(i) = round(digital_s(i)/deltax); 
end


%CONVERT TO BINARY SIGNAL%

bit_stream = [];        %make a binary array
for i=1:41
     bit_stream = [bit_stream,dec2bin(digital_s(i),8)];
end
%Parameters for bit stream
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

%Parameters to modulate
value = [];
value_low=sin(2*pi*fc*time_per_bit+pi);
value_high=sin(2*pi*fc*time_per_bit);
%TIME TO MODULATE%
for i=1:328
    if bit_stream(i)=='1';
        value = [value,value_high];
    else
        value = [value,value_low];
    end
end


%DEMOD%
%start and array to hold the imbedded sin with mod signal
demod_sin=[];
for i =1:328
    %Make a Sine Signal to multiply
    demod_sin = [demod_sin,sin(2*pi*fc*time_per_bit)];
end

vprime = value.*demod_sin;%Multiply
demod_signal = vprime+1/2;  %Normilize
%Butterworth our signal like in AM/ASK
[b,a] = butter(7,fc*2/fs,'low');
%Filter our Signal
vdem  = filtfilt(b,a,demod_signal).*(1.4);
%Time for our new bit stream to convert back to analog
demod_bit_stream = [];
for i=500:1000:327500
    demod_bit_stream = [demod_bit_stream,round(vdem(i).*-1)];
    
end
%somehow getting negative 2? Lets fix this
for i=1:328
    if demod_bit_stream(i) == -2 
        demod_bit_stream(i) = 1;
    else
        demod_bit_stream(i) = demod_bit_stream(i);
    end
end
%new bit stream is filled with zeros look above
new_bit_stream = [];
for i=1:328
    if demod_bit_stream(i) == 1
        new_bit_stream = [new_bit_stream,high];
    else
        new_bit_stream = [new_bit_stream,low];
    end
end
% we now have a signal representing the bit string new_bit_stream

r_x=[];%DONT CALL RADIX IT BREAKS THE CODE
for i=1:41
    for n=1:8
        r_x = [r_x,num2str(new_bit_stream(8*(i-1)+n))];%trying the same as others
    end
    m(i)=bin2dec(r_x);
    r_x = [];%clear the radix
end

return_signal = [];
 for i=1:41
    % m(i) = m(i)*(.0078125);
     return_signal(i) = (m(i)/128)-1;
 end
 
 %PLOTTING OUR RESULTS%%
 subplot(4,1,1)
 plot(t,y)
 title('Input Signal')
 xlabel('Time [s]')
 ylabel('Voltage [V]')
 
 subplot(4,1,2)
 plot(t,carrier)
 axis([0 2e-3 -2 2])
 title('Carrier Signal')
 xlabel('Time [s]')
 ylabel('Voltage [V]')
 
 subplot(4,1,3)
 plot(time_shift_key,value);
 title('Modulated Signal')
 axis([0 2.00e-3 -1 1]); %becaue our signal is so large
 xlabel('Time [s]')
 ylabel('Voltage [V]')
 
 subplot(4,1,4)
 plot(t,y)
 title('Demod Signal')
 xlabel('Time [s]')
 ylabel('Voltage [V]')
 
 