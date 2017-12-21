function output_bits = convolution_encode(input_bits)
    current_stage = zeros(1, 2);
       next_stage = zeros(1, 2);
       
      output_bits = [zeros(1, length(input_bits)*2)];
    
    for bit = 1:length(input_bits)
        next_stage = [input_bits(bit), current_stage]
        
        output_bits((bit-1)*2 + 1)   = mod(input_bits(bit) + current_stage(2), 2);
        output_bits( bit   *2)       = mod(input_bits(bit) + current_stage(1) + current_stage(2), 2);
        
        current_stage = next_stage(1:length(next_stage)-1)
    end
end