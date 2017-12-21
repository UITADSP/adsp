function [ decodedBits ] = demapper(type, rx_sym)
%DEMAPPER Summary of this function goes here
% type: soft or hard
%   Detailed explanation goes here
    % real number to binary
    decodedBits = [];
    %rx_sym
    % we loop each row to read the encoded symbol in row
    row = size(rx_sym,1);
    for symbolRow = 1:row
        symbol = rx_sym(symbolRow,:);
        if type == 'soft' 
            bits = softbit(symbol);
        elseif type == 'hard'
            bits = hardbit(symbol);
        end 
        decodedBits = cat(1,decodedBits,bits);
    end
end
function [qam_symbol] = hardbit(realNumber)
    Yre = real(realNumber); % real part
    Yim = imag(realNumber); % imaginary part
    % range Yre <=-2, then Yim {[<=-2],[-2,0],[0,2],[>2]}
    if Yre <= -2
        if Yim <=-2
            qam_symbol = [0 0 0 0];
        end
        
        if Yim > -2 & Yim <=0
            qam_symbol = [0 0 0 1];
        end
        
        if Yim >0 & Yim <=2
            qam_symbol = [0 0 1 1];
        end
        
        if Yim >2
            qam_symbol = [0 0 1 0];
        end
    end
    % range Yre >-2 and Yre <=0, then Yim {[<=-2],[-2,0],[0,2],[>2]}
    if Yre > -2 & Yre <=0 
        if Yim <=-2
            qam_symbol = [0 1 0 0];
        end
        
        if Yim > -2 & Yim <=0
            qam_symbol = [0 1 0 1];
        end
        
        if Yim >0 & Yim <=2
            qam_symbol = [0 1 1 1];
        end
        
        if Yim >2
            qam_symbol = [0 1 1 0];
        end
    end
    % range Yre >0 and Yre <=2, then Yim {[<=-2],[-2,0],[0,2],[>2]}
    if Yre > 0 & Yre <=2 
        if Yim <=-2
            qam_symbol = [1 1 0 0];
        end
        
        if Yim > -2 & Yim <=0
            qam_symbol = [1 1 0 1];
        end
        
        if Yim >0 & Yim <=2
            qam_symbol = [1 1 1 1];
        end
        
        if Yim >2
            qam_symbol = [0 1 1 0];
        end
    end
    % range Yre >2 then Yim {[<=-2],[-2,0],[0,2],[>2]}
    if Yre > 2
        if Yim <=-2
            qam_symbol = [1 0 0 0];
        end
        
        if Yim > -2 & Yim <=0
            qam_symbol = [1 0 0 1];
        end
        
        if Yim >0 & Yim <=2
            qam_symbol = [1 0 1 1];
        end
        
        if Yim >2
            qam_symbol = [1 0 1 0];
        end
    end
end
function [symbol] = softbit(realNumber)
    Yre = real(realNumber); % real part
    Yim = imag(realNumber); % imaginary part
    b0 = 0;
    b1 = 0;
    b2 = 0;
    b3 = 0;
    
    if Yre < -2
        b0 = 2*(Yre + 1);
    elseif Yre >= -2 & Yre < 2
        b0 = Yre;
    elseif Yre >=2
        b0 = 2*(Yre - 1);
    end
    
    b1 = -abs(Yre)+2;
    
    if Yim < -2
        b2 = 2*(Yim + 1);
    elseif Yim >= -2 & Yim < 2
        b2 = Yim;
    elseif Yim >=2
        b2 = 2*(Yim - 1);
    end
    
    b3 = -abs(Yim)+2;
    
    bit0 = (sign(b0)+1)/2;
    bit1 = (sign(b1)+1)/2;
    bit2 = (sign(b2)+1)/2;
    bit3 = (sign(b3)+1)/2;
    symbol = [bit0 bit1 bit2 bit3];
end

