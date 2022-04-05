%% Computes equations for the gating variables
%  [alpha, beta] = gates(v)
%  Niru Maheswaranathan
%  May 4 2016

function [alpha, beta] = gates(v)

  % alpha
  alpha = struct();
  alpha.m = 0.1 * (v + 40) ./ (1 - exp(-0.1 * (v + 40)));
  alpha.n = 0.01 * (v + 55) ./ (1 - exp(-0.1 * (v + 55)));
  alpha.h = 0.07 * exp(-0.05 * (v + 65));
  alpha.q = 0.055 * (v + 27) ./ (1 - exp(-0.263 * (v + 27)));
  alpha.r = 0.000457 * exp(-0.02 * (v + 13));

  % beta
  beta = struct();
  beta.m = 4 * exp(-0.0556 * (v + 65));
  beta.n = 0.125 * exp(-0.0125 * (v + 65));
  beta.h = 1 ./ (1 + exp(-0.1 * (v + 35)));
  beta.q = 0.94 * exp(-0.059 * (v + 13));
  beta.r = 0.0065 ./ (1 + exp(-0.0357 * (v + 15)));

end
