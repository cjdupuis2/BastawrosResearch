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
% defData = temp(:,:,2);

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

defFFT = fft2(defData);
defFFTScaled = fftshift(log(1+abs(defFFT)));

% ---Now take the difference of average reference and deformed using 1st method
dif1 = avgRefFFTScaled - defFFTScaled; %I used the scaled, should I instead minus the complex numbers then scale?

% ---Now take the difference of average reference and deformed using 2nd method
Ar = double(real(avgRefFFT));
Br = double(real(defFFT));
Ai = double(imag(avgRefFFT));
Bi = double(imag(defFFT));
dif2 = sqrt((Ar - Br).^2 + (Ai - Bi).^2);
dif2 = fftshift(log(1+abs(dif2)));

% ---Display Plots
figure(1);
imshow(avgRefFFTScaled, []);
title('Averaged References Spectrum Image', 'FontSize', 10, 'Interpreter', 'None');

figure(2);
imshow(defFFTScaled, []);
title('Deformed Spectrum Image', 'FontSize', 10, 'Interpreter', 'None');

figure(3);
imshow(dif1, []);
title('Method 1 Difference Spectrum Image', 'FontSize', 10, 'Interpreter', 'None');

figure(4);
imshow(dif2, []);
title('Method 2 Difference Spectrum Image', 'FontSize', 10, 'Interpreter', 'None');
