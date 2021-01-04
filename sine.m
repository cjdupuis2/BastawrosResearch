%% By: CJ Dupuis, Jake, and Bishoy
% This program is used to determine the distance between the two peaks in a
% fft of an overhead view of a corrigated sheet (sine waves). It also deals
% with the relationship between the distance between the two peaks when the
% wavelength of the original sine wave is deformed 

%% Cleaning command window
clc; clear; close all;

%% Variable to change
pixSize = 1024; %xy dimensions of image
lambda = 1024/10; %waned distance from center of fft to first peak
deformation = 0.01; %wanted stretch for deformed image in y dirrection in decimal form (0.1 = 10%)
alpha = 0.05;

%% Setting up sine wave and deformed sine wave
lims  = [0 (pixSize - 1)]; %set up of sine curve
[y,x] = ndgrid(lims(1):lims(2),lims(1):lims(2));
ref = sin(2*pi*y/lambda); %setting the sine curve (reference image)
def = sin(2*pi*y/(lambda * (1+deformation))); %producing the deformed image
% def = imresize(ref,[floor(pixSize*(1+deformation)) pixSize]);
% def = def(1:pixSize,1:pixSize);

ref = clnhann(ref);
def = clnhann(def); %adding hann filter to deformed image to reduce streaking

% figure; surf(ref), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(ref,[]); xlabel('X'), ylabel('Y');
% figure; surf(def), shading flat, colormap(gray), xlabel('X'), ylabel('Y'), zlabel('Z');
% figure, imshow(def,[]); xlabel('X'), ylabel('Y');
%% FFT and scaling
refFFT = fft2(ref); 
refFFTLog = fftshift(log(1+abs(refFFT)));
defFFT = fft2(def);
defFFTLog = fftshift(log(1+abs(defFFT)));

% figure, imshow(refFFTLog,[]); xlabel('X'), ylabel('Y') ; title("Ref FFT: Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100) + "%");
% figure, imshow(defFFTLog,[]); xlabel('X'), ylabel('Y') ; title("Def FFT: Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100) + "%");


% xCenter = 513; %x coordinate center of fft
% refYPeakPlus = xCenter + wantedDist; %y coordinate location of peak positive
% refYPeakMinus = xCenter - wantedDist; %y coordinate location of peak minus
% defYPeakPlus = xCenter + int32(wantedDist / (1+deformation)); %y coordinate location of peak positive in deformed
% defYPeakMinus = xCenter - int32(wantedDist / (1+deformation)); %y coordinate location of peak minus in deformed

% figure; plot(refFFTLog(:,513)); title("2D Cut of Ref FFT at x = 513: Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100) + "%")
% figure; hold; surf(refFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0); title("Reference FFT");
% plot3(xCenter, refYPeakPlus, refFFTLog(refYPeakPlus, xCenter), 'r*') %this is the point where peak will be
% plot3(xCenter, refYPeakMinus, refFFTLog(refYPeakMinus, xCenter), 'r*') %this is the point where peak will be

% figure; plot(defFFTLog(:,513)); title("2D Cut of Def FFT at x = 513: Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100) + "%")
% figure; hold; surf(defFFTLog);shading flat; colormap(jet);  xlabel('X'), ylabel('Y'), zlabel('Z'); view(90,0);
% plot3(xCenter, defYPeakPlus, defFFTLog(defYPeakPlus, xCenter), 'r*') %this is the point where peak will be
% plot3(xCenter, defYPeakMinus, defFFTLog(defYPeakMinus, xCenter), 'r*') %this is the point where peak will be
%% Bastawros
F2 = refFFT .* conj(defFFT);
% F2Log = fftshift(log(1+abs(F2)));
% 
% figure; surf(F2Log); shading flat; colormap(jet); title("refFFT .* conj(defFFT): Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100));
% figure; plot(refFFTLog(:,513)); title("Ref: Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100) + "%"); xlim([312 712]), ylim([0 30]);
% figure; plot(defFFTLog(:,513)); title("Def: Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100) + "%"); xlim([312 712]), ylim([0 30]);
% figure; plot(F2Log(:,513)); title("refFFT .* conj(defFFT) with: Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100) + "%"); xlim([312 712]), ylim([0 30]);
% 
% 
F2FFT = fft2(F2);
F2FFTLog = fftshift(log(1+abs(F2FFT)));
% figure; surf(F2FFTLog); shading flat; colormap(jet); title("FFT(refFFT .* conj(defFFT)) with " + num2str(deformation*100) + "% deformation"); 
% xlabel('X'), ylabel('Y'), zlabel('Z');
% figure; plot(F2FFTLog(:,513)); title("FFT(refFFT .* conj(defFFT)): Lambda = " + num2str(lambda) + ", Deformation = " + num2str(deformation*100));
% xlabel('Y'), ylabel('Z');

figure; xlabel('Y'), ylabel('Z');

%% ANIMATION CODE (FIRST CHUNK CHANGES ALPHA, SECOND CHANGES LAMBDA)
for i = 1:40
   alpha = 0.01 + i*(0.001);
   def = sin(2*pi*y/(lambda * (1+alpha)));
   def = clnhann(def);
   defFFT = fft2(def);
   F2 = refFFT .* conj(defFFT);
   F2FFT = fft2(F2);
   F2FFTLog = fftshift(log(1+abs(F2FFT)));
   plot(F2FFTLog(:,513));
   ylim([20 27]);
   title(num2str(alpha * 100));
   pause(0.01);
end

% for i = 1:40
%    lambda = 1024/10 + i*(1);
%    ref = sin(2*pi*y/lambda);
%    def = sin(2*pi*y/(lambda * (1+alpha)));
%    ref = clnhann(ref);
%    def = clnhann(def);
%    refFFT = fft2(ref);
%    defFFT = fft2(def);
%    F2 = refFFT .* conj(defFFT);
%    F2FFT = fft2(F2);
%    F2FFTLog = fftshift(log(1+abs(F2FFT)));
%    plot(F2FFTLog(:,513));
%    ylim([20 27]);
%    title(num2str(lambda));
%    pause(0.01);
% end

% test = fft2(F2FFT);
% testLog = fftshift(log(1+abs(test)));
% figure; plot(testLog(:,513)); title("FFT(FFT(refFFT .* conj(defFFT))) with " + num2str(deformation*100) + "% deformation");
% xlabel('Y'), ylabel('Z');

%% Chiang
% F = refFFT .* conj(defFFT) ./ (abs(refFFT .* defFFT)).^(1-alpha);
% G = fft2(F);
% FLog = fftshift(log(1+abs(F)));
% GLog = fftshift(log(1+abs(G)));
% surf(FLog); shading flat; colormap(jet); view(90,0); title("refFFT .* conj(defFFT) ./ (abs(refFFT .* defFFT)).\^(1-alpha) with " + num2str(deformation*100) + "% deformation and alpha =" + alpha);
% figure; plot(FLog(:,513)); title("refFFT .* conj(defFFT) ./ (abs(refFFT .* defFFT)).\^(1-alpha) with " + num2str(deformation*100) + "% deformation and alpha =" + alpha);
% surf(GLog); shading flat; colormap(jet);


