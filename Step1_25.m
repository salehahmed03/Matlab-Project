%Step 1
fo = 440;
syms n;
fn = fo * (2^(n/12));
nC = [-9, -7, -5, -4];
nCLength = length(nC);
fs = 3500;%Calculated by calculating the largest fn from the 4 scales given, which will be 350Hz, then *10س
t = 0:1/fs:0.5;

signalNote = zeros(nCLength, length(t));

for i = 1:nCLength
    currentFreq = subs(fn, n, nC(i));
    signalNote(i, :) = cos(2 * pi * currentFreq * t);
end


for i = 1:nCLength
    subplot(nCLength, 1, i);
    plot(t, signalNote(i, :));
    title(['Note ', num2str(i)]);
end

%Step 2
xt = [signalNote(1, :) signalNote(2, :) signalNote(3, :) signalNote(4, :)];

filename = 'output_signal.wav'; 

audiowrite(filename, xt, fs);

fprintf('Audio saved as "%s".\n', filename);

%Step 3
figure;
plot(xt);
title('Sequentially Played Notes: DO-RE-MI-FA');

%Step 4
energy = sum(xt.^2/fs);
disp(['Energy of the signal: ', num2str(energy)]);

% Step 5
N = length(xt);
frequencies = (-fs/2):(fs/N):(fs/2 - fs/N);
X = fftshift(fft(xt, N));

%step 6
figure;
plot(frequencies, abs(X));
xlabel('Frequency');
ylabel('Magnitude');
title('Frequency Spectrum');
grid on;

%Step 7
energy_from_spectrum = sum(abs(X).^2/fs) / N;
disp(['Energy of the signal from frequency spectrum: ', num2str(energy_from_spectrum)]);

%Step 8 
fMI = subs(fn, n, -5); 
fFA = subs(fn, n, -4); 
fc = (fMI + fFA) / 2; 
fc = double(fc); 
[b, a] = butter(20, fc / (fs / 2), "low"); 
disp(['The cut-off frequency of the filter is: ', num2str(fc),   'Hz']);

%step 9
figure; 
freqz(b, a); 
title('Butterworth Low-Pass Filter Response'); 
xlabel('Normalized Frequency'); 
ylabel('Magnitude (dB) / Phase (rad)'); 
grid on;

%step 10
y1 = filter(b, a, xt);

%step 11
y1 = y1 / max(abs(y1));
filename_y1 = 'output_signal_y1.wav'; 
audiowrite(filename_y1, y1, fs);
fprintf('Audio saved as "%s".\n', filename_y1);

%step12
t1 = 0:1/fs:(length(y1)-1)/fs;
figure;
plot(t1, y1);
title('Signal y1 versus Time');
xlabel('Time (s)');
ylabel('Amplitude');

%step13
energy_y1 = sum(y1.^2/fs);
disp(['Energy of the signal y1: ', num2str(energy_y1)]);

%step14
N = length(y1);
Y1 = fftshift(fft(y1, N));

%step15
frequencies = (-fs/2):(fs/N):(fs/2 - fs/N);
figure;
plot(frequencies, abs(Y1));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum of y1');
grid on;

%step16
energy_y1_freq = sum(abs(Y1).^2/fs) /N;
disp(['Energy of the signal from frequency spectrum: ', num2str(energy_y1_freq)]);

%step17
fn = fo * (2^(n/12)); 
fDO = subs(fn, n, -9);
fRE = subs(fn, n ,-7);
fc_1 = (fDO+fRE)/ 2;
fc_1 = double(fc_1);
[b,a] = butter(20, fc_1 /(fs / 2) , 'high');
disp(['The cut-off frequency of the filter is: ', num2str(fc_1),   'Hz']);

%step18
figure;
freqz(b,a);
title('Butterworth High-Pass Filter Response'); 
xlabel('Normalized Frequency'); 
ylabel('Magnitude (dB) / Phase (rad)'); 
grid on;

%Step19
y2 = filter(b, a, xt);

%step20
y2 = y2 / max(abs(y2));
filename_y2 = 'output_signal_y2.wav'; 
audiowrite(filename_y2, y2, fs);
fprintf('Audio saved as "%s".\n', filename_y2);

%Step21
t2 = 0:1/fs:(length(y2)-1)/fs;
figure;
plot(t2, y2);
title('Signal y2 versus Time');
xlabel('Time (s)');
ylabel('Amplitude');

%Step22
energy_y2 = sum(y2.^2/fs);
disp(['Energy of the signal y2: ', num2str(energy_y2)]);

%Step23
N = length(y2);
Y2 = fftshift(fft(y2, N));

%Step24
frequencies = (-fs/2):(fs/N):(fs/2 - fs/N);
figure;
plot(frequencies, abs(Y2));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum of y2');
grid on;

%Step25
energy_y2_freq = sum(abs(Y2).^2/fs) /N;
disp(['Energy of the signal from frequency spectrum: ', num2str(energy_y2_freq)]);


