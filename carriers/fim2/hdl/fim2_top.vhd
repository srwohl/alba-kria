-- FIM2 PL top level.
--
-- Connects the block design's ports to the SOM240 connector pins. The pin
-- mapping is the one in the original kria_starter_kit_wrapper.vhd; pins are
-- associated directly in the port map, so inputs and outputs both reach the
-- I/O buffers inside FIM2_HWInterface. Bits the design does not use are left
-- on unconnected signals and their pins are not declared.
--
-- Bring-up layer 3: FIM2_HWInterface (LED1, shift register, PMOD debug
-- pins and its inputs). Pins are set in fim2_top.xdc.
library ieee;
use ieee.std_logic_1164.all;

entity fim2_top is
    port (
        -- hw_clk_25MHz, 25 MHz board clock
        som240_2_b57 : inout std_logic;
        -- LED1
        som240_2_b58 : out   std_logic;
        -- PMOD(1..5, 8)
        som240_1_b18, som240_1_d20, som240_1_d21, som240_1_d22,
        som240_1_b20, som240_1_c22 : inout std_logic;
        -- HPA_p/HPA_n(0..10), LVDS inputs
        som240_1_a12, som240_1_a13, som240_1_c12, som240_1_c13,
        som240_1_b10, som240_1_b11, som240_1_c9,  som240_1_c10,
        som240_1_a9,  som240_1_a10, som240_1_b7,  som240_1_b8,
        som240_1_c6,  som240_1_c7,  som240_1_d4,  som240_1_d5,
        som240_1_d7,  som240_1_d8,  som240_1_d10, som240_1_d11,
        som240_1_d13, som240_1_d14 : inout std_logic;
        -- HPB_p/HPB_n(0..2), LVDS inputs
        som240_1_b4,  som240_1_b5,  som240_1_c3,  som240_1_c4,
        som240_1_a3,  som240_1_a4 : inout std_logic;
        -- HPB_p/HPB_n(4..9), LVDS outputs
        som240_2_a26, som240_2_a27, som240_2_a29, som240_2_a30,
        som240_2_a32, som240_2_a33, som240_2_a35, som240_2_a36,
        som240_2_a38, som240_2_a39, som240_2_a41, som240_2_a42 : inout std_logic;
        -- LPA(0..6), shift register
        som240_2_d44, som240_2_d45, som240_2_d46, som240_2_c46,
        som240_2_c47, som240_2_c48, som240_2_d48 : inout std_logic;
        -- LPB(0, 3..8)
        som240_2_a52, som240_2_b50, som240_2_b49, som240_2_b48,
        som240_2_a48, som240_2_a47, som240_2_a46 : inout std_logic
    );
end entity fim2_top;

architecture structure of fim2_top is
    component fim2_bd is
        port (
            LPA_0        : inout std_logic_vector(8 downto 0);
            LPB_0        : inout std_logic_vector(8 downto 0);
            I2C_SCL_0    : out   std_logic;
            I2C_SDA_0    : inout std_logic;
            LED1         : out   std_logic;
            PMOD_0       : inout std_logic_vector(8 downto 1);
            hw_clk_25MHz : inout std_logic;
            HPA_p_0      : inout std_logic_vector(10 downto 0);
            HPA_n_0      : inout std_logic_vector(10 downto 0);
            HPB_p_0      : inout std_logic_vector(10 downto 0);
            HPB_n_0      : inout std_logic_vector(10 downto 0)
        );
    end component fim2_bd;

    -- Bits FIM2_HWInterface does not use
    signal nc_i2c_sda : std_logic;
    signal nc_pmod_6, nc_pmod_7 : std_logic;
    signal nc_hpb_p_3, nc_hpb_n_3, nc_hpb_p_10, nc_hpb_n_10 : std_logic;
    signal nc_lpa_7, nc_lpa_8, nc_lpb_1, nc_lpb_2 : std_logic;
