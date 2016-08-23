function d = mydistance(u, v)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    d = 1;
    if (length(u) ~= length(v))
        error 'Lengths of Two Vector do not meet'
    else
        for i = 1:length(u)
            d = d - sqrt(u(i) * v(i));
        end
    end
end

