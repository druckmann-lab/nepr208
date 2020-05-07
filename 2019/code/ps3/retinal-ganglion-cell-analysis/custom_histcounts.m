function [n, edges, inds] = custom_histcounts(x, nbins)

edges = linspace(min(x), max(x), nbins);
[n, inds] = histc(x, edges);
