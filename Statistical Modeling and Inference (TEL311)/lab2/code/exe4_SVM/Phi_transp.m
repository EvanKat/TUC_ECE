function omega_out = Phi_transp(omega_in)

    
[r,c] = size(omega_in);
    if r > 2
        fprinf('Input dimentions %d,%d. Need 2X2 only.',r,c);
    else
        omega_out = omega_in - (omega_in(1,:).^2 + omega_in(2,:).^2)-4; 
    end
end

