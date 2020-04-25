function dxdt = MeskinStateFcnContinuous_params(t,x)
parameter_values;

dxdt = [x(5) * x(3)^g_13 - b_1 * x(1)^h_11;
        x(6) * x(1)^g_21 - b_2 * x(2)^h_22;
        x(7) * x(2)^g_32 - b_3 * x(3)^h_33 * x(4)^h_34;
        x(8) * x(1)^g_41 - b_4 * x(4)^h_44;
        0;
        0;
        0;
        0];
end
