% [bits stream] --> Convolution (Channel Coding) --> QAM 16 ---> OFDM
clc
clear
close all
% begin
% N_packet = 1000; % No of iterations
N_packet = 100;
b = 4; % modulation index 1:BPSK, 2:QPSK, 4: 16 QAM, 6: 64 QAM
N_frame = 16; % No of Modulation symbols per packet
M = 16;
SNRdBs = (1:1:20);
sq2 = sqrt(2);
mode = 'sdm';
channel = 'rayleigh';
plotconst = 'on';

for i_SNR = 1:length(SNRdBs)
    SNRdB = SNRdBs(i_SNR);
    sigma = sqrt(0.5/(10^(SNRdB/10)));
    noise = 2 * (sigma^2);
    errors = [];
    for i_packet = 1:N_packet
       % Transmitter
       % input_bits
       % 0     1     1     0     
       % 0     0     0     0     
       % 0     0     0     1     
       % 0     1     0     0
       % matrix N_frame row and b column
       input_bits = randi([0 1],[N_frame,b])%randi([0 1],[1, N_frame*2])
       tx_bits = input_bits;
       %build channel coding
       %tx_bits = convolution_encode(input_bits)
       %tx_bits = reshape(tx_bits.',length(tx_bits)/b, b)
       %build 16 QAM symbols
       tx_sym = mapper(tx_bits);
       
       %16 OFDM symbols with 16 QAM symbols;
       disp('Transmitter bits 16 OFDM');
       tx_ofdm_sym = ifft(tx_sym, N_frame)

       % Environments  
       %--------------
       X = tx_ofdm_sym;
       %channel
       H = zeros(N_frame,1); % RX antenal channel
       
       if strcmp(channel,'rayleigh')
           H(:,1) = (randn(N_frame,1)+ 1i*randn(N_frame,1))/sq2;
       elseif strcmp(channel,'awgn')
           H = repmat([1,0],N_frame,1);
       else
           error('This channel is not supported');
       end
       %Receiver
       R =  H.*X+sigma*(rand(length(X),1)+1i*rand(length(X),1)) %noise = signma*awgn
       
       %Retrieve rx signal with noise
       rx_ofdm_sym_noise = R./H;
       
       % retrieve 16 QAM symbols from 16 OFDM symbols
       rx_sym = fft(rx_ofdm_sym_noise, N_frame)

       rx_bits_soft = demapper('soft', rx_sym)
       rx_bits_hard = demapper('hard', rx_sym)
       %keep error of each i packet, then we calculate BER
       error_soft = sum(abs(tx_bits - rx_bits_soft))/2;
       errors_softs(i_packet) = sum(error_soft);
       
       error_hard = sum(abs(tx_bits - rx_bits_hard))/2;
       errors_hards(i_packet) = sum(error_hard);
       
    end %end for loop for i packet
    BER_SOFT(i_SNR) = sum(errors_softs)/(N_packet*N_frame*b);
    BER_HARD(i_SNR) = sum(errors_hards)/(N_packet*N_frame*b);
end %end for loop for i SNR

figure
%Print BER vs SNR

semilogy(SNRdBs,BER_SOFT, 'bo-');
hold on;
semilogy(SNRdBs,BER_HARD, '--*r');
grid on;
legend('BER Soft', 'BER Hard');
title('QAM16 - OFDM', 'FontSize', 20, 'FontName', 'Times New Roman');
xlabel('SNR[dB]');
ylabel('Bit Error Rate');