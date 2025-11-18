function glrt = glrtqcsig(dataVec,timeVec,psdPosFreq, params)

% Takes as input data time psd and paramiters and calculates a glrt value

a1 = params(1);
a2 = params(2);
a3 = params(3);

% Calculate sampling frequency from time vector
sampFreq = 1 / (timeVec(2) - timeVec(1));

% Generate the quadratic chirp signal template
% The amplitude value (second argument) doesn't matter as it will be normalized
sigVec = crcbgenqcsig(timeVec, 1, [a1, a2, a3]);

% Normalize the signal to unit norm for the given PSD
% This creates the template vector
[templateVec, ~] = normsig4psd(sigVec, sampFreq, psdPosFreq, 1);

% Calculate the inner product of the data with the unit norm template
% This is the likelihood ratio statistic
llr = innerprodpsd(dataVec, templateVec, sampFreq, psdPosFreq);

% GLRT is the square of the likelihood ratio
glrt = llr^2;

end