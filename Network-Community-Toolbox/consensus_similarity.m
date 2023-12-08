function [consensus, consensus_simm, pairwise_simm, consensus_index, average_pairwise_simm, average_average_pairwise_simm] = consensus_similarity(C)
%CONSENSUS_SIMILARITY     Construct a consensus (representative) partition
%using the iterative thresholding procedure
%
%   [consensus, consensus_simm, pairwise_simm] = CONSENSUS_SIMILARITY(C)
%   identifies a single representative partition from a set of C partitions
%   that is the most similar to the all others. Here, similarity is taken
%   to be the z-score of the Rand coefficient (see zrand.m)
%
%   NOTE: This code requires zrand.m to be on the MATLAB path
%
%   Inputs:     C,      pxn matrix of community assignments where p is the
%                       number of optimizations and n the number of nodes
%
%   Outputs:    consensus,      consensus partition
%               consensus_simm,	average similarity between consensus
%                               partition and all others
%               pairwise_simm,	pairwise similarity matrix
%   _______________________________________________
%   Marcelo G Mattar (08/21/2014) 

npart = numel(C(:,1)); % number of partitions

% Initialize variables
pairwise_simm = zeros(npart,npart);

%% CALCULATE PAIRWISE SIMILARITIES
for i=1:npart
    for j=(i+1):npart
        pairwise_simm(i,j) = zrand(C(i,:),C(j,:));
    end
end
pairwise_simm = pairwise_simm + pairwise_simm';

% Average pairwise similarity
average_pairwise_simm = sum(pairwise_simm,2)/(npart-1);
average_average_pairwise_simm = mean(average_pairwise_simm);
%% EXTRACT PARTITION MOST SIMILAR TO THE OTHERS
[X,I] = max(average_pairwise_simm);
    if isnan(X)
        I=1;
    end
consensus = C(I,:);
consensus_simm = X;
consensus_index = I;
