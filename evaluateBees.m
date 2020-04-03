function scores = evaluateBees(bees,X)

numBees = size(bees,3);

scores = zeros(1,numBees);

for beeIdx = 1:numBees
    currentBee = bees(:,:,beeIdx);
    clusterNumbers = knnsearch(currentBee,X);
    scores(beeIdx) = sum((X-currentBee(clusterNumbers,:)).^2,'all');
end

end