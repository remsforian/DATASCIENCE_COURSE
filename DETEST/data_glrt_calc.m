%SDM: Path was missing
addpath ..\
% load in all of the data. 
data1 = load("DETEST/data1.txt","-ascii")';
data2 = load("DETEST/data2.txt","-ascii")';
data3 = load("DETEST/data3.txt","-ascii")';

% put in our knowns
sfreq = 1024;
a1 = 10;
a2 = 3;
a3 = 3;
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
nsamples = 2048;

% calculating other values we need to input into the function

timeVec = (0:(nsamples-1))/sfreq;
kNyq = floor(nsamples/2) + 1;
posFreq = (0:(kNyq-1)) + 1/(nsamples/sfreq);
psdPosFreq = noisePSD(posFreq);

% running the cuntion on each of our data realizations

llr1=glrtqcsig(data1,timeVec,psdPosFreq,[a1,a2,a3]);
llr2=glrtqcsig(data2,timeVec,psdPosFreq,[a1,a2,a3]);
llr3=glrtqcsig(data3,timeVec,psdPosFreq,[a1,a2,a3]);

disp(llr1);
disp(llr2);
disp(llr3);

%FIXME: Estimate the significances using H0 data realizations