%% Computes the STA for a ganglion cell
%  [[ YOUR NAME HERE ]]
%  [[ DATE ]]


%% Load the data from the hdf5 file (time and stimulus are sampled every 10ms)
dt = 0.01;  % stimulus sampling rate (seconds)
time = h5read('rgc_data.h5', '/time');
stimulus = h5read('rgc_data.h5', '/stimulus');
spike_times = h5read('rgc_data.h5', '/spike_times');


%% Initialize the STE
% compute the dimensions of the filter (spatial and temporal)
spatial_dim = size(stimulus, 1);         % the number of spatial dimensions in the stimulus
filter_length = 40;                      % the number of temporal dimensions in the stimulus

% cut out the first few spikes that occur before the length of the filter (in seconds) has elapsed
spike_times = spike_times(spike_times > filter_length * dt);

% store the indices of the time array corresponding to each spike
% (you'll use this when computing histograms and the nonlinearity of the LN model)
spike_indices = zeros(length(spike_times), 1);

% initialize an array that will store the spike-triggered ensemble (STE)
% it is a matrix with dimensions given by: the number of spikes and the total of dimensions in the filter
ste = % [[ YOUR CODE HERE ]]


%% Collect stimuli that are part of the STE
fprintf('Collecting the spike-triggered ensemble ...\n');
for i=1:length(spike_times)

  % get the nearest index of this spike time
  % (there are multiple ways you can do this)
  % [[ YOUR CODE HERE ]]

  % select out the stimulus preceeding the spike, and store it in the `ste` array
  % [[ YOUR CODE HERE ]]

  % update the display
  if mod(i, 1000) == 0
    fprintf('%i of %i\n', i, length(spike_times));
  end

end
fprintf('Done!\n');


%% Compute the spike-triggered average (STA)
%% by averaging over the number of spikes in the STE
sta = % [[ YOUR CODE HERE ]]

% we'll normalize the STA so that it has unit norm (the scale is arbitrary)
sta = sta / norm(sta);


%% Compute the STC
% compute the covariance of the STE
stc = % [[ YOUR CODE HERE ]]

% compute the eigendecomposition of the STC
[eigvecs, eigvals] = % [[ YOUR CODE HERE ]]


%% Compute the linear projection of the stimulus onto the STA
u = zeros(length(time), 1);      % the variable `u` will store the projection at each time step
for t=filter_length:length(time) % loop over each time point

  % extract the stimulus slice at this time point
  stimulus_slice = stimulus(:, t-filter_length+1:t);

  % store the linear projection (dot product) of the stimulus slice onto the STA
  u(t) = % [[ YOUR CODE HERE ]]

end


%% Compute the histogram of the stimulus projection
% bin the spike times using the time array (hint: use the hist command)
spike_counts = % [[ YOUR CODE HERE ]]

% discretize the values of u, and get the corresponding bin indices
[n, edges, bin_indices] = custom_histcounts(u, 50);
ub = unique(bin_indices);
nonlinearity = zeros(length(ub),1);
bin_centers = edges(1:end-1) + 0.5 * diff(edges);
for bin_index=1:length(ub)
  % here, you will need to compute the mean spike count (spike_counts) conditioned
  % on times when the filtered stimulus (u) is within a certain bin
  nonlinearity(bin_index) = % [[ YOUR CODE HERE ]]
end

%% Compute the nonlinearity via a ratio of histograms
%  (this is another way to compute the nonlinearity, it
%   is included here for your reference).
bins = linspace(-6, 6, 30);
raw = hist(u, bins);
raw = raw / sum(raw);       % p(stimulus)
conditional = hist(u(spike_indices), bins);
conditional = conditional / sum(conditional);  % p(stimulus|spike)
nln = mean(spike_counts) * conditional ./ raw; % p(spike|stimulus)

%% Visualization
%  **You only need to add titles and axis labels**
figure(1);
load('colormap.mat');
range = [-0.2, 0.2];
imagesc(sta, range);
colormap(cmap);
colorbar;
axis('image');

figure(2);
plot(diag(eigvals), 'o');
xlim([0 size(ste, 2)+1]);

figure(3);
subplot(131);
imagesc(reshape(eigvecs(:,end), spatial_dim, filter_length), range);
colormap(cmap);
axis('image');
subplot(132);
imagesc(reshape(eigvecs(:,end-1), spatial_dim, filter_length), range);
colormap(cmap);
axis('image');
subplot(133);
imagesc(reshape(eigvecs(:,end-2), spatial_dim, filter_length), range);
colormap(cmap);
axis('image');

figure(4);
plot(bin_centers, nonlinearity / dt, 'ro');
plot(bins, nln / dt, 'k-');
