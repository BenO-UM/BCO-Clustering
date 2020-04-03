% Simple 2D example
% Creates 2 clusters of data

numExamples = 500;
X = zeros(numExamples,2);

for i = 1:numExamples/2
    X(i,:) = rand(1,2)+1;
    X(i+numExamples/2,:) = rand(1,2)-1;
end

clusterNumbers = bcoCluster(X,2);

clusterColor1 = 'red';
clusterColor2 = 'blue';

figure;
hold on;
for i = 1:numExamples
    if clusterNumbers(i)==1
        colorStr = clusterColor1;
    else
        colorStr = clusterColor2;
    end
    plot(X(i,1),X(i,2),'x','Color',colorStr);
end