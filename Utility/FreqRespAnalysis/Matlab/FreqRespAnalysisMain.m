%==========================================================================
% 2017/05/13: Show the frequency analysis of devices
%       TODO: add microphone/speaker configuration
%==========================================================================

% 1. clean JavaSensingServer
SERVER_PORT = 50005; % remember to diable firewall for this port
close all;
import edu.umich.cse.yctung.*
JavaSensingServer.closeAll(); % close all previous open socket
pause(1.0);

% 2. build frequency sweep AudioSource for analyzing the frequency resposne
global M;
global PS;
M = [];
% csvFile = 'outputTime.csv';
PS.FS = 48000;                              % sample rate
as = AudioSource();                         % default audio source
time = 0:(1/PS.FS):0.2;                     % time
% csvwrite(csvFile, transpose(time));
signal = chirp(time, 21500, time(end), 22500);% 1000hz
signal = signal./max(abs(signal));
signal = transpose(signal);
as.signal = signal;                         % assign the signal to sense
as.repeatCnt = 202;                          % number of this audio being played
as.signalGain = 0.5;                        % gain of this sensing signal
as.preambleGain = 0.5;                      % gain of the preamble
% 3. start our SensingServer
ss = SensingServer(SERVER_PORT, @FreqRespAnalysisCallback, SensingServer.DEVICE_AUDIO_MODE_PLAY_AND_RECORD, as);
ss.startSensingAfterConnectionInit = 0; % disable auto sensing
