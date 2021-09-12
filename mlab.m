
delete(FY6900);
comPort = 'COM10';
%delete(FY6900);
FY6900 = serialport(comPort, 115200);
setOutputState(FY6900, 2, true);
%ScreenShot(h);

h = DS1054Z('192.168.178.129');
len = 120000;
h.MDEPTH = 600000;%'AUTO';
%h.Stop
h.T_SCALE = 1e-6;
h.Run
%h.ScreenShot
%imshow(h.ScreenShot(1));
loopindex = 0;


for freq = 1e6:+2e6:5e6
    setFrequency(FY6900, freq);
    loopindex = loopindex+1;
    
[wave, Fs, ts] = h.WaveAcquire([1 2], false);
fs = Fs;

 subplot(411);
 plot(wave);
 ylabel('Amplitude (V)');
 xlabel(['Time in ' num2str(h.T_SCALE) ' S']);


 title('Input Signal in time domain');
 
 NFFT = length(wave);
 xdft = fft(wave);
 xdft = xdft(1:NFFT/2+1);
 psdx = (1/(Fs*NFFT)) * abs(xdft).^2;
 psdx(2:end-1) = 2*psdx(2:end-1);
 freqs = 0:Fs/NFFT:Fs/2;
%  NFFT = 2^nextpow2(len);
%  f=fs/2*linspace(0,1,NFFT/2+1);
%  xf = abs(fft(wave, NFFT));
%  output = xf(1:NFFT/2+1);
 
 subplot(412);
 plot(freqs,10*log10(psdx))
% plot(f, output );
 xlim([10000 10e6]);
 ylabel('Amplitude ()');
 xlabel('Frequency (Hz)');
 title('Spectrum of the signal');
 
 bode(loopindex) = interp1(freqs, psdx, freq);
 distortion(loopindex) = thd(wave(:,2));
 
 disp('Peak: ');

 disp(bode(loopindex));
 disp('THD: ');
 disp(distortion(loopindex));
% clear wave;
 clear Fs;
 clear output;
end

setOutputState(FY6900, 2, false);
subplot(413);
plot(bode);
title('Bode diagram');
xlabel('Frequency (MHz)');
ylabel('Amplitude');

subplot(414);
plot(distortion);
title('Total harmonic distortion (THD)');
xlabel('Frequency (MHz)');
ylabel('THD (dBc)');

delete(FY6900);

function [Mag, Phase, THD] = plotWaveData(waveData, subplotN)
    subplot(subplotN);
    
    NFFT = length(waveData);
    xdft = fft(waveData);
    xdft = xdft(1:NFFT/2+1);
    psdx = (1/(Fs*NFFT)) * abs(xdft).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);
    freqs = 0:Fs/NFFT:Fs/2;
    
    plot(freqs,10*log10(psdx));
    Mag = interp1(freqs, psdx, freq);
    THD = thd(waveData);
    
end

function setOutputState(obj, channel, state)
    if channel == 1
        if state == true
            query = sprintf('WMN1');
        else query = sprintf('WMN0');
        end

    elseif channel == 2
        if state == true
            query = sprintf('WFN1');
        else query = sprintf('WFN0');
        end
    else
        disp("Invalid signal generator channel selected!");
    end

    writeline(obj, query);
    flush(obj, "input");
    if read(obj, 1, "uint8") ~= 0x0A;
    disp("Got an unexpected response from the signal generator!");
    end
end

 function setFrequency(obj, freq)
    str = num2str(freq*1e6);
    query = sprintf('WFF%s\n', str);
    writeline(obj, query);
    flush(obj, "input");
    if read(obj, 1, "uint8") ~= 0x0A;
        disp("Got an unexpected response from the signal generator!");
    end
 end

