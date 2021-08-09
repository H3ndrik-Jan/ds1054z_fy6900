%loadlibrary('visa32.dll','visa.h','alias','visa32');
%[err, defaultRm] = calllib('visa32', 'viOpenDefaultRM', defaultRm);


h = DS1054Z('USB0::0x1AB1::0x04CE::DS1ZA220801421::INSTR');
[ wave, Fs, ts ] = h.WaveAcquire(1);
len = 12000;
fs = 1e9;

 subplot(211);
 plot(wave);
 title('Input Signal in time domain');
 NFFT = 2^nextpow2(len);
 f=fs/2*linspace(0,1,NFFT/2+1);
 xf = abs(fft(wave, NFFT));

 subplot(212);
 plot(f, xf(1:NFFT/2+1));
 xlim([0 10e6]);
 ylabel('Amplitude ()');
 xlabel('Frequency (Hz)');
 title('Spectrum of the signal');