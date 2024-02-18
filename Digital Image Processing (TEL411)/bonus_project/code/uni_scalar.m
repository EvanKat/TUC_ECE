function [ outputMatrix ] = uni_scalar(input_signal,A,R)

    % levels
    L = 2^R;
    % quantization step
    Delta = (2*A) / (L);
    
    value = floor( abs(input_signal)./Delta + 0.5 );
    
    % Generate quantized image
    Q = Delta .* sign(input_signal) .* value;
    
    outputMatrix = Q;
    
end

