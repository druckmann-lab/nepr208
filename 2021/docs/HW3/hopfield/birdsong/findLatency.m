%% Plotting functions: *findLatency*
function Latency = findLatency(xsort, trainingNeurons)
% Calculates the mode latency of each neuron
% xsort: activity of network
% trainingNeurons: cell array of structures containing 
%   neuron and time indices for each syllable type

nsteps = size(xsort,2); 
n = size(xsort,1); 

% iterate over candidate latencies
for syli = 1:length(trainingNeurons)
    nFired = zeros(n,length(trainingNeurons{syli}.candLat));
    for lati = 1:length(trainingNeurons{syli}.candLat); 
        tInds = zeros(1,nsteps); 
        tInds(min(nsteps, ...
            trainingNeurons{syli}.tind + ...
            trainingNeurons{syli}.candLat(lati))-1) = 1; 
        nFired(:,lati) = ...
            sum(bsxfun(@times, xsort, tInds),2); % number of times each 
                                                 % neuron fired at this 
                                                 % latency
    end
    for ni = 1:n
        [~, Latency{syli}.mode(ni)] = max(nFired(ni,:)); 
        Latency{syli}.mode(ni) = ...
            trainingNeurons{syli}.candLat(Latency{syli}.mode(ni)); 
        Latency{syli}.FireDur(ni) = ...
            max(nFired(ni,:))>trainingNeurons{syli}.thres;  
    end
end
end
