function [m, re, im, MetricNames] = evalComplexDamageIndices(datRef,datAlt,datRefvsAlt)
% [M, RE, MRE, IM, MIM] = evalComplexDamageIndices(datRef,datAlt,datRefvsAlt)

clear jj BU BL K PCCreal PCCimag PCCmag
% function out = evalDamageIndices(datRef,datAlt,datRefvsAlt)

    % datRef = REFERENCE vs. REFERENCE FDAC/CFDAC matrix
    % datAlt = Altered vs. Altered FDAC/CFDAC matrix
    % datRefvsAlt = FDAC/CFDAC matrix of dat1 v. dat2

    m = evalDamageIndices(abs(datRef),abs(datAlt),abs(datRefvsAlt)); % 1 x 8 vector
    re = evalDamageIndices(real(datRef),real(datAlt),real(datRefvsAlt));    
    % MRE = evalDamageIndices(abs(real(datRef)),abs(real(datAlt)),abs(real(datRefvsAlt)));
    im = evalDamageIndices(imag(datRef),imag(datAlt),imag(datRefvsAlt));    
    % MIM = evalDamageIndices(abs(imag(datRef)),abs(imag(datAlt)),abs(imag(datRefvsAlt)));

    PCCreal = corrcoef(real(datRef),real(datRefvsAlt)); re(1,9) = PCCreal(1,2);
    PCCimag = corrcoef(imag(datRef),imag(datRefvsAlt)); im(1,9) = PCCimag(1,2);
    PCCmag = corrcoef(abs(datRef),abs(datRefvsAlt));  m(1,9) = PCCmag(1,2);

    U = triu(abs(datRefvsAlt),1); 
    L = triu(abs(datRefvsAlt),-1); 

    if sum(sum(U)) > sum(sum(L))
        K = -1;
    else 
        K = 1; 
    end % (if)

    re(1,10) = K*(1-abs(re(1,9))); 
    im(1,10) = K*(1-abs(im(1,9)));
    m(1,10) = K*(1-abs(m(1,9))); 

    MetricNames = ["Sum: N vs. N", "Avg. Value: N vs. N","Sum: Ref. vs. N","Avg. Value: Ref. vs. N","DRQ",...
    "Inverse DRQ","Symmetry Quotient","Inverse Symmetry Quotient","PCC", "SCI"];

end



