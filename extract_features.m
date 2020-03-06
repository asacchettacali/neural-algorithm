function [features, m_spikes] = extract_features(signal, spikes, fs)

    % Extract several features for all the detected spikes
    %
    % INPUT:
    % signal = Raw signal
    % spikes = Detected spikes positions vector
    % fs     = Sampling frequency, expressed in Hz
    %
    % OUTPUT:
    % features = Matrix containing max_peak, peak_to_peak, energy, variance
    %            for all detected spikes
    % m_spikes = Matrix with all spikes windowed signal

    % Total detected spikes
    N = length(spikes);

    % Window width
    w = round(0.003 * fs);
    
    % Initialize m_spikes matrix with zeros
    m_spikes = zeros( size(spikes,1), (w*2+1) );
    
    % Initialize features matrix with zeros
    features = zeros( size(spikes,1), 4 );

    % For each detected spike
    for i=1:N
        
        % Current spike position
        c = spikes(i);
        
        % For this i-th spike, get the windowed portion of the raw signal
        m_spikes(i,:) = signal( c-w : c+w );

        % Find max peak of this spike
        max_peak = max( m_spikes(i,:) );
        
        % Find min peak of this spike
        min_peak = min( m_spikes(i,:) );

        % Calculate peak to peak amplitude of this spike
        peak_to_peak = max_peak - min_peak;

        % Calculate the energy of this spike
        energy = sum( abs(m_spikes(i,:)) .^2 );

        % Calculate the variance of this spike
        variance = var( m_spikes(i,:) );

        % Populate retrieved features for this spike
        features(i,:) = [max_peak peak_to_peak energy variance];

    end

end
