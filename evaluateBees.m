function scores = evaluateBees(bees,X,type)

if nargin < 3
    type = 'centroid';
end

numBees = size(bees,3);

scores = zeros(1,numBees);
for beeIdx = 1:numBees
    currentBee = bees(:,:,beeIdx);
    clusterNumbers = knnsearch(currentBee,X);
    switch lower(type)
        case 'centroid' 
            scores(beeIdx) = sum((X-currentBee(clusterNumbers,:)).^2,'all');
        case 'silhouette'
            scores(beeIdx) = -mean(silhouette(X,clusterNumbers));
        otherwise
            error('Invalid evaluation type');
    end
end
    
end