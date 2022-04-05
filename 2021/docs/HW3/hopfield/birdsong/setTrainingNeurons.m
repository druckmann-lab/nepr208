function [trainingNeuronsSubsong, trainingNeuronsPsyl, trainingNeuronsAlt] = setTrainingNeurons(p,k, isOnset)


%% Alternating differentiation: plotting subsong
trainingNeuronsSubsong{1}.nIDs = 1:k;
trainingNeuronsSubsong{1}.tind = find(isOnset);
trainingNeuronsSubsong{1}.candLat = 1:2*p.trainint; 
trainingNeuronsSubsong{1}.thres = 12; % criteria for participation during 
                                      %  subsong (thres from testLatSig -- 
                                      %  must fire at consistent latency 
                                      %  more than 12 times in the bout of 
                                      %  ~100 syllables to count as 
                                      %  participating)
                                      
%% Alternating differentiation: plotting protosylable
trainingNeuronsPsyl{1}.nIDs = 1:k;
trainingNeuronsPsyl{2}.nIDs = 1:k;
trainingNeuronsPsyl{1}.tind = find(mod(1:p.nsteps, p.trainint)==1);
trainingNeuronsPsyl{2}.tind = find(mod(1:p.nsteps, p.trainint)==1);
trainingNeuronsPsyl{1}.candLat = 1:p.trainint; 
trainingNeuronsPsyl{2}.candLat = 1:p.trainint; 
trainingNeuronsPsyl{1}.thres = 4; % criteria for participation during 
                                  %  protosyllable stage (thres from 
                                  %  testLatSig -- must fire at consistent 
                                  %  latency more than 4 times in the bout 
                                  %  of 10 syllables to count as 
                                  %  participating)
trainingNeuronsPsyl{2}.thres = 4; 


%% Alternating differentiation: plotting splitting stages
trainingNeuronsAlt{1}.nIDs = 1:k/2;
trainingNeuronsAlt{2}.nIDs = (k/2+1):k;
trainingNeuronsAlt{1}.tind = find(mod(1:p.nsteps, 2*p.trainint)==1);
trainingNeuronsAlt{2}.tind = find(mod(1:p.nsteps, ...
                                2*p.trainint)==p.trainint+1);
trainingNeuronsAlt{1}.candLat = 1:p.trainint; 
trainingNeuronsAlt{2}.candLat = 1:p.trainint; 
trainingNeuronsAlt{1}.thres = 2; % criteria for participation during 
                                 %  splitting stage (thres from testLatSig 
                                 %  -- must fire at consistent latency 
                                 %  more than 2 times in the bout of 5 
                                 %  syllables (of each type) to count 
                                 %  as participating)
trainingNeuronsAlt{2}.thres = 2; 