--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
--Date        : Wed Oct  7 11:16:58 2026
--Host        : pc447 running 64-bit Debian GNU/Linux 12 (bookworm)
--Command     : generate_target kria_starter_kit_wrapper.bd
--Design      : kria_starter_kit_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity kria_starter_kit_wrapper is
  port (
    som240_1_a10          : inout std_logic;
        som240_1_a12          : inout std_logic;
        som240_1_a13          : inout std_logic;
        som240_1_a15          : inout std_logic;
        som240_1_a16          : inout std_logic;
        som240_1_a17          : inout std_logic;
        som240_1_a3           : inout std_logic;
        som240_1_a4           : inout std_logic;
        som240_1_a6           : inout std_logic;
        som240_1_a7           : inout std_logic;
        som240_1_a9           : inout std_logic;
        som240_1_b10          : inout std_logic;
        som240_1_b11          : inout std_logic;
        som240_1_b16          : inout std_logic;
        som240_1_b17          : inout std_logic;
        som240_1_b18          : inout std_logic;
        som240_1_b2           : inout std_logic;
        som240_1_b20          : inout std_logic;
        som240_1_b21          : inout std_logic;
        som240_1_b22          : inout std_logic;
        som240_1_b4           : inout std_logic;
        som240_1_b5           : inout std_logic;
        som240_1_b7           : inout std_logic;
        som240_1_b8           : inout std_logic;
        som240_1_b1           : inout std_logic;
        som240_1_c10          : inout std_logic;
        som240_1_c12          : inout std_logic;
        som240_1_c13          : inout std_logic;
        som240_1_c18          : inout std_logic;
        som240_1_c19          : inout std_logic;
        som240_1_c20          : inout std_logic;
        som240_1_c22          : inout std_logic;
        som240_1_c23          : inout std_logic;
        som240_1_c24          : inout std_logic;
        som240_1_c3           : inout std_logic;
        som240_1_c4           : inout std_logic;
        som240_1_c6           : inout std_logic;
        som240_1_c7           : inout std_logic;
        som240_1_c9           : inout std_logic;
        som240_1_d10          : inout std_logic;
        som240_1_d11          : inout std_logic;
        som240_1_d13          : inout std_logic;
        som240_1_d14          : inout std_logic;
        som240_1_d16          : inout std_logic;
        som240_1_d17          : inout std_logic;
        som240_1_d18          : inout std_logic;
        som240_1_d20          : inout std_logic;
        som240_1_d21          : inout std_logic;
        som240_1_d22          : inout std_logic;
        som240_1_d4           : inout std_logic;
        som240_1_d5           : inout std_logic;
        som240_1_d7           : inout std_logic;
        som240_1_d8           : inout std_logic;
        
        som240_2_a11          : inout std_logic;
        som240_2_a12          : inout std_logic;
        som240_2_a14          : inout std_logic;
        som240_2_a15          : inout std_logic;
        som240_2_a17          : inout std_logic;
        som240_2_a18          : inout std_logic;
        som240_2_a20          : inout std_logic;
        som240_2_a21          : inout std_logic;
        som240_2_a23          : inout std_logic;
        som240_2_a24          : inout std_logic;
        som240_2_a26          : inout std_logic;
        som240_2_a27          : inout std_logic;
        som240_2_a29          : inout std_logic;
        som240_2_a3           : inout std_logic;
        som240_2_a30          : inout std_logic;
        som240_2_a32          : inout std_logic;
        som240_2_a33          : inout std_logic;
        som240_2_a35          : inout std_logic;
        som240_2_a36          : inout std_logic;
        som240_2_a38          : inout std_logic;
        som240_2_a39          : inout std_logic;
        som240_2_a4           : inout std_logic;
        som240_2_a41          : inout std_logic;
        som240_2_a42          : inout std_logic;
        som240_2_a46          : inout std_logic;
        som240_2_a47          : inout std_logic;
        som240_2_a48          : inout std_logic;
        som240_2_a50          : inout std_logic;
        som240_2_a51          : inout std_logic;
        som240_2_a52          : inout std_logic;
        som240_2_a54          : inout std_logic;
        som240_2_a55          : inout std_logic;
        som240_2_a56          : inout std_logic;
        som240_2_a58          : inout std_logic;
        som240_2_a59          : inout std_logic;
        som240_2_a60          : inout std_logic;
        som240_2_a7           : inout std_logic;
        som240_2_a8           : inout std_logic;
        som240_2_b1           : inout std_logic;
        som240_2_b10          : inout std_logic;
        som240_2_b12          : inout std_logic;
        som240_2_b13          : inout std_logic;
        som240_2_b15          : inout std_logic;
        som240_2_b16          : inout std_logic;
        som240_2_b18          : inout std_logic;
        som240_2_b19          : inout std_logic;
        som240_2_b2           : inout std_logic;
        som240_2_b21          : inout std_logic;
        som240_2_b22          : inout std_logic;
        som240_2_b24          : inout std_logic;
        som240_2_b25          : inout std_logic;
        som240_2_b27          : inout std_logic;
        som240_2_b28          : inout std_logic;
        som240_2_b30          : inout std_logic;
        som240_2_b31          : inout std_logic;
        som240_2_b33          : inout std_logic;
        som240_2_b34          : inout std_logic;
        som240_2_b36          : inout std_logic;
        som240_2_b37          : inout std_logic;
        som240_2_b39          : inout std_logic;
        som240_2_b40          : inout std_logic;
        som240_2_b44          : inout std_logic;
        som240_2_b45          : inout std_logic;
        som240_2_b46          : inout std_logic;
        som240_2_b48          : inout std_logic;
        som240_2_b49          : inout std_logic;
        som240_2_b5           : inout std_logic;
        som240_2_b50          : inout std_logic;
        som240_2_b52          : inout std_logic;
        som240_2_b53          : inout std_logic;
        som240_2_b54          : inout std_logic;
        som240_2_b56          : inout std_logic;
        som240_2_b57          : inout std_logic;
        som240_2_b58          : inout std_logic;
        som240_2_b6           : inout std_logic;
        som240_2_b9           : inout std_logic;
        som240_2_c11          : inout std_logic;
        som240_2_c12          : inout std_logic;
        som240_2_c14          : inout std_logic;
        som240_2_c15          : inout std_logic;
        som240_2_c17          : inout std_logic;
        som240_2_c18          : inout std_logic;
        som240_2_c20          : inout std_logic;
        som240_2_c21          : inout std_logic;
        som240_2_c23          : inout std_logic;
        som240_2_c24          : inout std_logic;
        som240_2_c26          : inout std_logic;
        som240_2_c27          : inout std_logic;
        som240_2_c29          : inout std_logic;
        som240_2_c3           : inout std_logic;
        som240_2_c30          : inout std_logic;
        som240_2_c32          : inout std_logic;
        som240_2_c33          : inout std_logic;
        som240_2_c35          : inout std_logic;
        som240_2_c36          : inout std_logic;
        som240_2_c38          : inout std_logic;
        som240_2_c39          : inout std_logic;
        som240_2_c4           : inout std_logic;
        som240_2_c41          : inout std_logic;
        som240_2_c42          : inout std_logic;
        som240_2_c46          : inout std_logic;
        som240_2_c47          : inout std_logic;
        som240_2_c48          : inout std_logic;
        som240_2_c50          : inout std_logic;
        som240_2_c51          : inout std_logic;
        som240_2_c52          : inout std_logic;
        som240_2_c54          : inout std_logic;
        som240_2_c55          : inout std_logic;
        som240_2_c56          : inout std_logic;
        som240_2_c58          : inout std_logic;
        som240_2_c59          : inout std_logic;
        som240_2_c60          : inout std_logic;
        som240_2_c7           : inout std_logic;
        som240_2_c8           : inout std_logic;
        som240_2_d12          : inout std_logic;
        som240_2_d13          : inout std_logic;
        som240_2_d15          : inout std_logic;
        som240_2_d16          : inout std_logic;
        som240_2_d18          : inout std_logic;
        som240_2_d19          : inout std_logic;
        som240_2_d2           : inout std_logic;
        som240_2_d21          : inout std_logic;
        som240_2_d22          : inout std_logic;
        som240_2_d24          : inout std_logic;
        som240_2_d25          : inout std_logic;
        som240_2_d27          : inout std_logic;
        som240_2_d28          : inout std_logic;
        som240_2_d30          : inout std_logic;
        som240_2_d31          : inout std_logic;
        som240_2_d33          : inout std_logic;
        som240_2_d34          : inout std_logic;
        som240_2_d36          : inout std_logic;
        som240_2_d37          : inout std_logic;
        som240_2_d39          : inout std_logic;
        som240_2_d40          : inout std_logic;
        som240_2_d44          : inout std_logic;
        som240_2_d45          : inout std_logic;
        som240_2_d46          : inout std_logic;
        som240_2_d48          : inout std_logic;
        som240_2_d49          : inout std_logic;
        som240_2_d5           : inout std_logic;
        som240_2_d50          : inout std_logic;
        som240_2_d52          : inout std_logic;
        som240_2_d53          : inout std_logic;
        som240_2_d54          : inout std_logic;
        som240_2_d56          : inout std_logic;
        som240_2_d57          : inout std_logic;
        som240_2_d58          : inout std_logic;
        som240_2_d6           : inout std_logic;
        som240_2_d9           : inout std_logic
  );
