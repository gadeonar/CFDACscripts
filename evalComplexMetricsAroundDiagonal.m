function [m, re, im, vnms] = evalComplexMetricsAroundDiagonal(datRef, datAlt,datRefvsAlt,XX)

        m = MetricsAroundDiagonal(abs(datRef),abs(datAlt),abs(datRefvsAlt),XX);    
        re = MetricsAroundDiagonal(real(datRef),real(datAlt),real(datRefvsAlt),XX);    
        im = MetricsAroundDiagonal(imag(datRef),imag(datAlt),imag(datRefvsAlt),XX);    

        vnms = ["Sum: N vs. N", "Avg. Value: N vs. N","Sum: Ref. vs. N","Avg. Value: Ref. vs. N","Inverse Symmetry Quotient"];

end 