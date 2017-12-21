function dsp_hw1
    A = [6, 2, 9, 7; 1, 3, 4, 7; 6, 2, 1, 8; 5, 9, 6, 0];
    
	disp("A = ");
    disp(A);
    
    B = A - 2;
    disp("B = ");
    disp(B);
    
    G = A + B;
    disp("G = ");
    disp(G);
    
    C = A ^ (-1);
    disp("C = ");
    disp(C);
    
    D = A * C;
    disp("D = ");
    disp(D);
    
    H = D * 3;
    disp("H = ");
    disp(H);
    
    %F = A ^ H;
    %disp("F = ");
    %disp(F);
    
    A = rand(10);
	disp("A = ");
    disp(A);
    
    SNR = [10,   12,        14,        16,        18,        20,        22,        24,        26; ...
           1e-1, 1e-2,      1e-3,      10^(-3.2), 10^(-3.5), 10^(-3.6), 10^(-3.8), 1e-4,      1e-5; ...
           1e-2, 10^(-2.5), 10^(-3.1), 10^(-3.2), 10^(-3.7), 10^(-3.9), 10^(-4.2), 10^(-4.9), 1e-6];
    
    figure;
    plot(SNR(1, :), SNR(2, :), SNR(1, :), SNR(3, :));
    xlabel('SNR - Higher is better');
    ylabel('BER - Lower is better');
    legend('System 1','System 2')
end