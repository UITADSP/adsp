function guess_output_bits = viterbi_decode(input_bits, type)

    if type == 'hard'
        %path_weight = 0;
        %path_length = 8;
        output_bits    = zeros(1, length(input_bits)/2);
        
        %output_trail   = zeros(length(input_bits)/2, path_length);
        previous_stage  = zeros(1, 2);
        output_trail_n = 1;
        
        viterbi_row     = 0;
        viterbi_path(1,:) = [0 0 0 0 0]; %[weight, decoded_index, decoded_bit, rx_bit0, rx_bit1]
        
        for bit = 1:2:length(input_bits)
            
            output_bit = is_valid_transition(previous_stage, input_bits(bit:bit+1))
            
            if output_bit ~= -1 % valid transition
                viterbi_row = viterbi_row + 1;
                viterbi_path(viterbi_row,:) = [0 (bit+1)/2 output_bit previous_stage]
                
                previous_stage = input_bits(bit:bit+1);
            else % invalid transition
                viterbi_row = viterbi_row + 1;
                viterbi_path(viterbi_row,:) = [1 (bit+1)/2 output_bit -1 -1]
                
                % trying to guess the correct pattern
                
                %previous_stage = input_bits(bit:bit+1);
            end

        end
    elseif type == 'soft'
        return
    end
end


% Valid transition table
% | Pre | 00 | 01 | 10 | 11 |
% |-----|----|----|----|----|
% |  00 |  0 | -- | -- |  1 |
% |  01 |  1 | -- | -- |  0 |
% |  10 | -- |  0 |  1 | -- |
% |  11 | -- |  1 |  0 | -- |

function output_bit = is_valid_transition(pre_bits, current_bits)
    % returns 1 or 0 if the transition is valid
    % returns -1 if the transition is invalid
    if pre_bits == [0 0]
        if current_bits == [0 0]
            output_bit = 0;
        elseif current_bits == [1 1]
            output_bit = 1;
        else
            output_bit = -1;
        end
        
    elseif pre_bits == [0 1]
        if current_bits == [0 0]
            output_bit = 1;
        elseif current_bits == [1 1]
            output_bit = 0;
        else
            output_bit = -1;
        end
        
    elseif pre_bits == [1 0]
        if current_bits == [0 1]
            output_bit = 0;
        elseif current_bits == [1 0]
            output_bit = 1;
        else
            output_bit = -1;
        end
        
    elseif pre_bits == [1 1]
        if current_bits == [0 1]
            output_bit = 1;
        elseif current_bits == [1 0]
            output_bit = 0;
        else
            output_bit = -1;
        end
    end
end

function output_bit = guess_valid_transition(pre_bits, decoded_bit)
    % returns correct current bits from previous bits
    if pre_bits == [0 0]
        if decoded_bit == 0
        elseif decoded_bit == 1
        else
            return
        end
        
    elseif pre_bits == [0 1]
        if decoded_bit == 0
        elseif decoded_bit == 1
        else
            return
        end
        
    elseif pre_bits == [1 0]
        if decoded_bit == 0
        elseif decoded_bit == 1
        else
            return
        end
        
    elseif pre_bits == [1 1]
        if decoded_bit == 0
        elseif decoded_bit == 1
        else
            return
        end

    end
end