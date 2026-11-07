-- FIM2 PL top level.
--
-- Bring-up layer 1: LED1 toggles once a second from the 25 MHz board clock,
-- as FIM2_HWInterface does, which shows that the clock arrives and the
-- bitstream loads. The block design is instantiated so the hardware
-- handoff matches the bitstream; from layer 2 it holds the PS-to-PL AXI
-- bus and a BRAM, all inside the block design.
--
-- Ports keep the SOM240 connector names used by the original constraints
-- (carriers/fim2/xdc/fim2.xdc); pins are set in fim2_top.xdc.
library ieee;
use ieee.std_logic_1164.all;

entity fim2_top is
    port (
        som240_2_b57 : in  std_logic;  -- hw_clk_25MHz, 25 MHz board clock
        som240_2_b58 : out std_logic   -- LED1
    );
end entity fim2_top;

architecture rtl of fim2_top is
    component fim2_bd is
    end component fim2_bd;

    constant CYCLES_1S : natural := 25_000_000;
    signal count : natural range 0 to CYCLES_1S - 1 := 0;
    signal led   : std_logic := '0';
begin
    bd_i : component fim2_bd;

    process (som240_2_b57)
    begin
        if rising_edge(som240_2_b57) then
            if count = CYCLES_1S - 1 then
                count <= 0;
                led   <= not led;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    som240_2_b58 <= led;
end architecture rtl;
