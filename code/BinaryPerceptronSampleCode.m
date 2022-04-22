function BinaryPerceptronSampleCode(randSeed, inputNeuronNum, patternNum, learningRate)

rng('default');
rng(randSeed);

%%  Define network and connectivity
connVec = randn(1,inputNeuronNum);

%%  Define patterns
patternArray = sign(randn(inputNeuronNum,patternNum));
patternDesiredOutput = sign(randn(patternNum,1));

eta = learningRate; % learning rate

errorNum = 1;
epochNum = 1;
while errorNum >0
  errorNum = 0;
  for pp=1:patternNum
    %%  Single trial
    outputAct = connVec*patternArray(:,pp);
    if sign(outputAct) ~= sign(patternDesiredOutput(pp)) % Mistake made
      connVec = connVec + 2*eta*(patternArray(:,pp)*sign(patternDesiredOutput(pp)))';
      errorNum = errorNum + 1;
    end
  end
  disp(['In epoch ' num2str(epochNum) ' There were ' ...
    num2str(errorNum) ' mistakes out of ' num2str(patternNum) ' patterns']);
  epochNum = epochNum + 1;
  if epochNum > 20000
      disp('Learning did not converge')
      break
  end
end
