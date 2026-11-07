# Pin constraints for fim2_top, added layer by layer during bring-up. Pins,
# standards and drive come from the original constraints in fim2.xdc, which
# is kept as supplied and not loaded. Signal names are FIM2_HWInterface's.

# 25 MHz board clock and LED1 (bank 44, powered by the carrier at som240_2_d59;
# LVCMOS18 as in fim2.xdc: check the FIM2 schematic for 1.8 V)
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS18} [get_ports som240_2_b57] ;# hw_clk_25MHz, IO_L8P_HDGC_44
create_clock -period 40.000 -name hw_clk_25MHz [get_ports som240_2_b57]
set_property -dict {PACKAGE_PIN AB14 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 4} [get_ports som240_2_b58] ;# LED1, IO_L8N_HDGC_44

# PMOD debug header (bank 45)
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 4} [get_ports som240_1_b18] ;# PMOD(1), IO_L2N_AD14N_45
set_property -dict {PACKAGE_PIN E10  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 4} [get_ports som240_1_d20] ;# PMOD(2), IO_L7P_HDGC_45
set_property -dict {PACKAGE_PIN D10  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 4} [get_ports som240_1_d21] ;# PMOD(3), IO_L7N_HDGC_45
set_property -dict {PACKAGE_PIN C11  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 4} [get_ports som240_1_d22] ;# PMOD(4), IO_L9P_AD11P_45
set_property -dict {PACKAGE_PIN B10  IOSTANDARD LVCMOS33} [get_ports som240_1_b20] ;# PMOD(5), IO_L9N_AD11N_45
set_property -dict {PACKAGE_PIN B11  IOSTANDARD LVCMOS33} [get_ports som240_1_c22] ;# PMOD(8), IO_L10P_AD10P_45

