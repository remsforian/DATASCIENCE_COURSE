function [fitVal, varargout] = glrtqcsig4pso(xVec, params)
% Compute the fitness function for GLRT of quadratic chirp in colored noise
% This is designed to work with CRCBPSO
%
% INPUTS:
%   xVec: N×3 matrix of standardized coordinates (values between 0 and 1)
%         Each row is [x1, x2, x3] corresponding to [a1, a2, a3]
%   params: Structure containing:
%           .dataY - data vector (signal + noise)
%           .dataX - time stamps
%           .dataXSq - time stamps squared
%           .dataXCb - time stamps cubed
%           .psd - PSD values at positive DFT frequencies
%           .sampFreq - sampling frequency
%           .rmin - [a1_min, a2_min, a3_min]
%           .rmax - [a1_max, a2_max, a3_max]
%
% OUTPUTS:
%   fitVal: N×1 vector of fitness values (negative GLRT for minimization)
%   varargout{1}: Real coordinates [a1, a2, a3] for each row (if requested)
%   varargout{2}: Generated signals for each row (if requested)

[nrows, ~] = size(xVec);

% Storage for fitness values
fitVal = zeros(nrows, 1);

% Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);

% Set fitness for invalid points to infinity
fitVal(~validPts) = inf;

% Convert valid points to actual locations (standardized to real coordinates)
xVec(validPts, :) = s2rv(xVec(validPts, :), params);

% Storage for optional outputs
if nargout > 1
    realCoords = zeros(nrows, 3);
end
if nargout > 2
    estimatedSigs = zeros(nrows, length(params.dataX));
end

% Compute fitness for each valid point
for lpc = 1:nrows
    if validPts(lpc)
        % Get the real parameter values for this row
        a1 = xVec(lpc, 1);
        a2 = xVec(lpc, 2);
        a3 = xVec(lpc, 3);
        
        % Generate the quadratic chirp signal efficiently
        % (avoiding repeated calls to crcbgenqcsig for speed)
        phaseVec = a1*params.dataX + a2*params.dataXSq + a3*params.dataXCb;
        qc = sin(2*pi*phaseVec);
        
        % Normalize using the inner product for colored noise
        qcNorm = sqrt(innerprodpsd(qc, qc, params.sampFreq, params.psd));
        qc = qc / qcNorm;
        
        % Compute the inner product with data (likelihood ratio)
        llr = innerprodpsd(params.dataY, qc, params.sampFreq, params.psd);
        
        % Fitness is NEGATIVE of GLRT (because PSO minimizes)
        fitVal(lpc) = -(llr^2);
        
        % Store optional outputs
        if nargout > 1
            realCoords(lpc, :) = [a1, a2, a3];
        end
        if nargout > 2
            estimatedSigs(lpc, :) = qc;
        end
    end
end

% Return real coordinates if requested
if nargout > 1
    varargout{1} = realCoords;
    if nargout > 2
        varargout{2} = estimatedSigs;
    end
end

end