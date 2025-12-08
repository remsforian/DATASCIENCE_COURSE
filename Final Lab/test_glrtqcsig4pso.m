addpath NOISE/
addpath SIGNALS/
addpath DETEST/
addpath 'Final Lab'/CODES/

%% Generate Data Realization
% True parameters for the quadratic chirp signal
a1t = 10;
a2t = 5;
a3t = 2;

snr = 10;

% Create colored Gaussian noise data
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;

noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

sigVec = crcbgenqcsig(timeVec,1,[a1t,a2t,a3t]);
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
sigVec = snr*sigVec/sqrt(normSigSqrd);
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
dataVec = noiseVec + sigVec;

figure;
plot(timeVec,dataVec);
xlabel("time(s)");
ylabel("Amplitude");
title('Data Realization (Signal + Noise)');

%% Part 1: Sweep a1 only (keeping a2, a3 at true values)
disp('========== Part 1: Fitness Landscape (a1 sweep) ==========');

da = 0.1; 
amin = 0;
amax = 20;
a1_sweep = amin:da:amax;

% Create normalized X matrix for a1 sweep
X_sweep = zeros(length(a1_sweep),3);
for i = 1:length(a1_sweep)
    x1 = (a1_sweep(i) - amin) / (amax - amin);
    x2 = (a2t - amin) / (amax - amin);
    x3 = (a3t - amin) / (amax - amin);
    X_sweep(i,:) = [x1, x2, x3];
end

% Set up parameters structure
params = struct();
params.dataY = dataVec;
params.dataX = timeVec;
params.dataXSq = timeVec.^2;
params.dataXCb = timeVec.^3;
params.psd = psdPosFreq;
params.sampFreq = sampFreq;
params.rmin = [amin, amin, amin];
params.rmax = [amax, amax, amax];

% Compute fitness values
fitValues = glrtqcsig4pso(X_sweep, params);

% Plot fitness landscape
figure;
plot(a1_sweep, fitValues, 'b-', 'LineWidth', 1.5);
hold on;
plot(a1t, interp1(a1_sweep, fitValues, a1t), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('a_1 parameter value');
ylabel('Fitness value (negative GLRT)');
title('Fitness landscape: varying a_1 with a_2, a_3 at true values');
legend('Fitness', 'True a_1 value', 'Location', 'best');
grid on;

[minFit, minIdx] = min(fitValues);
bestA1 = a1_sweep(minIdx);
disp(['True a1: ', num2str(a1t)]);
disp(['Best a1 from sweep: ', num2str(bestA1)]);

%% Part 2: Full PSO optimization (searching all 3 parameters)
disp('========== Part 2: Full PSO Search (a1, a2, a3) ==========');

% Define search ranges for all three parameters
% These should encompass the true values
a1_min = 1;   a1_max = 20;
a2_min = 1;   a2_max = 10;
a3_min = 1;   a3_max = 10;

% Update params structure with new search ranges
params.rmin = [a1_min, a2_min, a3_min];
params.rmax = [a1_max, a2_max, a3_max];

% Create fitness function handle
fitFuncHandle = @(x) glrtqcsig4pso(x, params);

% Number of dimensions (3 parameters: a1, a2, a3)
nDim = 3;

%% Run PSO with default settings first
disp('Running PSO with default settings...');
rng('default');  % For reproducibility
tic;
psoOut1 = crcbpso(fitFuncHandle, nDim, [], 2);  % Last argument '2' returns allBestFit and allBestLoc
toc;

% Extract best results
stdCoord1 = psoOut1.bestLocation;
[~, realCoord1] = fitFuncHandle(stdCoord1);
disp('Results with default settings:');
disp(['  True parameters: [', num2str(a1t), ', ', num2str(a2t), ', ', num2str(a3t), ']']);
disp(['  Best parameters: [', num2str(realCoord1(1)), ', ', num2str(realCoord1(2)), ', ', num2str(realCoord1(3)), ']']);
disp(['  Best fitness: ', num2str(psoOut1.bestFitness)]);
disp(['  Maximum GLRT: ', num2str(-psoOut1.bestFitness)]);

%% Run PSO with custom settings
disp('Running PSO with custom settings...');
rng('default');
psoParams = struct();
psoParams.maxSteps = 2000;  % More iterations for better convergence
psoParams.popSize = 40;     % Population size
tic;
psoOut2 = crcbpso(fitFuncHandle, nDim, psoParams, 2);
toc;

% Extract best results
stdCoord2 = psoOut2.bestLocation;
[~, realCoord2] = fitFuncHandle(stdCoord2);
disp('Results with custom settings:');
disp(['  True parameters: [', num2str(a1t), ', ', num2str(a2t), ', ', num2str(a3t), ']']);
disp(['  Best parameters: [', num2str(realCoord2(1)), ', ', num2str(realCoord2(2)), ', ', num2str(realCoord2(3)), ']']);
disp(['  Best fitness: ', num2str(psoOut2.bestFitness)]);
disp(['  Maximum GLRT: ', num2str(-psoOut2.bestFitness)]);

%% Plot PSO Convergence
figure;
subplot(2,1,1);
plot(psoOut1.allBestFit, 'b-', 'LineWidth', 1.5);
xlabel('Iteration number');
ylabel('Global best fitness');
title('PSO Convergence: Default Settings');
grid on;

subplot(2,1,2);
plot(psoOut2.allBestFit, 'r-', 'LineWidth', 1.5);
xlabel('Iteration number');
ylabel('Global best fitness');
title('PSO Convergence: Custom Settings');
grid on;

%% Compare estimated signal to true signal
% Generate true signal (normalized)
trueSigVec = crcbgenqcsig(timeVec, 1, [a1t, a2t, a3t]);
trueNorm = sqrt(innerprodpsd(trueSigVec, trueSigVec, sampFreq, psdPosFreq));
trueSigVec = trueSigVec / trueNorm;

% Generate estimated signal from best PSO result
estSigVec = crcbgenqcsig(timeVec, 1, realCoord2);
estNorm = sqrt(innerprodpsd(estSigVec, estSigVec, sampFreq, psdPosFreq));
estSigVec = estSigVec / estNorm;

% Plot comparison
figure;
plot(timeVec, dataVec, 'k-', 'LineWidth', 0.5);
hold on;
plot(timeVec, trueSigVec * snr, 'b-', 'LineWidth', 2);
plot(timeVec, estSigVec * snr, 'r--', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal Comparison');
legend('Data (Signal + Noise)', 'True Signal', 'Estimated Signal', 'Location', 'best');
grid on;

% Calculate estimation error
paramError = abs(realCoord2 - [a1t, a2t, a3t]);
disp('Parameter estimation errors:');
disp(['  |a1_est - a1_true| = ', num2str(paramError(1))]);
disp(['  |a2_est - a2_true| = ', num2str(paramError(2))]);
disp(['  |a3_est - a3_true| = ', num2str(paramError(3))]);