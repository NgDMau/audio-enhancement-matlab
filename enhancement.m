
%% Load the audio signal
%[y,fs] = audioread('audio_soha_news_01.m4a');
[origin,o_fs] = audioread('Original audios/NHK1.m4a');
[y,fs] = audioread('Distorted audios/d1.m4a');
N = length(y);

subplot 411
plot(y)
title 'Noised audio'
xlabel 'Time'
ylabel 'Amplitude'

df = fs / N;
w = (-(N/2):(N/2)-1) * df;
Y = fft(y, N) / N;
Y2 = fftshift(Y);

% subplot 412
% plot(w, abs(Y2));
% title 'Fourier Transform of Noised audio'
% xlabel 'Frequency'
% ylabel '|X(w)|'

%% Design a bandpass filter that filters out between 700 to 12000 Hz
n = 2;
beginFreq = 1 / (fs/2);
endFreq = 1200 / (fs/2);
[b,a] = butter(n, [beginFreq, endFreq], 'bandpass');

%% Filter the signal
out = filter(b, a, y);
subplot 412
plot(out)
title 'Filtered audio'


subplot 413
plot(origin)
title 'Original audio'
xlabel 'Time'
ylabel 'Amplitude'


predicted_noise = y-out;

subplot 414
plot(predicted_noise);
title 'Predicted Noised'
xlabel 'Time'
ylabel 'Amplitude'


%% Calculate SNR (Signal to Noise ratio)

SNR = snr(out, predicted_noise)

%% Check MSE (Mean Square Error) between processed signal and original signal

if length(out) > length(origin)
    out = out(1:length(origin));
end 
if length(out) < length(origin)
    origin = origin(1:length(out));
end

MSE = immse(origin, out)


%% Construct audioplayer object and play

p = audioplayer(out * 6, fs);
p.play;