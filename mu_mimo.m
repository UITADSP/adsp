function mu_mimo
N_packet = 10000; % number of iterations
N_frame  = 4;     % number of modulation symbol per packet
N_tx     = 4;
N_rx     = 4;

      M  = 16;
SNR_dBs  = (0:1:45); % Signal to Noise Ratio (dB)

for i_SNR = 1:length(SNR_dBs)
   SNR_dB = SNR_dBs(i_SNR);
    sigma = sqrt(0.5/(10^(SNR_dB/10)));
    
    correct_bits_zf = 0;
    correct_bits_mmse = 0;
    correct_bits_ci = 0;
    
    for j_pkt = 1:N_packet
       %% Environmental noise
        H = (rand(N_tx) +rand(N_tx) *1i) / sqrt(2);
        
        % CI weight matrix
        W_CI = H'  / (H * H');

        % gammar CI for normalize
        g_CI = norm(W_CI) ^2;
        
        %% Transmitter
        tx_bits = randi([0 1],[1,N_tx*sqrt(M)]);
        
        % My QAM function
        tx_syms = qam_mapper(M, tx_bits);
        X_tx    = tx_syms;                       % Direct transmit signals sent to antenna
        U_tx    = tx_syms;
        X_tx_CI = (U_tx * W_CI) / sqrt(g_CI);    % Transmit signals sent to antenna using CI
        %X_tx_BD = ; % Transmit signals sent to antenna using BD
        
        % MatLab QAM function
        %tx_syms = qammod(tx_bits', M, 'InputType', 'bit');
        %X_tx = tx_syms'; % Transmit signals sent to antenna

        %% Receiver
        N    = (randn(1, N_rx) + randn(1, N_rx) * 1i) *sigma *3; % White Gaussian noise
        Y    = X_tx    * H + N;
        Y_CI = X_tx_CI * H + N;
        %Y = awgn(X_tx *H, SNR_dB);
        
        % Decoded received signal using CI
        U_rx_CI = sqrt(g_CI) * Y_CI;
        
        % ZF decoding weight matrix
        W_ZF   = H^-1;
        
        % MMSE decoding weight matrix
        %W_MMSE = ((H' *H + (10 ^(-SNR_dB/10)) *eye(N_tx)) ^ -1) *H';
        W_MMSE = (H' *H + (10 ^(-SNR_dB/10)) *eye(N_tx)) \H';
        
        % My QAM function
        rx_bits_zf    = qam_demapper(16, Y *W_ZF, 'hard');
        
        % MatLab QAM function
        %rx_bits_zf = qamdemod((Y * W_ZF)', 16, 'OutputType', 'bit');
        %rx_bits_zf = reshape(rx_bits_zf, 1, 16);
        
        % My QAM function
        rx_bits_mmse    = qam_demapper(16, Y *W_MMSE, 'hard');
        
        % My QAM function
        rx_bits_ci = qam_demapper(16, U_rx_CI, 'hard');
        
        % MatLab QAM function
        %rx_bits_mmse = qamdemod((Y * W_MMSE)', 16, 'OutputType', 'bit');
        %rx_bits_mmse = reshape(rx_bits_mmse, 1, 16);
        
        % Count the correct bits
        tx_rx_result_zf   = (tx_bits == rx_bits_zf);
        tx_rx_result_mmse = (tx_bits == rx_bits_mmse);
        tx_rx_result_ci   = (tx_bits == rx_bits_ci);
        
        correct_bits_zf   = sum(tx_rx_result_zf)   + correct_bits_zf;
        correct_bits_mmse = sum(tx_rx_result_mmse) + correct_bits_mmse;
        correct_bits_ci   = sum(tx_rx_result_ci)   + correct_bits_ci;
    end
    
    % Total bit transmitted
    tx_bits_total = N_packet * N_frame * sqrt(M);
    
    BER_zf  (i_SNR) = (tx_bits_total - correct_bits_zf)  / tx_bits_total;
    BER_mmse(i_SNR) = (tx_bits_total - correct_bits_mmse)/ tx_bits_total;
    BER_ci  (i_SNR) = (tx_bits_total - correct_bits_ci)  / tx_bits_total;
end
    close;
    figure;
    semilogy(SNR_dBs,BER_zf, 'marker', '^');
    hold on;
    semilogy(SNR_dBs,BER_mmse,'marker', 'o');
    semilogy(SNR_dBs,BER_ci,'marker', 'square');
    hold off;
    grid on;
    xlabel('Signal-to-Noise Ratio (dB)');
    ylabel('Bit Error Rate');
    %ylim([-0.01 0.12]);
    %axis([0 20 10^-5 0.5])
    legend('Zero Forcing', 'MMSE', 'CI')
    
	figure;
    plot(SNR_dBs,BER_zf, 'marker', '^');
    hold on;
    plot(SNR_dBs,BER_mmse,'marker', 'o');
    plot(SNR_dBs,BER_ci,'marker', 'square');
    hold off;
    grid on;
    xlabel('Signal-to-Noise Ratio (dB)');
    ylabel('Bit Error Rate');
    legend('Zero Forcing', 'MMSE', 'CI')
end