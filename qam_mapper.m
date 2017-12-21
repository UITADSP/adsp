% Ho Ten: Ta Xuan Truong
% MSHV  : CH1702017

function symbol = qam_mapper(M, tx_bits)
    % tx_bits: input value (binary bit array)
    %       M: M-QAM constellation

    m  = 1:sqrt(M)/2;
    %tx = bi2de (tx_bits);
    tx_length = length(tx_bits);
    
    switch M
        case 16
            n = 1;
            for k = -3:2:3
                for l = -3:2:3
                    table(n) = (k + l * 1j);
                    n = n + 1;
                end
            end
            table = table([0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10] + 1); % Gray code mapping pattern for 16-QAM
            inp = reshape(tx_bits,4,tx_length/4);
            symbol = table([8 4 2 1] * inp + 1);  % maps transmitted bits into 16QAM symbols
        
        case 64
            qam_mat(1,:) = [0:(M-1)];
        otherwise
            return
    end
end