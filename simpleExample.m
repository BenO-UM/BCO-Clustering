% Simple 2D example
% Creates 2 clusters of data

numExamples = 500;
X = zeros(numExamples,2);

for i = 1:numExamples/2
    X(i,:) = rand(1,2);
    X(i+numExamples/2,:) = rand(1,2)-1;
end

clusterNumbers = bcoCluster(X,2,'silhouette',true);

plotTwoClusters(X,clusterNumbers);