
%% Load the audio signal

[origin,o_fs] = audioread('Original audios/NHK1.m4a');
[y,fs] = audioread('Distorted audios/d1.m4a');
N = length(y);

% Plot noised audio in time domain
subplot 411
plot(y)
title 'Noised audio'
xlabel 'Time'
ylabel 'Amplitude'

% Prepare to plot Fourier Transform
% Firstly I compute the df (frequency interval)
% Then I get the frequency range w
% Next, I compute DFT by using FFT algorithm of MATLAB
% After, I shift the FT to center the 0 frequency
df = fs / N;
w = (-(N/2):(N/2)-1) * df;
Y = fft(y, N) / N;
Y2 = fftshift(Y);

%% Design a bandpass filter that filters out between 700 to 12000 Hz
% Here I choose the band pass from 1Hz to 1200Hz
% These number are chosen based on my analysis on the Spectrum (Fourier Transform)
n = 2;
beginFreq = 1 / (fs/2);
endFreq = 1200 / (fs/2);
% I use function butter of MATLAB to design the bandpass filter with degree
% of 2
[b,a] = butter(n, [beginFreq, endFreq], 'bandpass');

%% Filter the signal
% Here I filter back the signal in time-domain
out = filter(b, a, y);
subplot 412
plot(out)
title 'Filtered audio'
xlabel 'Time'
ylabel 'Amplitude'

% I also plot the independently collected audio for refrerence and
% observation
subplot 413
plot(origin)
title 'Original audio'
xlabel 'Time'
ylabel 'Amplitude'

% Now I compute the predicted noise by subtraction
predicted_noise = y-out;

% Then plot the noise
subplot 414
plot(predicted_noise);
title 'Predicted Noised'
xlabel 'Time'
ylabel 'Amplitude'


%% Evaluation: Calculate SNR (Signal to Noise ratio)

SNR = snr(out, predicted_noise)

%% Evaluation: Check MSE (Mean Square Error) between processed signal and original signal

% In here I have to cut off a difference between predicted audio and the
% original one as they dont have the same length due to independent
% collection.
if length(out) > length(origin)
    out = out(1:length(origin));
end 
if length(out) < length(origin)
    origin = origin(1:length(out));
end

% I use function immse of MATLAB for calculating the mean square error
MSE = immse(origin, out)


%% Construct audioplayer object and play

p = audioplayer(out * 6, fs);
p.play;