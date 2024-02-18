function num_of_bit_errors = bit_errors(est_bit_seq, b_seq)
    num_of_bit_errors=0;
    for i=1:length(est_bit_seq)
        if est_bit_seq(i)~= b_seq(i)
            num_of_bit_errors = num_of_bit_errors + 1;
        end
    end

end

