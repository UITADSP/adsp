function dsp_ex2

N_packet = 10000; % number of iterations
N_frame  = 4;    % number of modulation symbol per packet
      M  = 16;
   SNRs  = (1:1:30); % Signal to Noise Ratio (dB)

for i_SNR = 1:length(SNRs)
    SNR   = SNRs(i_SNR);
    sigma = sqrt(0.5/(10^(SNR/10)));
    
    correct_bits_soft = 0;
    correct_bits_hard = 0;
    
    for j_pkt = 1:N_packet        
        %% Transmiter
        tx_bits = randi([0 1],[1,N_frame*sqrt(M)]);
        tx_syms = qam_mapper(M, tx_bits);

        X_tx = tx_syms; % Transmit signals sent to antenna
        
        %% Environmental noise
        H = (randn(N_frame) + randn(N_frame) * 1i) / sqrt(2);
        %H = zeros(N_frame, 1) % no noise at all

        %% Receiver
        N = (randn(1, N_frame) + randn(1, N_frame) * 1i) * sigma; % White Gaussian noise
        Y = X_tx * H + N;
        
        rx_bits_soft = qam_demapper(16, Y/H, 'soft');
        rx_bits_hard = qam_demapper(16, Y/H, 'hard');
        
        tx_rx_result_soft = (tx_bits == rx_bits_soft);
        tx_rx_result_hard = (tx_bits == rx_bits_hard);
        
        correct_bits_soft = correct_bits_soft + sum(tx_rx_result_soft);
        correct_bits_hard = correct_bits_hard + sum(tx_rx_result_hard);
    end
    
    BER_soft(i_SNR) = (N_packet * N_frame * sqrt(M) - correct_bits_soft) / (N_packet * N_frame * sqrt(M));
    BER_hard(i_SNR) = (N_packet * N_frame * sqrt(M) - correct_bits_hard) / (N_packet * N_frame * sqrt(M));
end

    figure;
    semilogy(SNRs,BER_soft,'marker', '^');
    hold on;
    semilogy(SNRs,BER_hard,'marker', 'o');
    hold off;
    grid on;
    xlabel('Signal-to-Noise Ratio (dB)');
    ylabel('Bit Error Rate');
    legend('Soft','Hard')
end