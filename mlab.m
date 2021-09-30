STARTFREQ = 1e5;
STOPFREQ = 50e5;
FREQSTEP = 5e5;

clear FY6900;
close all;
comPort = 'COM10';

FY6900 = serialport(comPort, 115200);
setOutputState(FY6900, 1, true);
setOutputState(FY6900, 2, true);

h = DS1054Z('192.168.178.129');
len = 120000;
h.MDEPTH = 600000;
h.MDEPTH = 12000000;
h.Stop
h.T_SCALE = 1e-6;
h.Run
h.ScreenShot
loopindex = 0;

freq = STARTFREQ;

while freq <= STOPFREQ
    
    setFrequency(FY6900, freq, 1);
    setFrequency(FY6900, freq, 2);
    
    loopindex = loopindex+1;
    
    [wave, Fs, ts] = h.WaveAcquire([1 2], false);
    fs = Fs;

    inputWave = wave(:,1);
    outputWave = wave(:,2);

    capturedFreqs(loopindex) = freq;

    [inbode(loopindex) inphi(loopindex) indistortion(loopindex) infft] = plotWaveData(h,inputWave, Fs, freq, "inputwave", false);
    [outbode(loopindex),outphi(loopindex),outdistortion(loopindex),outfft, frequencies] = plotWaveData(h,outputWave, Fs, freq, "outputwave", false);

    Hfreq = outfft./infft;
    Hmag(loopindex) = interp1(frequencies, Hfreq, freq);
    Hrad(loopindex) = interp1(frequencies, angle(Hfreq), freq);
    
    fprintf('Input\n');
    disp('Peak: ');
    disp(inbode(loopindex));
    disp('THD: ');
    disp(indistortion(loopindex));
    disp('Phase: ');
    disp(inphi(loopindex));
    disp('Transfer: ');
    disp(Hmag(loopindex));
    disp('Angle: ');
    disp(Hrad(loopindex));
    fprintf('\n\nOutput\n');
    disp('Peak: ');
    disp(outbode(loopindex));
    disp('THD: ');
    disp(outdistortion(loopindex));
    disp('Phase: ');
    disp(outphi(loopindex));

    doPlot = false;
    if(doPlot)
        figure('name', 'Frequency transfer');
        plot(frequencies,abs(10*log10(Hfreq)));

        title('Frequency transfer');
         xlim([10000 10e6]);
        ylabel('Amplitude ()');
         xlabel('Frequency (Hz)');
    end
    
 freq = freq+FREQSTEP;
 
 clear wave;
 clear inputWave;
 clear outputWave;
 clear Fs;
 clear output;
end

setOutputState(FY6900, 1, false);
setOutputState(FY6900, 2, false);
figure('name','Results');

subplot(513);
plot(capturedFreqs,angle(Hmag));
title('Phase angle');
xlabel('Frequency (Hz)');
ylabel('Phase (Rad)');

subplot(514);
plot(capturedFreqs,rad2deg(Hrad));
title('Phase angle');
xlabel('Frequency (Hz)');
ylabel('Phase (Degree)');

subplot(515);
plot(capturedFreqs, outdistortion);
title('Total harmonic distortion (THD)');
xlabel('Frequency (Hz)');
ylabel('THD (dBc)');

subplot(511);
plot(capturedFreqs,abs(Hmag));
title('Magnitude transfer');
xlabel('Frequency (Hz)');
ylabel('H');

subplot(512);
plot(capturedFreqs,mag2db(abs(Hmag)));
title('Magnitude transfer');
xlabel('Frequency (Hz)');
ylabel('dB');

delete(FY6900);

function [Mag, Phase, THD, xdft, freqs] = plotWaveData(obj,waveData, Fs, freq, label, doPlot)

    if(doPlot)
        figure('name',label);
        subplot(311);
        plot(waveData);
        ylabel('Amplitude (V)');
        xlabel(['Time in ' num2str(obj.T_SCALE) ' S']);
        title('Input Signal in time domain');
    end
    
    NFFT = length(waveData);
    xdft = fft(waveData);
    xdft = xdft(1:NFFT/2+1);
    psdx = (1/(Fs*NFFT)) * abs(xdft).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);
    freqs = 0:Fs/NFFT:Fs/2;
    
    if(doPlot)
        subplot(312);
        plot(freqs,10*log10(psdx));

        xlim([10000 10e6]);
        ylabel('Amplitude ()');
        xlabel('Frequency (Hz)');
        title('Spectrum of the signal');
    end
    
    Mag = interp1(freqs, psdx, freq);
    THD = thd(waveData);
    Phi = angle(xdft);
    
    Phase = interp1(freqs, Phi, freq);
    if(doPlot)
        subplot(313);
        plot(Phi);
        title('Phase angle');
    end
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

 function setFrequency(obj, freq, channel)
    str = num2str(freq*1e6);
    if channel == 1
        query = sprintf('WMF%s\n', str);
    elseif channel == 2
        query = sprintf('WFF%s\n', str);
    else 
        disp("Invalid signal generator channel selected!");
        return;
    end
    writeline(obj, query);
    flush(obj, "input");
    if read(obj, 1, "uint8") ~= 0x0A;
        disp("Got an unexpected response from the signal generator!");
    end
 end

