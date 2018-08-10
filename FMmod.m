%Author: Thomas Mindenhall 
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Technology Dept.

close all; 
clc;
load data_2.mat t y %USE data_2.mat for exp form, Quad doesn't work


%INPUT PARAMETERS
fm = 1/0.01;                            % data signal frequency
fc = 20*fm;                             % carrier signal frequency
wc = 2*pi*fc;                            
Ac = 2.5;                               % carrier signal amplitude
carrier = Ac*(cos(wc*t));               % carrier signal
fDev = 1000;
beta = fDev/fm;                         % beta = 10

%MOD
data = cumtrapz(y)/fm;                  % integral of data signal (ranges from 0-2.5)
FMsig = Ac.*cos(wc*t+(beta.*data));     % modulated signal frequency ranges from 2000-2025.

%DEMOD
demodsig = diff(FMsig);                 % demodulation:
demodsig=[demodsig,demodsig(1,end)];
demodsig=demodsig/(2*pi*fm);
envel=abs(hilbert(demodsig));           %hilbert to find the envelope
dc=mean(envel);                         %find dc offset
envel=envel-dc;                         %take off dc
demod_scale=200;
envel=envel*demod_scale;
envel=envel*max(y)/max(envel);

%For the FFT signals
freq_y = fftshift(fft(y));
freq_carrier = fftshift(fft(carrier));
freq_mod = fftshift(fft(FMsig));
freqy = [-25*2000:25:25*2000];

%PLOTTING OUR RESULTS
figure(1)
subplot(4,1,1);                          % data signal plot
plot(t,y);                  
title('Input Data Signal')
xlabel('Time [s]');
ylabel('Voltage [V]');
grid on

subplot(4,1,2);                          % carrier signal plot
plot(t,carrier);               
title('Carrier Signal');
xlabel('Time [s]');
ylabel('Voltage [V]');
grid on

subplot(4,1,3);                          % modulated signal plot
plot(t,FMsig);                
title('Modulated Signal');  
xlabel('Time [s]');
ylabel('Voltage [V]');
grid on

subplot(4,1,4);                          % demodulated signal plot
plot(t,envel);                 
title('Demodulated Signal');
xlabel('Time [s]');
ylabel('Voltage [V]');
grid on

figure(2)
subplot(3,1,1)
plot(freqy,abs(freq_y));
axis([-.2e3 .2e3 0 2000])
title('Frequency Spectrum of Input')
xlabel('Freq [Hz]')
ylabel('Amplitude')

subplot(3,1,2)
plot(abs(freq_carrier));
axis([2000 2100 0 6000]);
title('Frequency Spectrum of Carrier');
xlabel('Freq [Hz]');
ylabel('Amplitude');
%title();

subplot(3,1,3)
plot(abs(freq_mod));
axis([1800 2200 0 1000]);
title('Frequency Spectrum of Modulated Signal');
xlabel('Freq [Hz]');
ylabel('Amplitude');