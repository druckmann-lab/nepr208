%% Computes the output of a sigmoid
%  y = sigmoid(x)
%  Niru Maheswaranathan
%  May 4 2016

function y = sigmoid(x)
  y = 1 ./ (1 + exp(-x));
end