end kria_starter_kit_wrapper;




architecture STRUCTURE of kria_starter_kit_wrapper is
  component kria_starter_kit is
  port (
    LPA_0 : inout STD_LOGIC_VECTOR ( 8 downto 0 );
    LPB_0 : inout STD_LOGIC_VECTOR ( 8 downto 0 );
    I2C_SCL_0 : out STD_LOGIC;
    I2C_SDA_0 : inout STD_LOGIC;
    LED1 : out STD_LOGIC;
    PMOD_0 : inout STD_LOGIC_VECTOR ( 8 downto 1 );
    HPB_p_0  : inout STD_LOGIC_VECTOR ( 10 downto 0 );
    HPB_n_0  : inout STD_LOGIC_VECTOR ( 10 downto 0 );
    HPA_p_0  : inout STD_LOGIC_VECTOR ( 10 downto 0 );
    HPA_n_0  : inout STD_LOGIC_VECTOR ( 10 downto 0 );
    hw_clk_25MHz : inout STD_LOGIC
  );
  end component kria_starter_kit;
  

  
  
  -- Constant per definir els cicles en 1 segon (100 MHz) 100_000_000
    constant CYCLES_1S : unsigned(23 downto 0) := to_unsigned(25_000, 24);
    
    -- Comptador fins a 99,999,999 (necessita un integer o 27 bits)
    signal counter : unsigned (23 downto 0);
  
  --signal PMOD_o_i  :  STD_LOGIC_VECTOR (8 downto 1);
  signal LED1, LED1_r                       : std_logic;
  signal HPA_n, HPA_p                      : std_logic_vector(10 downto 0);
  signal HPB_p, HPB_n                      : std_logic_vector(10 downto 0);
  signal I2C_SCL_0                  : std_logic;
  signal I2C_SDA_0                  : std_logic;
  signal LPA                      : std_logic_vector(8 downto 0);
  signal LPB                      : std_logic_vector(8 downto 0);
  signal PMOD_0                     : std_logic_vector(8 downto 1);
  signal CLK25MHz                   : std_logic;
  
