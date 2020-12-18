%%
clc; clear; close all;

pixSize = 1024; 
wantedDist = 10; %THE WANTED DISTANCE AND ALPHA ARE THE IMPORTANT VARIBABLES TO CHANGE
alpha = 0.1;

a = pixSize / wantedDist;
freq = 2*pi / a;
lims  = [0 pixSize - 1];
[y,x] = ndgrid(lims(1):lims(2),lims(1):lims(2));
%phase = pi/2;
%xp = y*sin(phase);
ref = sin(freq*y);
def = stretch(ref, alpha, pixSize);
%def = clnhann(def); If you want, this is just hann filter on the deformed to make it cleaner. I wrote a function to make easier

% figure; surf(ref), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(ref,[]); xlabel('X'), ylabel('Y');
% figure; surf(def), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(def,[]); xlabel('X'), ylabel('Y');

%%
refFFT = fft2(ref);
refFFTLog = fftshift(log(1+abs(refFFT)));
defFFT = fft2(def);
defFFTLog = fftshift(log(1+abs(defFFT)));

a = 513; %All of these a's are just to plot the red points, you can comment out these and the plot3() lines to just see the graphs
aP = a + wantedDist;
aM = a - wantedDist;
aPS = a + wantedDist * (1 - alpha);
aMS = a - wantedDist * (1 - alpha);

% figure, imshow(refFFTLog,[]); xlabel('X'), ylabel('Y');
% figure, imshow(defFFTLog,[]); xlabel('X'), ylabel('Y');

figure; hold; surf(refFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);
plot3(a, aP, refFFTLog(aP, a), 'r*')
plot3(a, aM, refFFTLog(aM, a), 'r*')
 
figure; hold; surf(defFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);
 plot3(a, aPS, defFFTLog(aPS, a), 'r*')
 plot3(a, aMS, defFFTLog(aMS, a), 'r*')

