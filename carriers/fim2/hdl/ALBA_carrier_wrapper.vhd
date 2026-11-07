----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/07/2026 04:05:14 PM
-- Design Name: 
-- Module Name: ALBA_carrier_wrapper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALBA_carrier_wrapper is
    Port ( som240_1_a10          : inout std_logic;
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
end ALBA_carrier_wrapper;

architecture Behavioral of ALBA_carrier_wrapper is

 component kria_starter_kit is
    end component;

begin


    kria_starter_kit_i : kria_starter_kit
        port map (
            -- Connexions de ports si n'hi haguessin
        );

end Behavioral;
