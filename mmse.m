function mmse

N_packet = 1000; % number of iterations
N_frame  = 4;     % number of modulation symbol per packet
      M  = 16;
   SNRs  = (1:1:30); % Signal to Noise Ratio (dB)

for i_SNR = 1:length(SNRs)
      SNR = SNRs(i_SNR);
    sigma = sqrt(0.5/(10^(SNR/10)));
    
    correct_bits_zf = 0;
    correct_bits_mmse = 0;
    
    for j_pkt = 1:N_packet        
        %% Transmiter
        tx_bits = randi([0 1],[1,N_frame*sqrt(M)]);
        %tx_syms = qam_mapper(M, tx_bits);
        tx_syms = qammod(tx_bits', M, 'InputType', 'bit');

        X_tx = tx_syms'; % Transmit signals sent to antenna
        
        %% Environmental noise
        H = (randn(N_frame) + randn(N_frame) * 1i) / sqrt(2);
        %H = zeros(N_frame, 1) % no noise at all

        %% Receiver
        N = (randn(1, N_frame) + randn(1, N_frame) * 1i) * sigma; % White Gaussian noise
        Y = X_tx * H + N;
        
        % ZF decoding weight matrix
        W_ZF = H^-1;
        
        % MMSE decoding weight matrix
        %W_MMSE      = (conj(H))/(conj(H) + eye(4)/(SNR / (10 * log(10))));
        W_MMSE      = ((conj(H) * H + (10 ^ (-SNR/10)) * eye(N_frame)) ^ -1) * conj(H);
        
        %rx_bits_zf = qam_demapper(16, Y/H, 'soft');
        rx_bits_zf = qamdemod((Y * W_ZF)', 16, 'OutputType', 'bit');
        rx_bits_zf = reshape(rx_bits_zf, 1, 16);
        
        %rx_bits_mmse = qam_demapper(16, (Y * W_MMSE)/(H * W_MMSE), 'soft');
        rx_bits_mmse = qamdemod((Y * W_MMSE)', 16, 'OutputType', 'bit');
        rx_bits_mmse = reshape(rx_bits_mmse, 1, 16);
        
        tx_rx_result_zf = (tx_bits == rx_bits_zf);
        tx_rx_result_mmse = (tx_bits == rx_bits_mmse);
        
        correct_bits_zf = correct_bits_zf + sum(tx_rx_result_zf);
        correct_bits_mmse = correct_bits_mmse + sum(tx_rx_result_mmse);
    end
    
    BER_zf(i_SNR) = (N_packet * N_frame * sqrt(M) - correct_bits_zf) / (N_packet * N_frame * sqrt(M));
    BER_mmse(i_SNR) = (N_packet * N_frame * sqrt(M) - correct_bits_mmse) / (N_packet * N_frame * sqrt(M));
end

    figure;
    %hold on;
    semilogy(SNRs,BER_zf, 'marker', '^');
    hold on;
    semilogy(SNRs,BER_mmse,'marker', 'o');
    hold off;
    grid on;
    xlabel('Signal-to-Noise Ratio (dB)');
    ylabel('Bit Error Rate');
    %ylim([-0.01 0.12]);
    %axis([0 20 10^-5 0.5])
    legend('Zero Forcing','MMSE')
end