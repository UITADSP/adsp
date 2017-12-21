% Ho Ten: Ta Xuan Truong
% MSHV  : CH1702017

function rx_bits = qam_demapper(M, symbol, type)
    % symbol: input value (complex number)
    %      M: M-QAM constellation

    m = 1:sqrt(M)/2;
    symbol = reshape(symbol, length(symbol), 1);
    
    switch M
        case 16                    
            if type == 'hard'
                %rx_bits(1, :) = [0 0 0 0];
                for row = 1:size(symbol, 1)
                    Yre = real(symbol(row)); % real
                    Yim = imag(symbol(row)); % imaginary
                    
                    % first bit
                    if Yre <= 0
                        rx_bits(row, 1) = 0;
                    elseif Yre >= 0
                        rx_bits(row, 1) = 1;
                    end
                    % second bit
                    if Yre <= -2 || Yre >= 2
                        rx_bits(row, 2) = 0;
                    elseif Yre >= -2 && Yre <= 2
                        rx_bits(row, 2) = 1;
                    end
                    % third bit
                    if Yim <= 0
                        rx_bits(row, 3) = 0;
                    elseif Yim >= 0
                        rx_bits(row, 3) = 1;
                    end
                    % fourth bit
                    if Yim >= 2 || Yim <= -2
                        rx_bits(row, 4) = 0;
                    elseif Yim >=-2 && Yim <= 2
                        rx_bits(row, 4) = 1;
                    end
                end
            elseif type == 'soft'
                rx_bits = zeros(size(symbol, 1), sqrt(M));
                for row = 1:size(symbol, 1)
                    Yre = real(symbol(row)); % real
                    Yim = imag(symbol(row)); % imaginary

                    %% first bit
                    if Yre < -2
                        rx_bits(row, 1) = 2* (Yre + 1);
                    elseif Yre >= -2 && Yre < 2
                        rx_bits(row, 1) = Yre;
                    elseif Yre > 2
                        rx_bits(row, 1) = 2* (Yre - 1);
                    end

                    %% 2nd bit
                    rx_bits(row, 2) = -abs(Yre) + 2;

                    %% 3rd bit
                    if Yim < -2
                        rx_bits(row, 3) = 2* (Yim + 1);
                    elseif Yim >= -2 && Yim < 2
                        rx_bits(row, 3) = Yim;
                    elseif Yim > 2
                        rx_bits(row, 3) = 2* (Yim -1);
                    end

                    %% 4th bit
                    rx_bits(row, 4) = -abs(Yim) + 2;
                end
                rx_bits = (sign(rx_bits) + 1) / 2;
            else
                return
            end
                %% return result
                rx_bits = reshape(rx_bits.', 1, size(symbol, 1)*4);

        case 64
            rx_bits = zeros(size(symbol, 1), sqrt(M));
        otherwise
            return
    end
end