%loadlibrary('visa32.dll','visa.h','alias','visa32');
%[err, defaultRm] = calllib('visa32', 'viOpenDefaultRM', defaultRm);

% TCPIP::192.168.178.129::INSTR



delete(FY6900);
comPort = 'COM7';

FY6900 = serialport(comPort, 115200);
setFrequency(FY6900, 3000000000000);

h = DS1054Z('192.168.178.129');
%h.T_SCALE = 5e-8;
h.Run

len = 12000;
[wave, Fs, ts] = h.WaveAcquire(1, len);


fs = Fs;

 subplot(211);
 plot(wave);
 ylabel('Amplitude (V)');
 xlabel(['Time in ' num2str(h.T_SCALE) ' S']);


 title('Input Signal in time domain');
 NFFT = 2^nextpow2(len);
 f=fs/2*linspace(0,1,NFFT/2+1);
 xf = abs(fft(wave, NFFT));

 subplot(212);
 output = xf(1:NFFT/2+1);
 plot(f, output );
 xlim([10000 10e6]);
 ylabel('Amplitude ()');
 xlabel('Frequency (Hz)');
 title('Spectrum of the signal');
 
 disp('Peak: ');
 bode = interp1(f, output, 3000000);
 disp(bode);

 delete(FY6900);
 
 function setFrequency(obj, freq)
    str = num2str(freq);
    query = sprintf('WFF%s\n', str);
    writeline(obj, query);
 end

