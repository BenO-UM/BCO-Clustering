function scores = evaluateBees(bees,X,k)

numBees = size(bees,2);

scores = zeros(1,numBees);

for beeIdx = 1:numBees
    currentBee = bees(:,beeIdx);
    for clusterIdx = 1:k
        examplesInCluster = X(currentBee==clusterIdx,:);
        clusterCentroid = mean(examplesInCluster,1);
        scores(beeIdx) = scores(beeIdx) + sum((examplesInCluster-clusterCentroid).^2,'all');
    end
end

end