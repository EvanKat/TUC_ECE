function A = myLDA(Samples, Labels, NewDim)
% Input:    
%   Samples: The Data Samples 
%   Labels: The labels that correspond to the Samples
%   NewDim: The New Dimension of the Feature Vector after applying LDA

% 	A=zeros(NumFeatures,NewDim);
    
	[NumSamples NumFeatures] = size(Samples);
    NumLabels = length(Labels);
    if(NumSamples ~= NumLabels) then
        fprintf('\nNumber of Samples are not the same with the Number of Labels.\n\n');
        exit
    end
    
    Classes = unique(Labels);
    NumClasses = length(Classes); %The number of classes
    %For each class i
	%Find the necessary statistics
    % Stored in cells with the format: Label , data , Prior Probability , mean, Scatter matrix 
    for i = 1 : NumClasses
        % Name of Class
        Label = i-1;
        % Data of Class
        data = Samples(Labels==(i-1), :);
        % Class Prior Probability calculastion
        Prior_P = length(data)/NumSamples;
        % Class Mean calculastion for the wanted dimensions
%         mu =  sum(data(:,1:NewDim))/length(data);
        mu =  sum(data)/length(data);
        
        % Scatter Matrix caclulation
        S = 0;
        for k = 1:length(data)
            S = S + (data(k,:) - mu)'*(data(k,:) - mu);
        end
        S = S/length(data);
        
        row_data{i} = { Label , data , Prior_P , mu, S };
%         plot( row_data{i}{4}(1),row_data{i}{4}(2),'k.','MarkerSize',20)
    end

    % Calculate the Global Mean
    m0 = sum(Samples)/NumSamples;
%     plot( m0(1),m0(2),'k*','MarkerSize',10);
%     

    % Calculate the Within Class Scatter Matrix
    Sw = 0;
    for i = 1 : NumClasses
        Sw = Sw + row_data{i}{5};
    end
    
    % Calculate the Between Class Scatter Matrix
    Sb = 0;
    for i = 1 : NumClasses
        Sb = Sb + ( row_data{i}{3} * (row_data{i}{4} - m0) * (row_data{i}{4} - m0)' );
    end    
    
    
    % Eigen matrix EigMat=inv(Sw)*Sb
    EigMat = inv(Sw)*Sb;
    % Perform Eigendecomposition
    [eigenvectors  eigenvalues] = eig(EigMat);
    % Sorted eigenvalues and eigvectors
    eigenvalues = diag(eigenvalues);
    [eigenvalues,i]=sort(eigenvalues,1,'descend');
    eigenvalues = diag(eigenvalues);
    eigenvectors = eigenvectors(:,i);
    
    % LDA projection vectors

    A = eigenvectors(:,1:NewDim) * eigenvalues(1:NewDim,1:NewDim) * (eigenvectors(:,1:NewDim))';
    A = A/norm(A);
