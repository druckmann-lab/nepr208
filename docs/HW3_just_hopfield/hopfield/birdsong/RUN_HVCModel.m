function RUN_HVCModel
% Script to reproduce figure 5 a-d and extended data figure 10 a-d from
% Okubo et al. 
%
% Code was tested in MATLAB 2014a, 2015b
%
% Emily Mackevicius 7/18/2015, based on Hannah Payne's code
% which builds off Ila Fiete's model, with help from Michale Fee and Tatsuo
% Okubo. 

%% *Alternating differentiation*
% From subsong through protosyllable stage through splitting, 
% to generate figure 5 a-d
% Calls HVCIter to step through one iteration of the model

%% Alternating differentiation: network parameters
% fixed parameters
p.seed = rand;          % seed random number generator. 
                            % Set to 9038 to replicate paper 
p.n = 100;              % n neurons
p.trainint = 10;        % Time interval between inputs
p.nsteps = 100;         % time-steps to simulate -- each time-step is 1 
                        %   burst duration.
nstepsSubsong = 1000;   % time-steps to simulate for subsong stage
p.pin = .01;            % probability of external stimulation of at least 
                        %   one neuron at any time
k = 10;                 % number of training neurons
p.trainingInd = 1:k;    % index of training neurons
p.beta = .115;          % strength of feedforward inhibition
p.alpha = 30;           % strength of neural adaptation
p.eta = .025;           % learning rate parameter
p.epsilon = .2;         % relative strength of heterosynaptic LTD
p.tau = 4;              % time constant of adaptation
gammaStart= .01;        % strength of recurrent inhibition
gammaSplit =.18;        % increased strength of recurrent inhibition to 
                        %   induce splitting
wmaxStart = 1;          % single synapse hard bound
wmaxSplit = 2;          % single synapse hard bound to induce splitting 
                        %  (increased to encourage fewer stronger synapses)
mStart = 10;            % desired number of synapses per neuron 
                        %   (wmax = Wmax/m)
Wmax = mStart*wmaxStart;% soft bound for weights of each neuron
mSplit = Wmax/wmaxSplit;% keep Wmax constant, change m & wmax to induce 
                        %   fewer stronger synapses
HowClamped = 10;        % give training neurons higher threshold
HowOn = 10;             % higher inputs to training neurons

% how many iterations to run before plotting
nIterProto = 200;       % end of protosyllable stage
nIterPlotSplit1 = 492;  % number of splitting iterations before plotting 
                        %   intermediate splitting phase
nIterPlotSplit2 = 1200; % total number of splitting iterations

% parameters that change over development
protosyllableStage = [true(1,nIterProto) false(1,nIterPlotSplit2)]; 
splittingStage = [false(1,nIterProto) true(1,nIterPlotSplit2)];
gammas(protosyllableStage) = gammaStart;
gammas(splittingStage) = gammaSplit*sigmf(1:nIterPlotSplit2,[1/200 500]);
wmaxs(protosyllableStage) = wmaxStart;
wmaxs(splittingStage)     = wmaxSplit;
ms(protosyllableStage) = mStart;
ms(splittingStage)     = mSplit;

%Subsong Inputs
rng(p.seed)
isOnset = rand(1,nstepsSubsong)>.9; 
Input =-HowClamped*ones(k, nstepsSubsong); % clamp training neurons 
                        % (effectively giving them higher threshold)
Input(:,isOnset) = HowOn; 
bdyn = double(rand(p.n,nstepsSubsong)>=(1-p.pin)); % Random activation
bdyn(1:k,:) = Input; 
subsongInput = bdyn; 

%Protosyllable inputs
PsylInput = -HowClamped*ones(k, p.nsteps); %clamp training neurons 
                        % (effectively giving them higher threshold)
PsylInput(:,mod(1:p.nsteps,p.trainint)==1) = HowOn; % rhythmic activation 
                                                    %   of training neurons

%Alternating Inputs
AltInput =-HowClamped*ones(k, p.nsteps); 
AltInput(1:k/2,mod(1:p.nsteps,2*p.trainint)==1) = HowOn; 
AltInput((k/2+1):k,mod(1:p.nsteps,2*p.trainint)==p.trainint+1) = HowOn; 
                    % alternating rhythmic activation of training neurons

[trainingNeuronsSubsong, trainingNeuronsPsyl, trainingNeuronsAlt] = setTrainingNeurons(p,k, isOnset);
                    
%% Alternating differentiation: run simulation

% random initial weights
rng(p.seed);
w0 = 2*rand(p.n)*Wmax/p.n;

% subsong stage
pSubsong = p; 
pSubsong.gamma = gammas(1); 
pSubsong.wmax = wmaxs(1); 
pSubsong.m = ms(1); 
pSubsong.eta = 0; 
pSubsong.epsilon = 0; 
pSubsong.nsteps = nstepsSubsong; 
pSubsong.w = w0; 
pSubsong.input = subsongInput;

% Run subsong network
[wSubsong, xdynSubsong] = HVCIter(pSubsong);
w = wSubsong;
trainingNeurons = trainingNeuronsPsyl;

% plot for tracking updates
figure(1); clf;

