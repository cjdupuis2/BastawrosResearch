% By CJ Dupuis + some stuff from Bishoy 

% You need folder named ToAverage in working dirrectory.
% Put all reference jpg files here

% You need folder named Deformed in working dirrectory.
% Put the 1 deformed jpg file here
clear; clc; close all;

%% TO CHANGE
directory = '/Users/cjdupuis/Coding/Matlab/Bastawros/olympus_code/'; %pwd NEED TO CHANGE THIS TO YOUR DIRRECTORY
pixSize = 1024; % (Jake this dosent need to change rn, but maybe in future)

%% DON'T NEED TO CHANGE

% Get the image data of the references from ToAverage folder and clean
refDir = dir([directory 'ToAverage/*.jpg']);
numRef = length(refDir);
refNames = strings(numRef, 1);
refImgsData = zeros(pixSize, pixSize, numRef); %This will contain the jpg data

for i = 1:numRef
    refNames(i) = [directory 'ToAverage/' refDir(i).name]; %Absolute file path
    temp = imread(refNames(i));
    [refImgsData(:,:,i), ~] = clnimg(double(temp(:,:,2))); %temp(:,:,2) cause only want green (imread returns 3 dim matrix)
    %refImgsData(:,:,i) = temp(:,:,2);
end

%% Get the image data of the deformed from Deformed folder and clean
defDir = dir([directory 'Deformed/*.jpg']);
temp = imread([directory 'Deformed/' defDir.name]);
[defData, ~] = clnimg(double(temp(:,:,2)));
%defData = temp(:,:,2);

%% Take FFT's, average, and scale
refFFTs = fft2(refImgsData);

sum = zeros(pixSize, pixSize);
for i = 1:numRef
    sum = refFFTs(:,:,i) + sum;
end
avgRefFFT = sum ./ numRef; %I average AFTER FFT, I am not sure if I should avg before or after
avgRefFFTScaled = fftshift(log(1+abs(avgRefFFT)));

defFFT = fft2(defData);
defFFTScaled = fftshift(log(1+abs(defFFT)));

%% Now take the difference of average reference and deformed using 1st method
dif1 = avgRefFFTScaled - defFFTScaled; %I used the scaled, should I instead minus the complex numbers then scale?

%% Now take the difference of average reference and deformed using 2nd method
Ar = double(real(avgRefFFT));
Br = double(real(defFFT));
Ai = double(imag(avgRefFFT));
Bi = double(imag(defFFT));
dif2 = sqrt((Ar - Br).^2 + (Ai - Bi).^2);
dif2 = fftshift(log(1+abs(dif2)));

%% Display Plots
% I realize this is a riduculous way to display images. I dont understand
% how it works fully, but this works so I am going to leave for now.
figure();
subplot(1,1,1);
imshow(avgRefFFTScaled, []);
title('Averaged References Spectrum Image');

figure();
subplot(1,1,1);
imshow(defFFTScaled, []);
title('Deformed Spectrum Image');

figure();
subplot(1,1,1);
imshow(dif1, []);
title('Method 1 Difference Spectrum Image');

figure();
subplot(1,1,1);
imshow(dif2, []);
title('Method 2 Difference Spectrum Image');

