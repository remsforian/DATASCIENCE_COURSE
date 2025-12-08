addpath ../SIGNALS

sampFreq = 1024;
nSamples = 2048;
timeVec = (0:(nSamples-1))/sampFreq;

%% Quadratic chirp signal
% Signal parameters
a1=10;
a2=3;
a3=10;
A = 10;

%%
% Generate signal
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);

