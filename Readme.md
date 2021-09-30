# Matlab bodeplotter script for Rigol DS1054Z and Feeltech FY6900
Using this script, a bodeplot and THD can be measured and plotted using a DS1054Z oscilloscope and FY6900 function generator. 
The FY6900 signal generator is used to generate the input waveforms for the device under test (DUT). These input waveforms are expected to be connected to channel 1 of the oscilloscope.
The output of the DUT should be connected to channel 2 of the oscilloscope. The script performs a frequency sweep and measures the transfer of phase and magnitude and the THD at any interval.
The start frequency, frequency step and stop frequency can be specified. When the sweep is done, the results are plotted.
This script/class can read the waveforms on the DS1054Z oscilloscope using visa over TCP/IP. The used class for accessing the scope is https://gitlab.com/kloppertje/laservelocitymeter, 
which itself is based on https://github.com/sstobbe/mlab. A few changes to the class were necessary to get it working though. The FY6900 is controlled over USB.
