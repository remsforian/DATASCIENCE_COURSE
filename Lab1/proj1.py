import numpy as np
import matplotlib.pyplot as plt

# set the global variables
dt = 0.001
tf = 1
N = int(tf/dt)
A = 10
a1 = 10
a2 = 3
a3 = 3

t = np.arange(0, tf + dt, dt)
P = a1*t + a2*t**2 + a3*t**3
f = A * np.sin(2*np.pi*P)
#plt.plot(,t, f)
plt.plot(t,f,color='green',marker='o',markersize=2,linewidth=1)
plt.xlabel('Time(s)')
plt.title('Sampled signal')
plt.show()
plt.clf()

ft = np.fft.rfft(f)
freq = np.fft.rfftfreq(len(f),dt)
maxfreq = 100 #as to not plot whole long tail
freqmask = freq <= maxfreq

plt.plot(freq[freqmask],np.abs(ft)[freqmask],color="blue")
plt.xlabel('Frequency (Hz)')
plt.title('Periodogram')
plt.show()
