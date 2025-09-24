% Generates sum of sinusoids and filters to only allow one through 

nsamples = 2048;
srate = 1024;
dt = 1/srate;

t = 0:dt:(nsamples/srate);
A = [10,5,2.5];
f = [100,200,300];
phase = [0,pi/6,pi/4];
signal = zeros(1,length(t));

for i = 1:length(A)
    signal = signal + A(i)*sin(2*pi*f(i)*t+phase(i));
end

figure;
plot(t,signal);
xlabel('Time (s)');
title('Original Composite Signal');
grid on;

kNyq = floor(nsamples/2)+1;
fsig = fft(signal); 
posfreq = (0:(kNyq-1))*(srate/nsamples);
% keeping only the positive values for periodgram 
fsig = fsig(1:kNyq);

figure;
plot(posfreq,abs(fsig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram (Original Signal)');

% The periodgram looks like I would expect: three narrow peaks at the
% expected frequencies

% filtering for each of the individual frequencies 
order = 30; 
bandwidth = 10;
% Fix dimension: signal is row vector, so filteredsignals should match
filteredsignals = zeros(length(f), length(signal));

for i = 1:length(f)
   nyquist = srate/2;
   % Create bandpass filter centered on f(i)
   b = fir1(order, [(f(i)-bandwidth)/nyquist, (f(i)+bandwidth)/nyquist], 'bandpass');
   
   % Apply filter (store as row in filteredsignals)
   filteredsignals(i,:) = filter(b, 1, signal);
   
   % Plot filtered result
   figure;
   plot(t, filteredsignals(i,:));
   xlabel('Time (s)');
   ylabel('Amplitude');
   title(sprintf('Filtered Signal - Component at %d Hz', f(i)));
   
   kNyq = floor(nsamples/2)+1;
    fsig = fft(filteredsignals(i,:)); 
    posfreq = (0:(kNyq-1))*(srate/nsamples);
    % keeping only the positive values for periodgram 
    fsig = fsig(1:kNyq);
    figure;
    plot(posfreq,abs(fsig));
    xlabel('Frequency (Hz)');
    ylabel('|FFT|');
    title(sprintf('Periodogram of Filtered Signal - Component at %d Hz', f(i)));
end