import numpy as np
import matplotlib.pyplot as plt

# using the data from proj2.py I am going to follow the nyquist frequency aproximation

fmax = 70 #an aproximation of the maximum nonzero frequency. The periodogram is asemptotic, so this is not exact
nyfreq = 2*fmax #we are multiplying by 2 becausenyquist is twice bandwidth

sample_rates = [nyfreq,2*nyfreq,10*nyfreq]

for rate in sample_rates:
    #creating the set of variables
    tf = 1
    A = 10
    a1 = 2
    a2 = 5
    a3 = 7
    dt=1/rate
    print(dt)

    #sampling the function
    t = np.arange(0, tf + dt, dt)  # makes array for time series equally spaced
    P = a1 * t + a2 * t ** 2 + a3 * t ** 3
    f = A * np.sin(2 * np.pi * P)
    #plotting in real space
    plt.plot(t, f, color='green', marker='o', markersize=2, linewidth=1)
    plt.xlabel('Time(s)')
    plt.title('Sampled signal (sample rate = ' + str(rate) + ')')
    plt.show()
    plt.clf()

    #taking the fourier transform
    ft = np.fft.rfft(f)
    freq = np.fft.rfftfreq(len(f), dt)

    #plotting the periodgram
    plt.plot(freq, np.abs(ft), color="blue")
    plt.xlabel('Frequency (Hz)')
    plt.title('Periodogram (sample rate = ' + str(rate) + ')')
    plt.show()
    plt.clf()

# In real space each higher frequency the dots apear closer together, and looks slightly smother
# the periodgram only changed in the length of the tail at 0, showing that we did not add any information that is really useful.