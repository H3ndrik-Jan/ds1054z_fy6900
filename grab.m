% Create VISA object
%DS1104Z = visa('ni','USB0::0x1AB1::0x04CE::DS1ZA220801421::INSTR');
DS1104Z = visa('ni', 'TCPIP::192.168.178.129::INSTR');
% Set the device property. In this demo, the length of the input buffer is set to 2048.
len = 65536;
fs = 65535;

 DS1104Z.InputBufferSize = len;
% % Open the VISA object created
 fopen(DS1104Z);
% % Read the waveform data
 fprintf(DS1104Z, ':wav:data?' );
% % Request the data
 [data,len]= fread(DS1104Z,len);
% % Close the VISA object
 fclose(DS1104Z);
 delete(DS1104Z);
 clear DS1104Z;
% % Data processing. The waveform data read contains the TMC header. The length of the header is 11
% %bytes, wherein, the first 2 bytes are the TMC header denoter (#) and the width descriptor (9)
% %respectively, the 9 bytes following are the length of the data which is followed by the waveform data
% %and the last byte is the terminator (0x0A). Therefore, the effective waveform points read is from the
% %12nd to the next to last.
 wave = data(12:len-1);
 wave = wave';
 subplot(211);
 plot(wave);
 title('Input Signal in time domain');
 NFFT = 2^nextpow2(len);
 f=fs/2*linspace(0,1,NFFT/2+1);
 xf = abs(fft(wave, NFFT));

 subplot(212);
 plot(f, xf(1:NFFT/2+1));
 title('Spectrum of the signal');