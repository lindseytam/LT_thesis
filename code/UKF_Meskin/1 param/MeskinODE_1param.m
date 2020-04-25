function dxdt = MeskinStateFcnContinuous_1param(t,x)
parameter_values;

dxdt = [x(5) * x(3)^g_13 - b_1 * x(1)^h_11;
        a_2 * x(1)^g_21 - b_2 * x(2)^h_22;
        a_3 * x(2)^g_32 - b_3 * x(3)^h_33 * x(4)^h_34;
        a_4 * x(1)^g_41 - b_4 * x(4)^h_44;
        0];
end
