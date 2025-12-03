
axFreq = a1+2*a2+3*a3;
nyqFreq = 2*maxFreq;
a1=10;
a2=5;
a3=2;
A=10;
params = struct("linear", a1, "quadratic", a2, "cubic", a3);
dt = 1/(10*nyqFreq);
timeVec = 0:dt:2-dt;