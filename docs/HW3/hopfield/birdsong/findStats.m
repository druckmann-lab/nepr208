function stats = findStats(p,xsort, trainingNeurons)

Latency = findLatency(xsort, trainingNeurons);

if length(Latency)==1
    stats.Specific{1} = zeros(1,p.n);
    stats.Specific{2} =  zeros(1,p.n);
    stats.Shared =  ones(1,p.n);
elseif length(Latency)==2
    % keep track of which neurons participated in each syllable
    FireDur1 = Latency{1}.FireDur;
    FireDur2 = Latency{2}.FireDur;
    
    % classify neurons as specific or shared
    stats.Specific{1} = FireDur1&~FireDur2;
    stats.Specific{2} = FireDur2&~FireDur1;
    stats.Shared = (FireDur1&FireDur2);
 
end

histBins = 0:p.trainint+1;
for  i = 1:length(Latency)
   
    % Find the times at which each neuron fires
    fireTime  = Latency{i}.mode;
    
    % If a given neuron does not reliably participate exclude it
    fireTime(~Latency{i}.FireDur) = 0;
    
    % Calculate number of neurons participating at each timepoint
    temp = hist(fireTime,histBins);
    stats.Width{i} = temp(2:end-1);
    
    % Find the length of the chain
    stats.Length{i} = max(fireTime); 
    
end
