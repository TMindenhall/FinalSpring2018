%Author: Thomas Mindenhall 
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Technology Dept.

clear;
clc;
load data.mat;      %Our Orginal Signal imported

%PARAMTERS
fs = 10000;                                     % sample size
f = 1/T0;                                       % signal frequency
fc = 5*10^3;                                    % carrier frequency
wc = 2*pi*fc;                                   % carrier rad freqency


%MODULATION
%for signal conditioning
source = Final +.005;                           %data signal with dc off
Ac = 2.5;                                       % carrier amplitude
m =.5;
carrier = Ac*(cos(wc*t));                       % carrier signal
carrier_freq = Ac*cos(fc.*t);
data = source;                                  % source signal
modsig = (1+m)*data.*carrier;                   % modulated signal



%DEMODDING
modsig_2 = modsig.*carrier;                     %mod^2
Wn = fc/(20*fs);                                %weight
[b,a] = butter(10,Wn,'low');                    %demod
resig = (filtfilt(b,a,modsig_2)-.025)/Ac;       %lowpass filter

%For FFT
freq_y = fftshift(fft(Final));
freq_carrier = fftshift(fft(carrier_freq));
freq_mod = fftshift(fft(modsig));
freqy = [-33*7500:33.0001:33*7500];
freqfix = [-404*7500:404.02:404*7500];

%PLOTTING OUR RESULTS
figure(1)
subplot(4,1,1);
plot(t,Final);
title('Input Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')

subplot(4,1,2);
plot(t,cos(fc.*t));
title('Carrier Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')

subplot(4,1,3);
plot(t,modsig);
title('Modulated Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')

subplot(4,1,4);
plot(t,resig);
title('Demod Signal')
xlabel('Time [s]')
ylabel('Voltage [V]')

figure(2)
subplot(4,1,1)
plot(freqy,abs(freq_y));
axis([-.2e3 .2e3 0 35])
title('Frequency Spectrum of Input')
xlabel('Freq [Hz]')
ylabel('Amplitude')

subplot(4,1,2)
plot(freqfix,abs(freq_carrier));
axis([0 15000 0 20000]);
title('Frequency Spectrum of Carrier');
xlabel('Freq [Hz] Centered at 10kHz');
ylabel('Amplitude');
%title();

subplot(4,1,3)
plot(freqfix,abs(freq_mod));
axis([50000 70000 0 150]);
title('Frequency Spectrum of Modulated Signal SSB+');
xlabel('Freq [Hz]');

subplot(4,1,4)
plot(freqfix,abs(freq_mod));
title('Frequency Spectrum of Modulated Signal DSB')
axis([-1e5 1e5 0 150]);
xlabel('Freq [Hz]');
