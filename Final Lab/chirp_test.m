% This code will test the struct-based generation of a chirp signal

% Generate the chirp signal

a1=10;
a2=5;
a3=2;
A=10;
maxFreq = a1+2*a2+3*a3;
nyqFreq = 2*maxFreq;
params = struct("linear", a1, "quadratic", a2, "cubic", a3);
dt = 1/(10*nyqFreq);
timeVec = 0:dt:2-dt;
sigVec = crcbgenqcsig_new(timeVec,A,params);

% Plot the raw chirp signal 
figure;
plot(timeVec,sigVec);
xlabel("time(s)");
title("Test Chirp Signal");

% Calculate the periodigram
nSamples = length(timeVec);
dataLen = max(timeVec)-min(timeVec);
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal
fftSig = fft(sigVec);
% Discard negative frequencies as needed for periodgram
fftSig = fftSig(1:kNyq);

% Plot the periodgram 
figure;
plot(posFreq,abs(fftSig));
xlabel("Frequency(Hz)");
title("Periodgram");

% comparing to orriginal values
addpath("../SIGNALS");

sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);


figure;
plot(timeVec,sigVec);
xlabel("time(s)");
title("Orriginal Code Chirp Signal Test");

% Calculate the periodigram
nSamples = length(timeVec);
dataLen = max(timeVec)-min(timeVec);
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal
fftSig = fft(sigVec);
% Discard negative frequencies as needed for periodgram
fftSig = fftSig(1:kNyq);

% Plot the periodgram 
figure;
plot(posFreq,abs(fftSig));
xlabel("Frequency(Hz)");
title("Orriginal Code Periodgram");

% The output of both versions was identical (what we expected)