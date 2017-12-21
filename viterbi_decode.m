function output_bits = viterbi_decode(input_bits, type)
    if type == 'hard'
        path_weight = 0;
        for bit = 1:2:length(input_bits)
            if input_bits(bit:bit+1) == [0 0]
                
            elseif input_bits(bit:bit+1) == [0 1]
                
            elseif input_bits(bit:bit+1) == [1 0]
                
            elseif input_bits(bit:bit+1) == [1 1]
                
            end
        end
    elseif type == 'soft'
        return
    end
end