function [spikes] = detect_spikes_abs(signal, th, rp, fs, opt, delta)
    
    % Detect all possible spikes, with the threshold technique, using a 
    % processed signal
    %
    % INPUT:
    % signal = Raw signal
    % th     = Threshold value, expressed from 0 to 1
    % rp     = Sefractory period, expressed in seconds
    % fs     = Sampling frequency, expressed in Hz
    % opt    = Signal processing option: raw, abs, tkeo, square 
    % delta  = Delta in seconds
    %
    % OUTPUT:
    % spikes = Spikes vector
    
    % Manage selected option
    switch opt
        
        % User raw signal
        case 'raw'
            processed_signal = signal;
            
        % Use signal ABS
        case 'abs'
            processed_signal = abs(signal);
        
        % Use the square of the signal
        case 'square'
            processed_signal = signal.^2;
        
        % Use a portion of the signal
        case 'tkeo'
            
            % Convert delta from time to samples
            delta = round(delta*fs);
            
            % Initialize processed signal vector with zeros
            processed_signal = zeros( size(signal) );
            
            % Fill the processed signal 
            for k = delta+1:length(signal)-delta
                processed_signal(k) = signal(k)^2 - signal(k-delta)*signal(k+delta);
            end
        
    end
    
    % Find max value of the signal
    max_value = max(processed_signal);
    
    % Calculate theshold amplitude over signal max value
    threshold = th * max_value;
    
    % Convert refractory period from time to samples
    refractory_period = round( rp * fs );
    
    % Initialize an empty spikes matrix
    spikes = [];
    
    % Set signal index starting from the second sample in order to respect
    % the conditional statement to find a spike.
    k = 2;
    
    % Set the index for detected spikes vector
    N = 1;
    
    % Cycle all signal samples
    while k < length(processed_signal)-1
        
        % Conditional statement to find a spike, the current sample should
        % be bigger then the previous and the next samples, also bigger
        % then threshold value
        if processed_signal(k) > processed_signal(k-1) && processed_signal(k) > processed_signal(k+1) && processed_signal(k) > threshold

            % Save current k-sample in the spikes vector
            spikes(N) = k;
            
            % Increase spikes vector index
            N = N + 1;
            
            % Increase signal index by the refractory_period
            k = k + refractory_period;
        end
        
        % Increase signal index to the next sample
        k = k + 1;
        
    end 
    
    % Create the time axes
    t=linspace(0, length(signal)/fs, length(signal));

    % Plot raw signal in the first subplot
    figure;
    ax(1) = subplot(2, 1, 1);
    plot(t, signal);
    
    % Plot spikes over the raw signal
    hold on;
    plot(t(spikes), signal(spikes), 'ko');
    
    % Plot processed signal in the second subplot
    ax(2) = subplot(2,1,2);
    plot(t, processed_signal);
    
    % Plot spikes over the raw signal
    hold on;
    plot(t(spikes), processed_signal(spikes), 'ko');
    
    % Makes all input axes have identical limits. 
    % Display the same range of data in different subplots.
    linkaxes(ax, 'x');
end



