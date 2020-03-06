function [ classes, centroids, mean_radiuses] = k_means( features, clusters )

    % Clustering using K-Means technique
    %
    % INPUT:
    % features_matrix = Matrix of detected spikes and features
    % clusters        = Number of desired clusters
    %
    % OUTPUT:
    % classes       = Clusters selector
    % centroids     = Clusters centroids
    % mean_radiuses = Clusters radiuses

    % Eventually invert the features matrix if it doesn't correspond to
    % what we expected in terms of dimensions
    if size(features, 1) < size(features, 2)
        features = features';
    end

    % Rows of features matrix correspond to the number of detected spikes
    total_spikes = length( features );

    % Retrieve "cluster" random spikes 
    random_spikes = randperm( total_spikes, clusters ); % random_vector( 1:clusters );

    % Initialize a matrix ( ex: 3 clusters x 4 features) containing all
    % features values of random spikes. We will have 4 centroids (based on 
    % 4 features values) for each cluster
    centroids = features( random_spikes, : );
    
    % Initialize the radius matrix all spike and clusters
    radiuses = zeros(total_spikes, clusters);
       
    % Initialize the vector that assign all spikes to proper cluster
    classes = zeros( total_spikes, 1 );
    
    % Initialize new_centroids matrix
    new_centroids = zeros(clusters, size(features, 2) );
    
    % Initialize mean radiuses vector
    mean_radiuses = zeros( clusters );
   
    % Set stop condition for the while loop
    stop_condition = false;
    
    % Execute a while loop until we have calculated best centroids
    while stop_condition == false
    
        % Loop all spikes in the features matrix
        for i = 1:total_spikes
            
            % Loop all clusters
            for c = 1:clusters
                
                % Calculate the radius for this spike and cluster, based on all 4
                % features of the current spike with respect to the values
                % in the current cluster centroids.
                radiuses(i,c) = sqrt( sum( features(i,:) - centroids(c,:)).^2);
                
            end
        end

        % Loop all spikes
        for k = 1:total_spikes
            
            % Assign this spike to the cluster with min radius
           [~, classes(k)] = min( radiuses(k,:) );
           
        end
        
        % Loop all clusters
        for r = 1:clusters
            
            % Now that we have assigned all spikes to proper cluster
            % we can update this cluster centroids (features values) with
            % the mean values between all the spikes previously assigned
            new_centroids(r,:) = mean( features( classes == r, :) );
            
        end
        
        % If the updated centroids (for all clusters) are identical to the 
        % previous ones then we can stop the while loop. 
        if new_centroids == centroids
            stop_condition = true;
        
        % Else we update the centroids matrix with the new values.
        else
            centroids = new_centroids;
        end

    end
    
    % Loop all clusters
    for j = 1:clusters
        
        % Calculate mean radius for this cluster
        mean_radiuses(j) = mean( radiuses( classes == j, j) );
        
    end

end