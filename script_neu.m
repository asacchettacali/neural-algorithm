% Load the raw signal
load('Neu.mat');

% Rileva gli spikes da segnale grezzo
spikes = detect_spikes_abs(Neural_Activity, 0.40, 0.002, fs, 'raw', 0.0001);



% Estrae tutte le caratteristiche di ogni singolo picco
[features, ~] = extract_features(Neural_Activity, spikes, fs);

% Assegnamo un vettore per ogni feature
peak        = features(:,1);
peak2peak   = features(:,2);
energy      = features(:,3);
variance    = features(:,4);

% Crea un grafico per confrontare due features, utile per capire il numero
% di neuroni distinti che partecipano al segnale
figure;
plot( peak2peak, energy, 'o');



% K-Means 
% Il numero delle classi (k) deve essere uguale al numero di neuroni
[ classes, ~, ~] = k_means(features, 2 );

% Grafichiamo le due feature rispetto alle 3 classi
figure;
plot(peak2peak(classes == 1), energy(classes == 1), 'ro');
hold on;
plot(peak2peak(classes == 2), energy(classes == 2), 'go');
hold on;
title('K-MEANS | Peak-to-Peak & Energy');



% Selezioniamo gli spikes dei singoli neuroni rilevati
spikes_1 = spikes(:, classes == 1);
spikes_2 = spikes(:, classes == 2);

% Grafici dei profili medi dei 3 neuroni
shape_1 = spike_shape(Neural_Activity, spikes_1, fs);
title('NEURONE 1');

shape_2 = spike_shape(Neural_Activity, spikes_2, fs);
title('NEURONE 2');



% NEURONE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcoliamo ISI e FR
[ISI_1, ~, ~, ~, ~] = mean_fr(spikes_1, fs);
title('ISI Neurone 1');

% Calcoliamo ISI e FR - Filtrati
[ISI_1_filtered, ISI_1_filtered_mean, ~, FR_1_filtered_mean] = ISI_Filter(ISI_1, 0.0128, 0.027);
title('ISI Neurone 1 - FILTRATO');


% La durata degli spike è stata determinata utilizzando il grafico dei profili medi di ogni spike precedentemente ottenuti
% Una volta determinati gli estremi dell’intervallo dello spike viene sottratto l’estremo inferiore a quello superiore e 
% il risultato diviso per la frequenza di campionamento, in questo modo otteniamo la durata media. 
duration_1 = (36-8)/fs;


% NEURONE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcoliamo ISI e FR
[ISI_2, ~, ~, ~, ~] = mean_fr(spikes_2, fs);
title('ISI Neurone 2');

% Calcoliamo ISI e FR - Filtrati
[ISI_2_filtered, ISI_2_filtered_mean, ~, FR_2_filtered_mean] = ISI_Filter(ISI_2, 0.0171, 0.0258);
title('ISI Neurone 2 - FILTRATO');

% La durata degli spike è stata determinata utilizzando il grafico dei profili medi di ogni spike precedentemente ottenuti
% Una volta determinati gli estremi dell’intervallo dello spike viene sottratto l’estremo inferiore a quello superiore e 
% il risultato diviso per la frequenza di campionamento, in questo modo otteniamo la durata media. 
duration_2 = (27-7)/fs;



% Probabilità di sovrapposizione dei neuroni 1 e 2
sovraposition_probability_1_2 = FR_1_filtered_mean * FR_2_filtered_mean * duration_1 * duration_2;

