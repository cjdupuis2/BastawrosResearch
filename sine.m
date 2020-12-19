%% By: CJ Dupuis, Jake, and Bishoy
% This program is used to determine the distance between the two peaks in a
% fft of an overhead view of a corrigated sheet (sine waves). It also deals
% with the relationship between the distance between the two peaks when the
% wavelength of the original sine wave is deformed 

%% Cleaning command window
clc; clear; close all;

%% Variable to change
pixSize = 1024; %xy dimensions of image
wantedDist = 100; %wanted distance from center of fft to first peak
alpha = 0.1; %wanted stretch for deformed image in y dirrection in decimal form (0.1 = 10%)

%% Setting up sine wave and deformed sine wave
lambda = pixSize / wantedDist; %setting lambda to this will produce the wanted distance in pixels
lims  = [0 (pixSize - 1)]; %set up of sine curve
[y,x] = ndgrid(lims(1):lims(2),lims(1):lims(2));
ref = sin(2*pi*y/lambda); %setting the sine curve (reference image)

def = stretch(ref, alpha, pixSize); %producing the deformed image
def = clnhann(def); %adding hann filter to deformed image to reduce streaking

%% Images of corrigated sheet
% figure; surf(ref), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(ref,[]); xlabel('X'), ylabel('Y');
% figure; surf(def), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(def,[]); xlabel('X'), ylabel('Y');

%% FFT and scaling
refFFT = fft2(ref); 
refFFTLog = fftshift(log(1+abs(refFFT)));
defFFT = fft2(def);
defFFTLog = fftshift(log(1+abs(defFFT)));

xCenter = 513; %x coordinate center of fft
refYPeakPlus = xCenter + wantedDist; %y coordinate location of peak positive
refYPeakMinus = xCenter - wantedDist; %y coordinate location of peak minus
defYPeakPlus = xCenter + int32(wantedDist / (1+alpha)); %y coordinate location of peak positive in deformed
defYPeakMinus = xCenter - int32(wantedDist / (1+alpha)); %y coordinate location of peak minus in deformed

% figure, imshow(refFFTLog,[]); xlabel('X'), ylabel('Y');
% figure, imshow(defFFTLog,[]); xlabel('X'), ylabel('Y');

figure; hold; surf(refFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);
plot3(xCenter, refYPeakPlus, refFFTLog(refYPeakPlus, xCenter), 'r*') %this is the point where peak will be
plot3(xCenter, refYPeakMinus, refFFTLog(refYPeakMinus, xCenter), 'r*') %this is the point where peak will be
 
figure; hold; surf(defFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);
plot3(xCenter, defYPeakPlus, defFFTLog(defYPeakPlus, xCenter), 'r*') %this is the point where peak will be
plot3(xCenter, defYPeakMinus, defFFTLog(defYPeakMinus, xCenter), 'r*') %this is the point where peak will be

