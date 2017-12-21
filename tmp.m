% Transmit data
X_tx = (rand(4,1)) + (rand(4,1))*1i

% Signal-to-Noise Ratio in dB
SNR = 50;

% White Gaussian noise
%N = awgn(X,SNR);

sigma = sqrt(0.5/(10^(SNR/10)));
    N = (randn(4,1) + randn(4,1) * 1i) * sigma;

% Environmental noise
H = (rand(4) + rand(4) * 1i) / sqrt(2);

% Data at receiver side
Y   = H * X_tx + N
Yn0 = H * X_tx % without noise

H_inv  = inv(H);

W_MMSE = (H.^H)/(H.^H + eye(4)/(SNR / (10 * log(10))))

X_rx_zf_nonoise = H_inv * Yn0         % without noise
X_rx_zf         = H_inv * Y           % with noise zero-forcing
%X_rx_mmse       = (W_MMSE * Y - W_MMSE * N) / (W_MMSE * H)

W_MMSE * Y - W_MMSE * N
W_MMSE * H


