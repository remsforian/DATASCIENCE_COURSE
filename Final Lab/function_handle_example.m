P = struct('linear', 10, 'quadratic', 3, 'cubic', 3);
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;

H = @(x) LIGO_sim(timeVec,x,P);


plot(timeVec,H(10));
xlabel("Time(s)");
title("SNR = 10");

plot(timeVec,H(12));
xlabel("Time(s)");
title("SNR = 12");

plot(timeVec,H(15));
xlabel("Time(s)");
title("SNR = 15");