% learning stages
for t = 1:(nIterProto+nIterPlotSplit2)  
    p.w = w;
    
    % set parameters that change over development
    p.gamma = gammas(t); 
    p.wmax = wmaxs(t); 
    p.m = ms(t); 
    
    % Construct input
    bdyn = double(rand(p.n,p.nsteps)>=(1-p.pin)); % Random activation
    bdyn(1:k,:) = protosyllableStage(t)*PsylInput+ ...
        splittingStage(t)*AltInput; % drive to seed neurons
    p.input = bdyn;
    
    % run one iteration
    [w, xdyn] = HVCIter(p); 

    % *** EXAMPLE CODE: Calculate current splitting results here***
    if t<20 || mod(t,10)==1      % Update plot every 10 time steps
        stats = findStats(p,xdyn,trainingNeurons);
        
        subplot(211);  hold on; title('Fraction neurons')
        plot(t,mean(stats.Shared),'ok', t, mean(stats.Specific{1}),'.r', t, mean(stats.Specific{2}),'.b');
        legend('Shared','Specific1','Specific2');
        
        subplot(212);  hold on; title('Chain width')
        plot(t,mean(stats.Width{1}),'+r', t,mean(stats.Width{1}),'+b')
       
        drawnow
    end
    % *** END EXAMPLE CODE
    
    % save certain iterations for plotting later
    switch t
        case nIterProto; 
            wProto = w; 
            xdynProto = xdyn; 
            trainingNeurons = trainingNeuronsAlt;
        case nIterProto + nIterPlotSplit1; 
            wSplit1 = w; 
            xdynSplit1 = xdyn; 
        case nIterProto + nIterPlotSplit2;
            wSplit2 = w; 
            xdynSplit2 = xdyn; 
    end
end

%% Plotting parameters
figure(2); clf;
isEPS = 0; 
clf
set(gcf, 'color', ones(1,3));

if isEPS 
    PlottingParams.msize = 8; 
    PlottingParams.linewidth = .25;
    set(0,'defaultAxesFontName', 'Arial')
    set(0,'defaultTextFontName', 'Arial')
    PlottingParams.labelFontSize = 7; 
    set(gcf, 'units','centimeters', 'position', [5 5 13.5 6])
else
    PlottingParams.msize = 10;
    PlottingParams.linewidth = .25;
    PlottingParams.labelFontSize = 7; 
end

PlottingParams.SeedColor = [.95 .5 1];
PlottingParams.Syl1Color = [1 0 0]; 
PlottingParams.Syl2Color = [0 0 1]; 
PlottingParams.ProtoSylColor = [0 0 0]; 
PlottingParams.ProtoSylBarColor = [.5 .5 .5];
PlottingParams.SubsongSylColor = [0 0 0]; 
PlottingParams.SubsongBarColor = [1 1 1]; 
PlottingParams.numFontSize = 5; 
PlottingParams.wplotmin = 0; 
PlottingParams.wplotmax = 2; % this should be wmaxSplit
PlottingParams.wprctile = 0; % plot all weights above this percentile.  
                             %  If nonzero, ignores wplotmin, wplotmax
PlottingParams.wperneuron = 6; % max outgoing weights plotted
PlottingParams.wperneuronIn = 9; % min incoming weights plotted
PlottingParams.totalPanels = 4; 
nplots = 4;
bottom = .1; 
height = .45; 
scale = .005; 
spacing = .75/(2*nplots); 

%% Plotting subsong
PlottingParams.thisPanel = 1; 
PlottingParams.Hor = 1;
plotSubsong(wSubsong, xdynSubsong, trainingNeuronsSubsong, PlottingParams)

%% Plotting protosylable
PlottingParams.thisPanel = 2; 
subplot('position', ...
    [PlottingParams.thisPanel/nplots-.9/nplots, .6, .9/nplots, .35])
plotHVCnet(wProto,xdynProto,p.trainint,trainingNeuronsPsyl,PlottingParams)
set(gca, 'color', 'none');
PlottingParams.axesPosition = ...
    [PlottingParams.thisPanel/nplots-2*spacing, bottom, 40*scale, height];
plotAlternating(wProto, xdynProto, p.trainint, ...
    trainingNeuronsPsyl, PlottingParams)
set(gca, 'color', 'none')

%% Plotting splitting stages
PlottingParams.thisPanel = 3;
subplot('position', ...
    [PlottingParams.thisPanel/nplots-.9/nplots, .6, .9/nplots, .35])
plotHVCnet(wSplit1,xdynSplit1,p.trainint,trainingNeuronsAlt,PlottingParams)
set(gca, 'color', 'none');
PlottingParams.axesPosition = ...
    [PlottingParams.thisPanel/nplots-2*spacing, bottom, 40*scale, height];
plotAlternating(wSplit1, xdynSplit1, p.trainint, ...
    trainingNeuronsAlt, PlottingParams)
set(gca, 'color', 'none')

PlottingParams.thisPanel = 4;
subplot('position', ...
    [PlottingParams.thisPanel/nplots-.9/nplots, .6, .9/nplots, .35])
plotHVCnet(wSplit2,xdynSplit2,p.trainint,trainingNeuronsAlt,PlottingParams)
set(gca, 'color', 'none');
PlottingParams.axesPosition = ...
    [PlottingParams.thisPanel/nplots-2*spacing, bottom, 40*scale, height];
plotAlternating(wSplit2, xdynSplit2, p.trainint, ...
    trainingNeuronsAlt, PlottingParams)
set(gca, 'color', 'none')
