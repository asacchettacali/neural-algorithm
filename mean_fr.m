function [ISI, ISI_mean, FR, FR_mean, FR_std_dev] = mean_fr(spikes, fs)

    % Given the vector of detected spikes and relative sampling frequency, 
    % calculate ISI, ISI mean, Firing Rates, FR mean and FR standard
    % deviation.
    %
    % INPUT:
    % spikes = Spikes vector (samples)
    % fs     = Sampling frequency, expressed in Hz
    %
    % OUTPUT:
    % ISI        = Inter Spike Intervals
    % ISI_mean   = ISI mean value
    % FR         = Firing Rates
    % FR_mean    = FR mean value
    % FR_std_dev = FR standard deviation

    % Passo da sample a secondi
    spikes = spikes ./fs;
    
    % Calcolo il valore ISI (Inter Spike Interval) e il suo valore medio
    ISI = diff(spikes); 
    ISI_mean = mean(ISI); 
    
    % Calcolo FR (Firing Rate), il valore medio e la standard deviation
    FR = 1 ./ ISI;   
    FR_mean = mean(FR); 
    FR_std_dev = std(FR);
    
    % Istogramma su 100 punti del FR
    % figure;
    % hist(FR, 100); 
    
    % Istogramma su 100 punti dell'ISI
    figure;
    hist(ISI, 100);
    
end
