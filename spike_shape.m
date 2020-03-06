function spike_shape = spike_shape(signal, spikes, fs)
    
    % Find the average shape of a neuron spikes
    %
    % INPUT:
    % signal = Raw signal
    % spikes = Spikes vector
    % fs     = Sampling frequency, expressed in Hz
    %
    % OUTPUT:
    % shape = Spikes mean shape

    % Finestra dei campioni intorno allo spike
    w = round( 0.002 * fs );
    
    % Inizializzo la matrice che conterrà i campioni intorno agli spike
    % rilevati. Le dimensioni: righe pari al numero degli spike e colonne
    % pari al numero di campioni finestrati + il campione centrale (lo
    % spike)
    m_spikes = zeros( size(spikes,1), (w*2+1) );
    
    % Per ogni spike rilevato
    for i = 1: length(spikes)
        
        % Posizione dello spike corrente
        c = spikes(i);
        
        % Costruisco la matrice contenente tante righe quanti sono gli
        % spike rilevati e per ogni spike tante colonne quanti sono i
        % campioni finestrati intorno allo spike
        m_spikes(i,:) = signal( c-w:c+w );
        
    end

    % Eseguo la media di tutti gli spike rilevati, per estrapolare la forma dello spike
    spike_shape = mean( m_spikes );

    % Mostro la forma dello spike
    figure;
    plot(spike_shape);
    title('Spike Shape');
    % xlabel('Samples');
    % ylabel('Amplitude');

end 