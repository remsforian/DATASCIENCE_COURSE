% first I'll put in all the provided paramiters
nSamples = 512;
sampFreq = 512;
noisePSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;
snr = 10;
a1 = 10;
a2 = 3;
a3 = 3;

% generate a data realization 
maxFreq = a1 + 2*a2 + 3*a3;
nyqFreq = 2*maxFreq;
dt = 1/sampFreq;
dataLen = nSamples/sampFreq;
timeVec = 0:dt:(dataLen-dt);
sigVec = crcbgenqcsig(timeVec,1,[a1,a2,a3]);

kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
sigVec = snr*sigVec/sqrt(normSigSqrd);

noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],10,sampFreq);
% Add normalized signal
dataVec = noiseVec + sigVec;

a1_min = 1;
a2_min = 1;
a3_min = 1;
a1_max = 180;
a2_max = 10;
a3_max = 10;

params = struct();
params.dataY = dataVec;              % Your data realization
params.dataX = timeVec;              % Time vector
params.dataXSq = timeVec.^2;         % Time squared
params.dataXCb = timeVec.^3;         % Time cubed
params.psd = psdPosFreq;             % PSD at positive frequencies
params.sampFreq = sampFreq;          % Sampling frequency
params.rmin = [a1_min, a2_min, a3_min];  % Lower bounds for search
params.rmax = [a1_max, a2_max, a3_max];  % Upper bounds for search

fitFuncHandle = @(x) glrtqcsig4pso(x, params);

nDim = 3;

psoParams = struct();
psoParams.maxSteps = 1000;   % Number of iterations (page 41)
psoParams.popSize = 40;      % Default population size (can adjust)


nRuns = 8;

% Run multiple independent PSO runs (best-of-M-runs strategy)
disp(['Running ', num2str(nRuns), ' independent PSO runs...']);
rng('default');  % For reproducibility

parfor runIdx = 1:nRuns
    fprintf('  Run %d/%d...\n', runIdx, nRuns);
    psoOut = crcbpso(fitFuncHandle, nDim, psoParams, 2);
    
    allRuns(runIdx).fitness = psoOut.bestFitness;
    allRuns(runIdx).location = psoOut.bestLocation;
    [~, allRuns(runIdx).params] = fitFuncHandle(psoOut.bestLocation);
end

[bestOverallFitness, bestOverallRun] = min([allRuns.fitness]);
bestOverallParams = allRuns(bestOverallRun).params;


% Display results
disp('========== PSO Search Results ==========');
disp(['True parameters: [a1=', num2str(a1), ', a2=', num2str(a2), ', a3=', num2str(a3), ']']);
disp(['Best run: ', num2str(bestOverallRun), '/', num2str(nRuns)]);
disp(['Best parameters found: [a1=', num2str(bestOverallParams(1)), ...
      ', a2=', num2str(bestOverallParams(2)), ...
      ', a3=', num2str(bestOverallParams(3)), ']']);
disp(['Best fitness (negative GLRT): ', num2str(bestOverallFitness)]);
disp(['Maximum GLRT value: ', num2str(-bestOverallFitness)]);

% Calculate parameter errors
paramErrors = abs(bestOverallParams - [a1, a2, a3]);
disp(['Parameter errors: [', num2str(paramErrors(1)), ', ', ...
      num2str(paramErrors(2)), ', ', num2str(paramErrors(3)), ']']);

% generating a signal based on the best fit values

a1e = bestOverallParams(1);
a2e = bestOverallParams(2);
a3e = bestOverallParams(3);
estSigVec = crcbgenqcsig(timeVec,1,[a1e,a2e,a3e]);

% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(estSigVec,estSigVec,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
estSigVec = snr*estSigVec/sqrt(normSigSqrd);
tstMat = [estSigVec; sigVec];
figure;
scatter(timeVec, dataVec,3,"k","filled");
hold on;
plot(timeVec, sigVec, 'b-', 'LineWidth', 2);      % Blue, thick line
plot(timeVec, estSigVec, 'r-', 'LineWidth', 2);  % Red, thick line
xlabel('Time (s)');
ylabel('Amplitude');
legend('Data (Signal + Noise)', 'True Signal', 'Estimated Signal', 'Location', 'best');
title('Generated Signal with Noise shoing true and estimated signal');
hold off;