begin
    bd_i : component fim2_bd
        port map (
            hw_clk_25MHz => som240_2_b57,
            LED1         => som240_2_b58,
            I2C_SCL_0    => open,
            I2C_SDA_0    => nc_i2c_sda,

            PMOD_0(1) => som240_1_b18,
            PMOD_0(2) => som240_1_d20,
            PMOD_0(3) => som240_1_d21,
            PMOD_0(4) => som240_1_d22,
            PMOD_0(5) => som240_1_b20,
            PMOD_0(6) => nc_pmod_6,
            PMOD_0(7) => nc_pmod_7,
            PMOD_0(8) => som240_1_c22,

            HPA_p_0(0) => som240_1_a12,
            HPA_p_0(1) => som240_1_c12,
            HPA_p_0(2) => som240_1_b10,
            HPA_p_0(3) => som240_1_c9,
            HPA_p_0(4) => som240_1_a9,
            HPA_p_0(5) => som240_1_b7,
            HPA_p_0(6) => som240_1_c6,
            HPA_p_0(7) => som240_1_d4,
            HPA_p_0(8) => som240_1_d7,
            HPA_p_0(9) => som240_1_d10,
            HPA_p_0(10) => som240_1_d13,
            HPA_n_0(0) => som240_1_a13,
            HPA_n_0(1) => som240_1_c13,
            HPA_n_0(2) => som240_1_b11,
            HPA_n_0(3) => som240_1_c10,
            HPA_n_0(4) => som240_1_a10,
            HPA_n_0(5) => som240_1_b8,
            HPA_n_0(6) => som240_1_c7,
            HPA_n_0(7) => som240_1_d5,
            HPA_n_0(8) => som240_1_d8,
            HPA_n_0(9) => som240_1_d11,
            HPA_n_0(10) => som240_1_d14,

            HPB_p_0(0) => som240_1_b4,
            HPB_p_0(1) => som240_1_c3,
            HPB_p_0(2) => som240_1_a3,
            HPB_p_0(3) => nc_hpb_p_3,
            HPB_p_0(4) => som240_2_a26,
            HPB_p_0(5) => som240_2_a29,
            HPB_p_0(6) => som240_2_a32,
            HPB_p_0(7) => som240_2_a35,
            HPB_p_0(8) => som240_2_a38,
            HPB_p_0(9) => som240_2_a41,
            HPB_p_0(10) => nc_hpb_p_10,
            HPB_n_0(0) => som240_1_b5,
            HPB_n_0(1) => som240_1_c4,
            HPB_n_0(2) => som240_1_a4,
            HPB_n_0(3) => nc_hpb_n_3,
            HPB_n_0(4) => som240_2_a27,
            HPB_n_0(5) => som240_2_a30,
            HPB_n_0(6) => som240_2_a33,
            HPB_n_0(7) => som240_2_a36,
            HPB_n_0(8) => som240_2_a39,
            HPB_n_0(9) => som240_2_a42,
            HPB_n_0(10) => nc_hpb_n_10,

            LPA_0(0) => som240_2_d44,
            LPA_0(1) => som240_2_d45,
            LPA_0(2) => som240_2_d46,
            LPA_0(3) => som240_2_c46,
            LPA_0(4) => som240_2_c47,
            LPA_0(5) => som240_2_c48,
            LPA_0(6) => som240_2_d48,
            LPA_0(7) => nc_lpa_7,
            LPA_0(8) => nc_lpa_8,

            LPB_0(0) => som240_2_a52,
            LPB_0(1) => nc_lpb_1,
            LPB_0(2) => nc_lpb_2,
            LPB_0(3) => som240_2_b50,
            LPB_0(4) => som240_2_b49,
            LPB_0(5) => som240_2_b48,
            LPB_0(6) => som240_2_a48,
            LPB_0(7) => som240_2_a47,
            LPB_0(8) => som240_2_a46
        );
end architecture structure;
