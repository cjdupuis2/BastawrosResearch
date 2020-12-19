%%
clc; clear; close all;

pixSize = 1024;
wantedDist = 100;
alpha = 0.1;

lambda = pixSize / wantedDist;
lims  = [0 (pixSize - 1)];
[y,x] = ndgrid(lims(1):lims(2),lims(1):lims(2));
ref = sin(2*pi*y/lambda);
def = stretch(ref, alpha, pixSize);
def = clnhann(def);

% figure; surf(ref), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(ref,[]); xlabel('X'), ylabel('Y');
% figure; surf(def), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(def,[]); xlabel('X'), ylabel('Y');

%%
refFFT = fft2(ref);
refFFTLog = fftshift(log(1+abs(refFFT)));
defFFT = fft2(def);
defFFTLog = fftshift(log(1+abs(defFFT)));

a = 513;
aP = a + wantedDist;
aM = a - wantedDist;
aPD = a + int32(wantedDist / (1+alpha));
aMD = a - int32(wantedDist / (1+alpha));

% figure, imshow(refFFTLog,[]); xlabel('X'), ylabel('Y');
% figure, imshow(defFFTLog,[]); xlabel('X'), ylabel('Y');

figure; hold; surf(refFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);
plot3(a, aP, refFFTLog(aP, a), 'r*')
plot3(a, aM, refFFTLog(aM, a), 'r*')
 
figure; hold; surf(defFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);
plot3(a, aPD, defFFTLog(aPD, a), 'r*')
plot3(a, aMD, defFFTLog(aMD, a), 'r*')

