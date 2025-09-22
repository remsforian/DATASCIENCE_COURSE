import numpy as np
import matplotlib.pyplot as plt

# set the function generation variables
tf = 1
A = 10
a1 = 2
a2 = 5
a3 = 7

dt = 0.005 #1/sample rate

#looking at the plot the frequency domain goes to zero at about 70 Hz. This is asemptotic, so it is only an aproximation 

t = np.arange(0, tf + dt, dt) # makes array for time series equally spaced
P = a1*t + a2*t**2 + a3*t**3
f = A * np.sin(2*np.pi*P)

plt.plot(t,f,color='green',marker='o',markersize=2,linewidth=1)
plt.xlabel('Time(s)')
plt.title('Sampled signal')
plt.show()
plt.clf()

ft = np.fft.rfft(f)
freq = np.fft.rfftfreq(len(f),dt)

plt.plot(freq,np.abs(ft),color="blue")
plt.xlabel('Frequency (Hz)')
plt.title('Periodogram')
plt.show()
