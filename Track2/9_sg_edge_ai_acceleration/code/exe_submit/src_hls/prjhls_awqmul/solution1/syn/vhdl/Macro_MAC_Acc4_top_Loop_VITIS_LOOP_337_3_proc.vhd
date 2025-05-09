-- ==============================================================
-- Generated by Vitis HLS v2024.2
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Macro_MAC_Acc4_top_Loop_VITIS_LOOP_337_3_proc is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    p_read : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read1 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read2 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read3 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read4 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read5 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read6 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read7 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read8 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read9 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read10 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read11 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read12 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read13 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read14 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read15 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read16 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read17 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read18 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read19 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read20 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read21 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read22 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read23 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read24 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read25 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read26 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read27 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read28 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read29 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read30 : IN STD_LOGIC_VECTOR (31 downto 0);
    p_read31 : IN STD_LOGIC_VECTOR (31 downto 0);
    out_r : OUT STD_LOGIC_VECTOR (127 downto 0);
    out_r_ap_vld : OUT STD_LOGIC );
end;


architecture behav of Macro_MAC_Acc4_top_Loop_VITIS_LOOP_337_3_proc is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv2_3 : STD_LOGIC_VECTOR (1 downto 0) := "11";
    constant ap_const_lv2_2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv2_1 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_lv3_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    constant ap_const_lv3_1 : STD_LOGIC_VECTOR (2 downto 0) := "001";
    constant ap_const_lv128_lc_1 : STD_LOGIC_VECTOR (127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    constant ap_const_lv3_7 : STD_LOGIC_VECTOR (2 downto 0) := "111";

attribute shreg_extract : string;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_block_state1_pp0_stage0_iter0 : BOOLEAN;
    signal icmp_ln337_fu_636_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_condition_exit_pp0_iter0_stage0 : STD_LOGIC;
    signal ap_loop_exit_ready : STD_LOGIC;
    signal ap_ready_int : STD_LOGIC;
    signal icmp_ln3386_reg_319 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_ln338_fu_624_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_phi_mux_icmp_ln3386_phi_fu_322_p4 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_loop_init : STD_LOGIC;
    signal ap_phi_mux_empty_phi_fu_332_p8 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_6_fu_535_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_phi_reg_pp0_iter0_empty_reg_329 : STD_LOGIC_VECTOR (31 downto 0);
    signal empty_52_fu_429_p1 : STD_LOGIC_VECTOR (1 downto 0);
    signal select_ln351_14_fu_463_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_10_fu_499_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_2_fu_571_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_phi_mux_empty_49_phi_fu_345_p8 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_4_fu_517_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_phi_reg_pp0_iter0_empty_49_reg_342 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_12_fu_445_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_8_fu_481_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_fu_553_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_phi_mux_empty_50_phi_fu_358_p8 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_5_fu_526_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_phi_reg_pp0_iter0_empty_50_reg_355 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_13_fu_454_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_9_fu_490_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_1_fu_562_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_phi_mux_empty_51_phi_fu_371_p8 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_7_fu_544_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_phi_reg_pp0_iter0_empty_51_reg_368 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_15_fu_472_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_11_fu_508_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal select_ln351_3_fu_580_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal indvar_flatten2_fu_104 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal add_ln337_1_fu_439_p2 : STD_LOGIC_VECTOR (2 downto 0);
    signal ap_sig_allocacmp_indvar_flatten2_load : STD_LOGIC_VECTOR (2 downto 0);
    signal ch3_fu_108 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal ch_fu_421_p3 : STD_LOGIC_VECTOR (2 downto 0);
    signal ap_sig_allocacmp_ch3_load : STD_LOGIC_VECTOR (2 downto 0);
    signal group4_fu_112 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal group_fu_618_p2 : STD_LOGIC_VECTOR (1 downto 0);
    signal ap_sig_allocacmp_group4_load : STD_LOGIC_VECTOR (1 downto 0);
    signal add_ln3377_fu_116 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal add_ln337_fu_630_p2 : STD_LOGIC_VECTOR (2 downto 0);
    signal ap_sig_allocacmp_add_ln3377_load : STD_LOGIC_VECTOR (2 downto 0);
    signal or_ln353_8_fu_605_p5 : STD_LOGIC_VECTOR (127 downto 0);
    signal out_r_preg : STD_LOGIC_VECTOR (127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    signal select_ln337_fu_413_p3 : STD_LOGIC_VECTOR (1 downto 0);
    signal icmp_ln351_fu_433_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal bitcast_ln353_3_fu_601_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal bitcast_ln353_2_fu_597_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal bitcast_ln353_1_fu_593_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal bitcast_ln353_fu_589_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_continue_int : STD_LOGIC;
    signal ap_done_int : STD_LOGIC;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_start_int : STD_LOGIC;
    signal ap_ready_sig : STD_LOGIC;
    signal ap_done_sig : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;

    component Macro_MAC_Acc4_top_flow_control_loop_pipe IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_start_int : OUT STD_LOGIC;
        ap_loop_init : OUT STD_LOGIC;
        ap_ready_int : IN STD_LOGIC;
        ap_loop_exit_ready : IN STD_LOGIC;
        ap_loop_exit_done : IN STD_LOGIC;
        ap_continue_int : OUT STD_LOGIC;
        ap_done_int : IN STD_LOGIC;
        ap_continue : IN STD_LOGIC );
    end component;



begin
    flow_control_loop_pipe_U : component Macro_MAC_Acc4_top_flow_control_loop_pipe
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => ap_start,
        ap_ready => ap_ready_sig,
        ap_done => ap_done_sig,
        ap_start_int => ap_start_int,
        ap_loop_init => ap_loop_init,
        ap_ready_int => ap_ready_int,
        ap_loop_exit_ready => ap_condition_exit_pp0_iter0_stage0,
        ap_loop_exit_done => ap_done_int,
        ap_continue_int => ap_continue_int,
        ap_done_int => ap_done_int,
        ap_continue => ap_continue);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_done_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_done_reg <= ap_const_logic_0;
            else
                if ((ap_continue_int = ap_const_logic_1)) then 
                    ap_done_reg <= ap_const_logic_0;
                elsif (((ap_loop_exit_ready = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    out_r_preg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                out_r_preg <= ap_const_lv128_lc_1;
            else
                if (((ap_loop_exit_ready = ap_const_logic_1) and (icmp_ln337_fu_636_p2 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                    out_r_preg <= or_ln353_8_fu_605_p5;
                end if; 
            end if;
        end if;
    end process;


    add_ln3377_fu_116_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                add_ln3377_fu_116 <= add_ln337_fu_630_p2;
            end if;
        end if;
    end process;

    ch3_fu_108_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                ch3_fu_108 <= ch_fu_421_p3;
            end if;
        end if;
    end process;

    group4_fu_112_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                group4_fu_112 <= group_fu_618_p2;
            end if;
        end if;
    end process;

    indvar_flatten2_fu_104_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                indvar_flatten2_fu_104 <= add_ln337_1_fu_439_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((icmp_ln337_fu_636_p2 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                icmp_ln3386_reg_319 <= icmp_ln338_fu_624_p2;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_CS_fsm, ap_CS_fsm_state1, ap_block_state1_pp0_stage0_iter0)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                ap_NS_fsm <= ap_ST_fsm_state1;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;
    add_ln337_1_fu_439_p2 <= std_logic_vector(unsigned(ap_sig_allocacmp_indvar_flatten2_load) + unsigned(ap_const_lv3_1));
    add_ln337_fu_630_p2 <= std_logic_vector(unsigned(ch_fu_421_p3) + unsigned(ap_const_lv3_1));
    ap_CS_fsm_state1 <= ap_CS_fsm(0);

    ap_ST_fsm_state1_blk_assign_proc : process(ap_block_state1_pp0_stage0_iter0)
    begin
        if ((ap_const_boolean_1 = ap_block_state1_pp0_stage0_iter0)) then 
            ap_ST_fsm_state1_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state1_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_block_state1_pp0_stage0_iter0_assign_proc : process(ap_done_reg, ap_start_int)
    begin
                ap_block_state1_pp0_stage0_iter0 <= ((ap_start_int = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1));
    end process;


    ap_condition_exit_pp0_iter0_stage0_assign_proc : process(ap_CS_fsm_state1, ap_block_state1_pp0_stage0_iter0, icmp_ln337_fu_636_p2)
    begin
        if (((icmp_ln337_fu_636_p2 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_1;
        else 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_0;
        end if; 
    end process;

    ap_done <= ap_done_sig;

    ap_done_int_assign_proc : process(ap_CS_fsm_state1, ap_done_reg, ap_block_state1_pp0_stage0_iter0, ap_loop_exit_ready)
    begin
        if (((ap_loop_exit_ready = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_done_int <= ap_const_logic_1;
        else 
            ap_done_int <= ap_done_reg;
        end if; 
    end process;


    ap_idle_assign_proc : process(ap_CS_fsm_state1, ap_start_int)
    begin
        if (((ap_start_int = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;

    ap_loop_exit_ready <= ap_condition_exit_pp0_iter0_stage0;

    ap_phi_mux_empty_49_phi_fu_345_p8_assign_proc : process(empty_52_fu_429_p1, select_ln351_4_fu_517_p3, ap_phi_reg_pp0_iter0_empty_49_reg_342, select_ln351_12_fu_445_p3, select_ln351_8_fu_481_p3, select_ln351_fu_553_p3)
    begin
        if ((empty_52_fu_429_p1 = ap_const_lv2_0)) then 
            ap_phi_mux_empty_49_phi_fu_345_p8 <= select_ln351_fu_553_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_1)) then 
            ap_phi_mux_empty_49_phi_fu_345_p8 <= select_ln351_8_fu_481_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_2)) then 
            ap_phi_mux_empty_49_phi_fu_345_p8 <= select_ln351_12_fu_445_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_3)) then 
            ap_phi_mux_empty_49_phi_fu_345_p8 <= select_ln351_4_fu_517_p3;
        else 
            ap_phi_mux_empty_49_phi_fu_345_p8 <= ap_phi_reg_pp0_iter0_empty_49_reg_342;
        end if; 
    end process;


    ap_phi_mux_empty_50_phi_fu_358_p8_assign_proc : process(empty_52_fu_429_p1, select_ln351_5_fu_526_p3, ap_phi_reg_pp0_iter0_empty_50_reg_355, select_ln351_13_fu_454_p3, select_ln351_9_fu_490_p3, select_ln351_1_fu_562_p3)
    begin
        if ((empty_52_fu_429_p1 = ap_const_lv2_0)) then 
            ap_phi_mux_empty_50_phi_fu_358_p8 <= select_ln351_1_fu_562_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_1)) then 
            ap_phi_mux_empty_50_phi_fu_358_p8 <= select_ln351_9_fu_490_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_2)) then 
            ap_phi_mux_empty_50_phi_fu_358_p8 <= select_ln351_13_fu_454_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_3)) then 
            ap_phi_mux_empty_50_phi_fu_358_p8 <= select_ln351_5_fu_526_p3;
        else 
            ap_phi_mux_empty_50_phi_fu_358_p8 <= ap_phi_reg_pp0_iter0_empty_50_reg_355;
        end if; 
    end process;


    ap_phi_mux_empty_51_phi_fu_371_p8_assign_proc : process(empty_52_fu_429_p1, select_ln351_7_fu_544_p3, ap_phi_reg_pp0_iter0_empty_51_reg_368, select_ln351_15_fu_472_p3, select_ln351_11_fu_508_p3, select_ln351_3_fu_580_p3)
    begin
        if ((empty_52_fu_429_p1 = ap_const_lv2_0)) then 
            ap_phi_mux_empty_51_phi_fu_371_p8 <= select_ln351_3_fu_580_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_1)) then 
            ap_phi_mux_empty_51_phi_fu_371_p8 <= select_ln351_11_fu_508_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_2)) then 
            ap_phi_mux_empty_51_phi_fu_371_p8 <= select_ln351_15_fu_472_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_3)) then 
            ap_phi_mux_empty_51_phi_fu_371_p8 <= select_ln351_7_fu_544_p3;
        else 
            ap_phi_mux_empty_51_phi_fu_371_p8 <= ap_phi_reg_pp0_iter0_empty_51_reg_368;
        end if; 
    end process;


    ap_phi_mux_empty_phi_fu_332_p8_assign_proc : process(select_ln351_6_fu_535_p3, ap_phi_reg_pp0_iter0_empty_reg_329, empty_52_fu_429_p1, select_ln351_14_fu_463_p3, select_ln351_10_fu_499_p3, select_ln351_2_fu_571_p3)
    begin
        if ((empty_52_fu_429_p1 = ap_const_lv2_0)) then 
            ap_phi_mux_empty_phi_fu_332_p8 <= select_ln351_2_fu_571_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_1)) then 
            ap_phi_mux_empty_phi_fu_332_p8 <= select_ln351_10_fu_499_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_2)) then 
            ap_phi_mux_empty_phi_fu_332_p8 <= select_ln351_14_fu_463_p3;
        elsif ((empty_52_fu_429_p1 = ap_const_lv2_3)) then 
            ap_phi_mux_empty_phi_fu_332_p8 <= select_ln351_6_fu_535_p3;
        else 
            ap_phi_mux_empty_phi_fu_332_p8 <= ap_phi_reg_pp0_iter0_empty_reg_329;
        end if; 
    end process;


    ap_phi_mux_icmp_ln3386_phi_fu_322_p4_assign_proc : process(ap_CS_fsm_state1, icmp_ln3386_reg_319, ap_loop_init)
    begin
        if (((ap_loop_init = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_phi_mux_icmp_ln3386_phi_fu_322_p4 <= ap_const_lv1_0;
        else 
            ap_phi_mux_icmp_ln3386_phi_fu_322_p4 <= icmp_ln3386_reg_319;
        end if; 
    end process;

    ap_phi_reg_pp0_iter0_empty_49_reg_342 <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    ap_phi_reg_pp0_iter0_empty_50_reg_355 <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    ap_phi_reg_pp0_iter0_empty_51_reg_368 <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    ap_phi_reg_pp0_iter0_empty_reg_329 <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    ap_ready <= ap_ready_sig;

    ap_ready_int_assign_proc : process(ap_CS_fsm_state1, ap_block_state1_pp0_stage0_iter0)
    begin
        if (((ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_ready_int <= ap_const_logic_1;
        else 
            ap_ready_int <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_allocacmp_add_ln3377_load_assign_proc : process(ap_CS_fsm_state1, ap_loop_init, add_ln3377_fu_116)
    begin
        if (((ap_loop_init = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_sig_allocacmp_add_ln3377_load <= ap_const_lv3_1;
        else 
            ap_sig_allocacmp_add_ln3377_load <= add_ln3377_fu_116;
        end if; 
    end process;


    ap_sig_allocacmp_ch3_load_assign_proc : process(ap_CS_fsm_state1, ap_loop_init, ch3_fu_108)
    begin
        if (((ap_loop_init = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_sig_allocacmp_ch3_load <= ap_const_lv3_0;
        else 
            ap_sig_allocacmp_ch3_load <= ch3_fu_108;
        end if; 
    end process;


    ap_sig_allocacmp_group4_load_assign_proc : process(ap_CS_fsm_state1, ap_loop_init, group4_fu_112)
    begin
        if (((ap_loop_init = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_sig_allocacmp_group4_load <= ap_const_lv2_0;
        else 
            ap_sig_allocacmp_group4_load <= group4_fu_112;
        end if; 
    end process;


    ap_sig_allocacmp_indvar_flatten2_load_assign_proc : process(ap_CS_fsm_state1, ap_loop_init, indvar_flatten2_fu_104)
    begin
        if (((ap_loop_init = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_sig_allocacmp_indvar_flatten2_load <= ap_const_lv3_0;
        else 
            ap_sig_allocacmp_indvar_flatten2_load <= indvar_flatten2_fu_104;
        end if; 
    end process;

    bitcast_ln353_1_fu_593_p1 <= ap_phi_mux_empty_50_phi_fu_358_p8;
    bitcast_ln353_2_fu_597_p1 <= ap_phi_mux_empty_phi_fu_332_p8;
    bitcast_ln353_3_fu_601_p1 <= ap_phi_mux_empty_51_phi_fu_371_p8;
    bitcast_ln353_fu_589_p1 <= ap_phi_mux_empty_49_phi_fu_345_p8;
    ch_fu_421_p3 <= 
        ap_sig_allocacmp_add_ln3377_load when (ap_phi_mux_icmp_ln3386_phi_fu_322_p4(0) = '1') else 
        ap_sig_allocacmp_ch3_load;
    empty_52_fu_429_p1 <= ch_fu_421_p3(2 - 1 downto 0);
    group_fu_618_p2 <= std_logic_vector(unsigned(select_ln337_fu_413_p3) + unsigned(ap_const_lv2_1));
    icmp_ln337_fu_636_p2 <= "1" when (ap_sig_allocacmp_indvar_flatten2_load = ap_const_lv3_7) else "0";
    icmp_ln338_fu_624_p2 <= "1" when (group_fu_618_p2 = ap_const_lv2_2) else "0";
    icmp_ln351_fu_433_p2 <= "1" when (select_ln337_fu_413_p3 = ap_const_lv2_1) else "0";
    or_ln353_8_fu_605_p5 <= (((bitcast_ln353_3_fu_601_p1 & bitcast_ln353_2_fu_597_p1) & bitcast_ln353_1_fu_593_p1) & bitcast_ln353_fu_589_p1);

    out_r_assign_proc : process(ap_CS_fsm_state1, ap_block_state1_pp0_stage0_iter0, icmp_ln337_fu_636_p2, ap_loop_exit_ready, or_ln353_8_fu_605_p5, out_r_preg)
    begin
        if (((ap_loop_exit_ready = ap_const_logic_1) and (icmp_ln337_fu_636_p2 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            out_r <= or_ln353_8_fu_605_p5;
        else 
            out_r <= out_r_preg;
        end if; 
    end process;


    out_r_ap_vld_assign_proc : process(ap_CS_fsm_state1, ap_block_state1_pp0_stage0_iter0, icmp_ln337_fu_636_p2, ap_loop_exit_ready)
    begin
        if (((ap_loop_exit_ready = ap_const_logic_1) and (icmp_ln337_fu_636_p2 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_state1_pp0_stage0_iter0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            out_r_ap_vld <= ap_const_logic_1;
        else 
            out_r_ap_vld <= ap_const_logic_0;
        end if; 
    end process;

    select_ln337_fu_413_p3 <= 
        ap_const_lv2_0 when (ap_phi_mux_icmp_ln3386_phi_fu_322_p4(0) = '1') else 
        ap_sig_allocacmp_group4_load;
    select_ln351_10_fu_499_p3 <= 
        p_read21 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read20;
    select_ln351_11_fu_508_p3 <= 
        p_read23 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read22;
    select_ln351_12_fu_445_p3 <= 
        p_read9 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read8;
    select_ln351_13_fu_454_p3 <= 
        p_read11 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read10;
    select_ln351_14_fu_463_p3 <= 
        p_read13 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read12;
    select_ln351_15_fu_472_p3 <= 
        p_read15 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read14;
    select_ln351_1_fu_562_p3 <= 
        p_read27 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read26;
    select_ln351_2_fu_571_p3 <= 
        p_read29 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read28;
    select_ln351_3_fu_580_p3 <= 
        p_read31 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read30;
    select_ln351_4_fu_517_p3 <= 
        p_read1 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read;
    select_ln351_5_fu_526_p3 <= 
        p_read3 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read2;
    select_ln351_6_fu_535_p3 <= 
        p_read5 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read4;
    select_ln351_7_fu_544_p3 <= 
        p_read7 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read6;
    select_ln351_8_fu_481_p3 <= 
        p_read17 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read16;
    select_ln351_9_fu_490_p3 <= 
        p_read19 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read18;
    select_ln351_fu_553_p3 <= 
        p_read25 when (icmp_ln351_fu_433_p2(0) = '1') else 
        p_read24;
end behav;