begin
kria_starter_kit_i: component kria_starter_kit
     port map (
      HPA_p_0(10 downto 0) => HPA_p(10 downto 0),
      HPA_n_0(10 downto 0) => HPA_n(10 downto 0),
      HPB_p_0(10 downto 0) => HPB_p(10 downto 0),
      HPB_n_0(10 downto 0) => HPB_n(10 downto 0),
      I2C_SCL_0 => I2C_SCL_0,
      I2C_SDA_0 => I2C_SDA_0,
      LED1 => LED1,
      LPA_0(8 downto 0) => LPA(8 downto 0),
      LPB_0(8 downto 0) => LPB(8 downto 0),
      PMOD_0(8 downto 1) => PMOD_0(8 downto 1),
      hw_clk_25MHz => CLK25MHz 
    );
    
    
     

  som240_1_b18 <= PMOD_0(1);
  som240_1_d20 <= PMOD_0(2);
  som240_1_d21 <= PMOD_0(3);
  som240_1_d22 <= PMOD_0(4);
  som240_1_b20 <= PMOD_0(5);
  som240_1_b21 <= PMOD_0(6);
  som240_1_b22 <= PMOD_0(7);
  som240_1_c22 <= PMOD_0(8);
  som240_2_b58 <= LED1;
  
  som240_1_a12 <= HPA_p(0);
  som240_1_a13 <= HPA_n(0);
  som240_1_c12 <= HPA_p(1);
  som240_1_c13 <= HPA_n(1);
  som240_1_b10 <= HPA_p(2);
  som240_1_b11 <= HPA_n(2);
  som240_1_c9 <= HPA_p(3);
  som240_1_c10 <= HPA_n(3);
  som240_1_a9 <= HPA_p(4);
  som240_1_a10 <= HPA_n(4);
  som240_1_b7 <= HPA_p(5);
  som240_1_b8 <= HPA_n(5);
  som240_1_c6 <= HPA_p(6);
  som240_1_c7 <= HPA_n(6);
  som240_1_d4 <= HPA_p(7);
  som240_1_d5 <= HPA_n(7);
  som240_1_d7 <= HPA_p(8);
  som240_1_d8 <= HPA_n(8);
  som240_1_d10 <= HPA_p(9);
  som240_1_d11 <= HPA_n(9);
  som240_1_d13 <= HPA_p(10);
  som240_1_d14 <= HPA_n(10);
  
  som240_1_b4  <= HPB_p(0);
  som240_1_b5  <= HPB_n(0);
  som240_1_c3  <= HPB_p(1);
  som240_1_c4  <= HPB_n(1);
  som240_1_a3  <= HPB_p(2);
  som240_1_a4  <= HPB_n(2);
  som240_1_b1  <= HPB_p(3);
  som240_1_b2  <= HPB_n(3);
  som240_2_a26 <= HPB_p(4);
  som240_2_a27 <= HPB_n(4);
  som240_2_a29 <= HPB_p(5);
  som240_2_a30 <= HPB_n(5);
  som240_2_a32 <= HPB_p(6);
  som240_2_a33 <= HPB_n(6);
  som240_2_a35 <= HPB_p(7);  
  som240_2_a36 <= HPB_n(7);
  som240_2_a38 <= HPB_p(8);
  som240_2_a39 <= HPB_n(8);
  som240_2_a41 <= HPB_p(9);
  som240_2_a42 <= HPB_n(9);
  som240_2_a59 <= HPB_p(10);
  som240_2_a60 <= HPB_n(10);  
    
  som240_2_d44 <= LPA(0);
  som240_2_d45 <= LPA(1);
  som240_2_d46 <= LPA(2);
  som240_2_c46 <= LPA(3);
  som240_2_c47 <= LPA(4);
  som240_2_c48 <= LPA(5);
  som240_2_d48 <= LPA(6);
  som240_2_d49 <= LPA(7);
  som240_2_d50 <= LPA(8);    
  
  som240_2_a46 <= LPB(8); 
  som240_2_a47 <= LPB(7); 
  som240_2_a48 <= LPB(6); 
  som240_2_b48 <= LPB(5); 
  som240_2_b49 <= LPB(4); 
  som240_2_b50 <= LPB(3); 
  som240_2_a50 <= LPB(2); 
  som240_2_a51 <= LPB(1); 
  som240_2_a52 <= LPB(0);   
   
  
  CLK25MHz <= som240_2_b57;
  
end STRUCTURE;
