%Author: Thomas Mindenhall and Austin Fagen
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Technology Dept.

close; 
clear;
syms t k

%Parameters
j=sqrt(-1);
T=0.01;
alpha=1;
w0=2*pi*1/T;

%Bounds
UpperA = 0+t*2.5/T;
UpperB = -1+(t-9/10*T)*10/T;
LowerA = 1-(t-4/10*T)*10/T;
LowerB = 0-(t-5/10*T)*2.5/T;

%Integration
Ck=(1/T)*int(UpperA*exp(-j*k*w0*t),t,0,4/10*T);
Ck=Ck+(1/T)*int(LowerA*exp(-j*k*w0*t),t,4/10*T,5/10*T);
Ck=Ck+(1/T)*int(LowerB*exp(-j*k*w0*t),t,5/10*T,9/10*T);
Ck=Ck+(1/T)*int(UpperB*exp(-j*k*w0*t),t,9/10*T,T);

%Lets make the series
xmin = -2*T;
xmax = 2*T;
t=linspace(xmin,xmax,4001);
num = 500;
x = zeros(size(t));
for k = -(num):num
    if k ~= 0
         x = x+(eval(char(Ck)))*exp(j*alpha*w0*k*t);
    end
end
y = x;

%Plot our results
plot(t,x);
axis([xmin xmax -1.1 1.1]);
title('Signal Generated');
xlabel('Time [s]');
ylabel('Amplitude [V]');
grid on;

y=real(y);
save 'data_2.mat' t y