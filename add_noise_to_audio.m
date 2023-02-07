
filename = 'NHK5.m4a';

[y, Fs]=audioread(filename);

subplot 211
plot(1:length(y), y);
title 'Original audio';

t=0:length(y)-1;

noise = 0.2 * rand(size(y));
y = y + noise;

subplot 212
plot(1:length(y), noise);
title 'Noised audio';

noised_file_name = 'd5.m4a';
audiowrite(noised_file_name, y, Fs);
clear y, Fs

%sound(y_, Fs);