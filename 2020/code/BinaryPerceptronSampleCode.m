function BinaryPerceptronSampleCode(randSeed, inputNeuronNum, patternNum, learningRate)

rng('default');
rng(randSeed);

%%  Define network and connectivity
connVec = randn(1,inputNeuronNum-1);
neuronConnectivityMat = zeros(inputNeuronNum);
neuronConnectivityMat(inputNeuronNum,1:(inputNeuronNum-1)) = connVec;
neuronNum = size(neuronConnectivityMat,1);

%%  Define patterns
s = sign(randn(neuronNum-1,patternNum));
sigma = sign(randn(patternNum,1));

eta = learningRate; % learning rate

errorNum = 1;
epochNum = 1;
while errorNum >0
  errorNum = 0;
  for pp=1:patternNum
    %%  Single trial
    outputAct = connVec*s(:,pp);
    if sign(outputAct) ~= sign(sigma(pp)) % Mistake made
      connVec = connVec + 2*eta*(s(:,pp)*sign(sigma(pp)))';
      errorNum = errorNum + 1;
    end
    neuronConnectivityMat(inputNeuronNum,1:(inputNeuronNum-1)) = connVec;
  end
  display(['In epoch ' num2str(epochNum) ' There were ' ...
    num2str(errorNum) ' mistakes out of ' num2str(patternNum) ' patterns']);
  epochNum = epochNum + 1;
end