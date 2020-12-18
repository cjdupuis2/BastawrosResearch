%%
clc; clear; close all;

pixSize = 1024;
wantedDist = 10;

a = pixSize / wantedDist;
freq = 2*pi / a;
lims  = [0 pixSize - 1];
[y,x] = ndgrid(lims(1):lims(2),lims(1):lims(2));
%phase = pi/2;
%xp = y*sin(phase);
ref = sin(freq*y);
def = stretch(ref,0.2,1024);

% figure; surf(ref), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(ref,[]); xlabel('X'), ylabel('Y');
% figure; surf(def), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(def,[]); xlabel('X'), ylabel('Y');

%%
refFFT = fft2(ref);
refFFTLog = fftshift(log(1+abs(refFFT)));
defFFT = fft2(def);
defFFTLog = fftshift(log(1+abs(defFFT)));

% figure, imshow(refFFTLog,[]); xlabel('X'), ylabel('Y');
% figure, imshow(defFFTLog,[]); xlabel('X'), ylabel('Y');
 figure; surf(refFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);
 figure; surf(defFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);

