% By CJ Dupuis + some stuff from Bishoy 
% This code takes .jpgs as input and runs the summation technique to
% determine the stretch

clear, clc, close all;

%% TO CHANGE
% You need a folder named ToAverage in working dirrectory.
% Put all reference jpg files here

% You need a folder named Deformed in working dirrectory.
% Put the 1 deformed jpg file here

directory = '/Users/cjdupuis/Coding/Matlab/Bastawros/olympus_code/'; %pwd NEED TO CHANGE THIS TO YOUR DIRRECTORY
pixSize = 1024;

% FOR TESTING
deformationY = .1; %Percent

%% Get the image data of the references from ToAverage folder and clean
refDir = dir([directory 'ToAverage/*.jpg']);
numRef = length(refDir);
refNames = strings(numRef, 1);
refImgsData = zeros(pixSize, pixSize, numRef); %This will contain the jpg data

for i = 1:numRef
    refNames(i) = [directory 'ToAverage/' refDir(i).name]; %Absolute file path
    temp = imread(refNames(i));
    refImgsData(:,:,i) = temp(:,:,2); %(:,:,2) because only want 1 color
    refImgsData(:,:,i) = clnhann(refImgsData(:,:,i));
end

%% Get the image data of the deformed from Deformed folder and clean
% defDir = dir([directory 'Deformed/*.jpg']);
% temp = imread([directory 'Deformed/' defDir.name]);
% defData = temp(:,:,2);
% defData = clnhann(double(defData));

% defData = stretch(refImgsData, (deformation / 100)); % FOR TESTING
%% Take FFT's, average, and scale
fftSum = zeros(pixSize, pixSize); %Average before FFT
for i = 1:numRef
    fftSum = refImgsData(:,:,i) + fftSum;
end
avgRef = fftSum ./ numRef;
defData = stretch(avgRef, 0, (deformationY / 100)); %FOR TESTING AVG

% refFFTs = fft2(refImgsData); %Average after FFT
% fftSum = zeros(pixSize, pixSize);
% for i = 1:numRef
%     fftSum = refFFTs(:,:,i) + fftSum;
% end
% avgRefFFT = fftSum ./ numRef;

avgRefFFT = fft2(avgRef);
defFFT = fft2(defData);

avgRefFFTLog = fftshift(log(1+abs(avgRefFFT)));
defFFTLog = fftshift(log(1+abs(defFFT)));

%% Summation Technique stretch (Autoscaling window)
percentIgnore = 10; %Percent of data to ignore from edge since compressing leaves NaN values
width = 100; %Width of x data taken
half = (pixSize / 2) + 1;
topLimitofIgnore = (pixSize / 2) - ceil((pixSize / 2) * (percentIgnore / 100));

percision = 10; %Higher is more points
window = 2; %Higher zooms out
dist = abs(deformationY / percision); %Distance between points (percent)
low = deformationY - (window * abs(deformationY));
high = deformationY + (window * abs(deformationY));
range = low:dist:high; %Amount of stretch on deformed fft (percent)
% 
% range = -1:.01:1;
points = length(range);
summation = zeros(1,points);
refHalf = avgRefFFTLog(half:end, half:end); %Only need half the fft
defHalf = defFFTLog(half:end, half:end);
for i = 1:points
    def = range(i);
    fftStretch = stretch(defHalf, 0, (def / 100)); %DO I NEED TO TAKE FFT OF WHOLE THING OR CAN I JUST DO SMALL AREA?
%     refArea = refHalf(1:topLimitofIgnore, half-width:half+width);
%     stretchArea = fftStretch(1:topLimitofIgnore, half-width:half+width);
    refArea = refHalf(1:topLimitofIgnore, :);
    stretchArea = fftStretch(1:topLimitofIgnore, :);
    diff = (refArea - stretchArea).^2;
    summation(i) = sum(sum(diff));
end

figure(), plot(range,summation, "*"), title("Summation of difference: Target = " + num2str(deformationY) + "%");
xline(deformationY, 'Linewidth', 2);
ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 12;

