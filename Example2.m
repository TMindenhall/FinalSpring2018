%Author: Thomas Mindenhall 
%May 2 2018 
%Metropolitan State University of Denver
%Electrial Engineering Technology Dept.

%This builds the Quad Signal
%NOTE: This has a large build time because of the formatting, however the
%signal looks good so all is well.
clear; clc;
syms t v_t;

%----Parameters------
n = 10;%number of iterations in the series
T0 = .01;%Period
w = 2*pi*(1/T0);%radian freq

%----Signal Build-----------
v_t=((5/4)*t*heaviside(t)-(25/4)*(t-.004)*heaviside(t-.004)+(15/4)*(t-.005)*heaviside(t-.005)+(25/4)*(t-.009)*heaviside(t-.009));

%t = linspace(0,.03,1000);
%plot(t,eval(v_t),'b');


%-----Integration-------------
for k=1:n
A(k) = (2/T0)*(int((v_t)*cos((w*k*t)),t,[0,T0]));
B(k) = (2/T0)*(int((v_t)*sin((w*k*t)),t,[0,T0]));    
end

%----Time Define------------
Final = 0;
t= linspace(0,.03,15000);%define our limit for t and # of steps

%----Quadrature Form---------
for k=1:n
 Final = Final + eval(A(k)*cos(w*k*t)+B(k)*sin(w*k*t));   
end 

%----Eval----------
y= eval(v_t);

%-----Plots--------
plot(t,Final,'r');hold on;
plot(t,y,'b');
grid;shg;

save 'data.mat' t Final T0;