function [ISI_filtered, ISI_filtered_mean, FR_filtered, FR_filtered_mean] = ISI_Filter(ISI, min, max)

    % Filter the given Inter Spike Interval
    %
    % INPUT:
    % ISI = Inter Spike Interval
    % min = min value
    % max = max value
    %
    % OUTPUT:
    % ISI_filtered        = Inter Spike Intervals filtered
    % ISI_filtered_mean   = ISI filtered mean
    % FR_filtered         = Firing Rates filtered
    % FR_filtered_mean    = FR filtered mean

    % Indice del nuovo vettore FR filtrato che include solo i valori buoni
    index = 1; 

    % Cicliamo tutti i valori del vettore FR e popoliamo il vettore filtrato
    % solo se il valore corrente rientra nei limiti impostati (non outlier)
    for i = 1:length(ISI)
        
        current_isi = ISI(i);
        
        if ( current_isi >= min && current_isi <= max )
            ISI_filtered(1,index) = current_isi;
            index = index+1;
        end
    end
    
    % Calcoliamo ISI filtrato dal firing rate
    FR_filtered = 1 ./ ISI_filtered;
    
    % Calcoliamo FR e ISI medio
    FR_filtered_mean   = mean(FR_filtered);
    ISI_filtered_mean  = mean(ISI_filtered);

    % Plot the histogram of the filtered ISI
    figure;
    hist(ISI_filtered, 100);
    
end