# HPA, LVDS inputs (bank 66). No on-chip termination, as in fim2.xdc.
set_property -dict {PACKAGE_PIN F7   IOSTANDARD LVDS} [get_ports som240_1_a13] ;# HPA_n(0), IO_L16N_T2U_N7_QBC_AD3N_66
set_property -dict {PACKAGE_PIN G8   IOSTANDARD LVDS} [get_ports som240_1_a12] ;# HPA_p(0), IO_L16P_T2U_N6_QBC_AD3P_66
set_property -dict {PACKAGE_PIN D6   IOSTANDARD LVDS} [get_ports som240_1_c13] ;# HPA_n(1), IO_L13N_T2L_N1_GC_QBC_66
set_property -dict {PACKAGE_PIN D7   IOSTANDARD LVDS} [get_ports som240_1_c12] ;# HPA_p(1), IO_L13P_T2L_N0_GC_QBC_66
set_property -dict {PACKAGE_PIN D5   IOSTANDARD LVDS} [get_ports som240_1_b11] ;# HPA_n(2), IO_L14N_T2L_N3_GC_66
set_property -dict {PACKAGE_PIN E5   IOSTANDARD LVDS} [get_ports som240_1_b10] ;# HPA_p(2), IO_L14P_T2L_N2_GC_66
set_property -dict {PACKAGE_PIN A4   IOSTANDARD LVDS} [get_ports som240_1_c10] ;# HPA_n(3), IO_L10N_T1U_N7_QBC_AD4N_66
set_property -dict {PACKAGE_PIN B4   IOSTANDARD LVDS} [get_ports som240_1_c9] ;# HPA_p(3), IO_L10P_T1U_N6_QBC_AD4P_66
set_property -dict {PACKAGE_PIN F6   IOSTANDARD LVDS} [get_ports som240_1_a10] ;# HPA_n(4), IO_L15N_T2L_N5_AD11N_66
set_property -dict {PACKAGE_PIN G6   IOSTANDARD LVDS} [get_ports som240_1_a9] ;# HPA_p(4), IO_L15P_T2L_N4_AD11P_66
set_property -dict {PACKAGE_PIN A3   IOSTANDARD LVDS} [get_ports som240_1_b8] ;# HPA_n(5), IO_L9N_T1L_N5_AD12N_66
set_property -dict {PACKAGE_PIN B3   IOSTANDARD LVDS} [get_ports som240_1_b7] ;# HPA_p(5), IO_L9P_T1L_N4_AD12P_66
set_property -dict {PACKAGE_PIN F3   IOSTANDARD LVDS} [get_ports som240_1_c7] ;# HPA_n(6), IO_L4N_T0U_N7_DBC_AD7N_66
set_property -dict {PACKAGE_PIN G3   IOSTANDARD LVDS} [get_ports som240_1_c6] ;# HPA_p(6), IO_L4P_T0U_N6_DBC_AD7P_66
set_property -dict {PACKAGE_PIN E2   IOSTANDARD LVDS} [get_ports som240_1_d5] ;# HPA_n(7), IO_L3N_T0L_N5_AD15N_66
set_property -dict {PACKAGE_PIN F2   IOSTANDARD LVDS} [get_ports som240_1_d4] ;# HPA_p(7), IO_L3P_T0L_N4_AD15P_66
set_property -dict {PACKAGE_PIN D1   IOSTANDARD LVDS} [get_ports som240_1_d8] ;# HPA_n(8), IO_L2N_T0L_N3_66
set_property -dict {PACKAGE_PIN E1   IOSTANDARD LVDS} [get_ports som240_1_d7] ;# HPA_p(8), IO_L2P_T0L_N2_66
set_property -dict {PACKAGE_PIN C4   IOSTANDARD LVDS} [get_ports som240_1_d11] ;# HPA_n(9), IO_L11N_T1U_N9_GC_66
set_property -dict {PACKAGE_PIN D4   IOSTANDARD LVDS} [get_ports som240_1_d10] ;# HPA_p(9), IO_L11P_T1U_N8_GC_66
set_property -dict {PACKAGE_PIN E8   IOSTANDARD LVDS} [get_ports som240_1_d14] ;# HPA_n(10), IO_L17N_T2U_N9_AD10N_66
set_property -dict {PACKAGE_PIN F8   IOSTANDARD LVDS} [get_ports som240_1_d13] ;# HPA_p(10), IO_L17P_T2U_N8_AD10P_66

# HPB(0..2), LVDS inputs (bank 66). No on-chip termination, as in fim2.xdc.
set_property -dict {PACKAGE_PIN E3   IOSTANDARD LVDS} [get_ports som240_1_b5] ;# HPB_n(0), IO_L5N_T0U_N9_AD14N_66
set_property -dict {PACKAGE_PIN E4   IOSTANDARD LVDS} [get_ports som240_1_b4] ;# HPB_p(0), IO_L5P_T0U_N8_AD14P_66
set_property -dict {PACKAGE_PIN F1   IOSTANDARD LVDS} [get_ports som240_1_c4] ;# HPB_n(1), IO_L1N_T0L_N1_DBC_66
set_property -dict {PACKAGE_PIN G1   IOSTANDARD LVDS} [get_ports som240_1_c3] ;# HPB_p(1), IO_L1P_T0L_N0_DBC_66
set_property -dict {PACKAGE_PIN A1   IOSTANDARD LVDS} [get_ports som240_1_a4] ;# HPB_n(2), IO_L8N_T1L_N3_AD5N_66
set_property -dict {PACKAGE_PIN A2   IOSTANDARD LVDS} [get_ports som240_1_a3] ;# HPB_p(2), IO_L8P_T1L_N2_AD5P_66

