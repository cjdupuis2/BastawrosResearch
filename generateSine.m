length = 20;
numPoints = 1000;
numLines = 200;
space = 1;
amp = 40;

x = linspace(0,length,numPoints);
y = (amp / 2) * sin(x / 1.2);
data = zeros(numLines,numPoints);

for i = 1:numLines
    data(i,:) = y + (i - 1) * space;
end

figure; hold;
for i = 1:numLines
    plot(x,data(i,:), 'k');
end