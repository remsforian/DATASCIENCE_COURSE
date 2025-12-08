% Creates random numbers taken from the rand and randn functions and plots
% them on a histogram

%create empty arrays to be filled in a loop
rands = [];
randns = [];

ntrials = 10000; 

for i=0:ntrials
    rands = [rands, rand];
    randns = [randns, randn];
end

figure(1);
histogram(randns);
title('nrand distribution (no seed)')

figure(2);
histogram(rands);
title('rand distribution (no seed)')

%the randn approximates a normal distribution, while the rand was flat
%between all values of 0 and 1. This is what I expected. 

%now we will imput a random seed twice, and compare results

rng(42);

ntrials = 5000;

rands = [];
randns = [];

for i=0:ntrials
    rands = [rands, rand];
    randns = [randns, randn];
end

figure(3);
histogram(randns);
title('nrand distribution (with seed #1)')

figure(4);
histogram(rands);
title('rand distribution (with seed #1)')

rng(42);

rands = [];
randns = [];

for i=0:ntrials
    rands = [rands, rand];
    randns = [randns, randn];
end

figure(4);
histogram(randns);
title('nrand distribution (with seed #2)')

figure(5);
histogram(rands);
title('rand distribution (with seed #2)')

%when I call the rng function between the two trils (like I have) the seed
%make the generated random numbers the same, leading to the same
%distribution. If I were to call rng only once, the dists would
%be different as the random number generator applied would evolve. Running
%the program multible times would, however, give the same two dists. 