# HPB(4..9), LVDS outputs (banks 64 and 65)
set_property -dict {PACKAGE_PIN H8   IOSTANDARD LVDS} [get_ports som240_2_a27] ;# HPB_n(4), IO_L24N_T3U_N11_PERSTN0_65
set_property -dict {PACKAGE_PIN H9   IOSTANDARD LVDS} [get_ports som240_2_a26] ;# HPB_p(4), IO_L24P_T3U_N10_PERSTN1_I2C_SDA_65
set_property -dict {PACKAGE_PIN AG5  IOSTANDARD LVDS} [get_ports som240_2_a30] ;# HPB_n(5), IO_L10N_T1U_N7_QBC_AD4N_64
set_property -dict {PACKAGE_PIN AG6  IOSTANDARD LVDS} [get_ports som240_2_a29] ;# HPB_p(5), IO_L10P_T1U_N6_QBC_AD4P_64
set_property -dict {PACKAGE_PIN AH1  IOSTANDARD LVDS} [get_ports som240_2_a33] ;# HPB_n(6), IO_L23N_T3U_N9_64
set_property -dict {PACKAGE_PIN AH2  IOSTANDARD LVDS} [get_ports som240_2_a32] ;# HPB_p(6), IO_L23P_T3U_N8_64
set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVDS} [get_ports som240_2_a36] ;# HPB_n(7), IO_L17N_T2U_N9_AD10N_64
set_property -dict {PACKAGE_PIN AB2  IOSTANDARD LVDS} [get_ports som240_2_a35] ;# HPB_p(7), IO_L17P_T2U_N8_AD10P_64
set_property -dict {PACKAGE_PIN AH4  IOSTANDARD LVDS} [get_ports som240_2_a39] ;# HPB_n(8), IO_L19N_T3L_N1_DBC_AD9N_64
set_property -dict {PACKAGE_PIN AG4  IOSTANDARD LVDS} [get_ports som240_2_a38] ;# HPB_p(8), IO_L19P_T3L_N0_DBC_AD9P_64
set_property -dict {PACKAGE_PIN AE7  IOSTANDARD LVDS} [get_ports som240_2_a42] ;# HPB_n(9), IO_L4N_T0U_N7_DBC_AD7N_64
set_property -dict {PACKAGE_PIN AD7  IOSTANDARD LVDS} [get_ports som240_2_a41] ;# HPB_p(9), IO_L4P_T0U_N6_DBC_AD7P_64

# LPA, shift register (bank 43)
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS33} [get_ports som240_2_d44] ;# LPA(0), IO_L5P_HDGC_AD7P_43
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS33} [get_ports som240_2_d45] ;# LPA(1), IO_L5N_HDGC_AD7N_43
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS33} [get_ports som240_2_d46] ;# LPA(2), IO_L1P_AD11P_43
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS33} [get_ports som240_2_c46] ;# LPA(3), IO_L3P_AD9P_43
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS33} [get_ports som240_2_c47] ;# LPA(4), IO_L3N_AD9N_43
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS33} [get_ports som240_2_c48] ;# LPA(5), IO_L6P_HDGC_AD6P_43
set_property -dict {PACKAGE_PIN AH10 IOSTANDARD LVCMOS33} [get_ports som240_2_d48] ;# LPA(6), IO_L1N_AD11N_43

# LPB (bank 43)
set_property -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS33} [get_ports som240_2_a52] ;# LPB(0), IO_L12N_AD0N_43
set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS33} [get_ports som240_2_b50] ;# LPB(3), IO_L8N_HDGC_AD4N_43
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports som240_2_b49] ;# LPB(4), IO_L8P_HDGC_AD4P_43
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS33} [get_ports som240_2_b48] ;# LPB(5), IO_L9N_AD3N_43
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS33} [get_ports som240_2_a48] ;# LPB(6), IO_L11P_AD1P_43
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33} [get_ports som240_2_a47] ;# LPB(7), IO_L10N_AD2N_43
set_property -dict {PACKAGE_PIN W10  IOSTANDARD LVCMOS33} [get_ports som240_2_a46] ;# LPB(8), IO_L10P_AD2P_43
