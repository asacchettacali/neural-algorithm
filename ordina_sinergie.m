function [sorted] = ordina_sinergie( H_Mean, W, sinergies )
    
    % Calcolo l'ordine di attivazione delle sinergie e le rappresento
    % graficamente
    %
    % INPUT
    % H_Mean:    Mean matrix of H
    % W:         Sinergy vectors
    % sinergies: Number of sinergies
    %
    % OUTPUT
    % ord: Activation coefficients sorting vector
    
    % Generate a vector containing the max mean value for all sinergies
    [~, max_means] = max(H_Mean');
    
    % Generate a vector containing the indexes of the ASC sorted max_means 
    [~, sorted] = sort(max_means);

    % Faccio il plot delle sinergie e dei coefficienti di attivazione riordinati
    for i = 1:sinergies

        % Grafico a barre di W (sinergie)
        subplot(sinergies, 2, 2*i-1);
        bar( W(:, sorted(i) ), 'k');

        % Grafico di H mean (coeff. di attivazione)
        subplot(sinergies, 2, 2*i);
        plot( H_Mean( sorted(i),: ), 'k');

    end
    
end
