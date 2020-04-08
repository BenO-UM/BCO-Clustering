function p = purity(clustNums, groundTruth)

k = max(groundTruth);

total = 0;
for idx = 1:k
    % Find most commonly occuring ground truth class in cluster
    [~, numOccurrences] = mode(groundTruth(clustNums==idx));
    total = total + numOccurrences;
end

p = total/length(clustNums);

end