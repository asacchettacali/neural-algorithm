function [H_Mean] = H_Mean( sinergies, H, resampled_points )
    
    % Calculate the mean value of H
    %
    % INPUT:
    % sinergies        = Number of sinergies
    % H                = Synergy activation coefficients
    % resampled_points = Resampling points used on signal
    %
    % OUTPUT:
    % H_Mean = Mean matrix of H
    
    % Calculate H length
    H_length = length(H);
    
    % Initialize H_Mean matrix
    H_Mean = zeros( sinergies, resampled_points );
    
    % Loop all sinergies
    for i = 1:sinergies
        
        % Loop all resampled points
        for j = 1:resampled_points

            % Media di ogni ciclo di pedalata (composta da 100 campioni
            % concatenati)
            H_Mean(i,j) = mean( H(i, j:resampled_points:H_length) );
            
        end
    end
end

