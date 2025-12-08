function [fitVal,varargout] = crcfitnesstest(xVec,params)

% I am going to be looking at a different fitness function. I am going to
% look at f3 (Generalized Rosenbrock)

[nrows,~]=size(xVec);

%storage for fitness values
fitVal = zeros(nrows,1);
validPts = ones(nrows,1);

%Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
%Set fitness for invalid points to infty
fitVal(~validPts)=inf;
%Convert valid points to actual locations
xVec(validPts,:) = s2rv(xVec(validPts,:),params);


for lpc = 1:nrows
    if validPts(lpc)
    % Only the body of this blockve should be replaced for different fitness
    % functions
        x = xVec(lpc,:);
        D = length(x);
        fitVal(lpc) = sum(100*(x(2:D) - x(1:D-1).^2).^2 + (x(1:D-1) - 1).^2);
    end
end

%Return real coordinates if requested
if nargout > 1
    varargout{1}=xVec;
    if nargout > 2
        varargout{2} = r2sv(xVec,params);
    end
end