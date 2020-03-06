% Load the raw signal
load('Syn.mat');

% Numero dei muscoli
muscles = 9;

% filtro passa-banda sul segnale EMG
[aa, bb] = butter(3,[20 400]/(fs/2), 'bandpass');

% Filtra il segnale originale con il passa banda IIR
EMG_filt = filtfilt(aa, bb, emg);

% Filtro passa-basso
[a, b] = butter(3, 5/(fs/2), 'low');
% freqz(a,b)

% Rettifichiamo il segnale
rectified_emg = abs(EMG_filt);

% Filtriamo il segnale rettificato ottenendo l'inviluppo
envelope = filtfilt(a, b, rectified_emg );
plot(envelope(:,1));
title('Envelope - Single Muscle');

% Derivo "angolo" ottenendo un vettore colonna composto dalle derivate (pendenze) di ogni punto dell'angolo della pedalata, i picchi
% saranno esaltati avendo la pendenza massima
ang_derivates = abs(diff(ang));


% Vogliamo sfoltire il precedente vettore, recuperando solo i picchi (di
% ampiezza maggiore di 10)
[~, peaks_positions] = findpeaks(ang_derivates, 'minpeakheight', 10);


% Inizializziamo la matrice delle attività coordinate
M = [];

% Set resampling points
resampling_points = 100;

% Per ogni pedalata
for k = 1:length(peaks_positions)-1
    
    % Segnale filtrato corrispondente a questa pedalata
    current_cycle_signal = envelope(peaks_positions(k):peaks_positions(k+1) - 1,:);
    
    % Asse dei tempi del segnale originale
    t_orig = linspace(peaks_positions(k), peaks_positions(k+1)-1, peaks_positions(k+1) - peaks_positions(k));
    
    % Asse dei tempi del segnale normalizzato a 100 campioni
    % (per avere la percentuale della pedalata)
    t_resamp = linspace(peaks_positions(k), peaks_positions(k+1)-1, resampling_points);
    
    % Usando l'asse dei tempi normalizzato, ricampioniamo il segnale
    % a partire dall'asse dei tempi originale
    envelope_resampled = interp1(t_orig, current_cycle_signal, t_resamp);
    
    % Trova i picchi massimi di ogni pedalata, sulla porzione di segnale
    % normalizzato
    envelope_resampled_peaks(k, :) = max(envelope_resampled);
    
    % Matrice delle attività coordinate
    M = [M; envelope_resampled];
end

% Usiamo la mediana anziché la media perché più resistente agli outlier
% Troviamo la mediana dei picchi di ogni muscolo
envelope_resampled_peaks_medians = median(envelope_resampled_peaks);

% Per ogni mediana / pedalata
for j = 1:length(envelope_resampled_peaks_medians)
    
    % Per ogni colonna/msucolo, normalizziamo i campioni rispetto alla
    % relativa mediana
    M(:,j) = M(:,j)./envelope_resampled_peaks_medians(j);
end


% Per ogni sinergia (9) calcoliamo il VAF e plottiamo
% Il valore di K utilizzabile è quello con VAF > 0.95
for k = 1:length(envelope_resampled_peaks_medians)
    [~, ~, VAF, VAF_muscle_temp] = NN_mat_fact(M, k, muscles, 3000);
    vaf_temp(k) = VAF;
    vaf_temp_muscles(k, :) = VAF_muscle_temp;
end
figure;
plot(vaf_temp_muscles);
title('VAF - Muscles');

figure;
plot(vaf_temp);
title('VAF');


% Dall'analisi grafica, abbiamo VAF > 0.9 per K = 4
k = 4;

% In uscita dalla funzione abbiamo la matrice delle sinergie muscolari W e la matrice di attivazione H.
[W, H, VAF, ~] = NN_mat_fact(M, k, muscles, 3000);

% Per rappresentare H vado a fare la media correlata dei vari coefficienti H rispetto ai singoli cicli di pedalata
H_mean = H_Mean( k, H, resampling_points );

% Vado a rappresentare graficamente le sinergie (matrice W) con i relativi coefficienti di attivazione (matrice H) ordinati temporalmente.
figure;
sorting = ordina_sinergie( H_mean, W, k );



