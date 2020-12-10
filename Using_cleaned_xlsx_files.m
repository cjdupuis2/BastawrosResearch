% By CJ Dupuis + some stuff from Bishoy 

% You need folder named ToAverage in working dirrectory.
% Put all reference jpg files here

% You need folder named Deformed in working dirrectory.
% Put the 1 deformed jpg file here
clear; clc; close all;

%---TO CHANGE
directory = 'C:\Users\gurwo\Desktop\JakeJake\'; %pwd NEED TO CHANGE THIS TO YOUR DIRRECTORY
pixSize = 1024; % (Jake this dosent need to change rn, but maybe in future)
h_r_S=0.1; 
h_r_ul=0.1; 

%---DON'T NEED TO CHANGE
%---Get the image data of the references from ToAverage folder
refDir = dir([directory 'ToAverage/*.xlsx']);
numRef = length(refDir);
refNames = strings(numRef, 1);
refImgsData = zeros(pixSize, pixSize, numRef); %This will contain the jpg data
refFFTs = zeros(pixSize, pixSize, numRef)

for i = 1:numRef
    refNames(i) = [directory 'ToAverage/' refDir(i).name]; %Absolute file path
    refImgsData(:,:,i) = xlsread(refNames(i));
    
    %Han filter for the each of images 
    [wx,wy]=size(refImgsData(:,:,i));
    mw = mean(mean(refImgsData(:,:,i)));
    refImgsData(:,:,i) = refImgsData(:,:,i) - mw;
    W=taphann2drect(wx,wy,h_r_S,h_r_ul);
    refImgsData(:,:,i)=refImgsData(:,:,i).*W;
end

% ---Get the image data of the deformed from Deformed folder
defDir = dir([directory 'Deformed/*.xlsx']);
defData = xlsread([directory 'Deformed/' defDir.name]);

%han filter for def data.
[dwx,dwy]=size(defData);
dmw = mean(mean(defData));

defData = defData - dmw;
dW=taphann2drect(dwx,dwy,h_r_S,h_r_ul);
defData=defData.*dW;

% ---Take FFT's, average, and scale
refFFTs = fft2(refImgsData);

sum = zeros(pixSize, pixSize);
for i = 1:numRef
    sum = refFFTs(:,:,i) + sum;
end
avgRefFFT = sum ./ numRef; %I average AFTER FFT, I am not sure if I should avg before or after
avgRefFFTScaled = fftshift(log(1+abs(avgRefFFT)));
conav = conj(avgRefFFT);

defFFT = fft2(defData);
defFFTScaled = fftshift(log(1+abs(defFFT)));
conde = conj(defFFT);

H1 = avgRefFFT.*conde;
% H2 = defFFT.*conav;
% H1scaled = fftshift(log(1+abs(H1)));
% H2scaled = fftshift(log(1+abs(H2)));
J1 = abs(avgRefFFT.* defFFT);
J3 = J1.^0.5;
H3 = H1./J3;
G3 = fft2(H3);
H3scaled = fftshift(log(1+abs(H3)));
G3scaled = fftshift(log(1+abs(G3)));


% H4 = H1./J1;
% H4scaled = fftshift(log(1+abs(H4)));
% J5 = J1.^0.75;
% J6 = J1.^0.25;
% H5 = H1./J5;
% H6 = H1./J6;
% H5scaled = fftshift(log(1+abs(H5)));
% H6scaled = fftshift(log(1+abs(H6)));

% ---Now take the difference of average reference and deformed using 1st method
dif1 = avgRefFFTScaled-defFFTScaled; %I used the scaled, should I instead minus the complex numbers then scale?

inv = ifft2(avgRefFFT);

% ---Now take the difference of average reference and deformed using 2nd method
Ar = double(real(avgRefFFT));
Br = double(real(defFFT));
Ai = double(imag(avgRefFFT));
Bi = double(imag(defFFT));
dif2 = sqrt((Ar - Br).^2 + (Ai - Bi).^2);
dif2 = fftshift(log(1+abs(dif2)));

dif3 = defFFTScaled-avgRefFFTScaled;


% ---Display Plots
% figure(1);
% imshow(avgRefFFTScaled, []);
% title('Averaged References Spectrum Image', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure(2);
% imshow(defFFTScaled, []);
% title('Sample 5', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure(3);
% imshow(dif1, []);
% title('Method 1 Difference Spectrum Image', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure(4);
% imshow(dif2, []);
% title('Method 2 Difference Spectrum Image', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure(5);
% imshow(dif3, []);
% title('Method 1-2 Difference Spectrum Image', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure 6 for inverse fft of average FFT
figure(6);
imshow(inv, []);
title('Inverse FFT of average fft', 'FontSize', 10, 'Interpreter', 'None');

% figure(7);
% imshow(H1scaled, []);
% title('H1', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);
% 
% figure(8);
% imshow(H2scaled, []);
% title('H2', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure(9);
% imshow(H3scaled, []);
% title('H3 (a = 0.5)', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure(10);
% imshow(H4scaled, []);
% title('H4 (a = 0)', 'FontSize', 10, 'Interpreter', 'None');

% figure(11);
% imshow(H5scaled, []);
% title('H5 (a = 0.25)', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure(12);
% imshow(H6scaled, []);
% title('H6 (a = 0.75)', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);

% figure(13);
% imshow(G3scaled, []);
% title('G3', 'FontSize', 10, 'Interpreter', 'None');
% colormap(jet);
