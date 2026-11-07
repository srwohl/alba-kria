----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10/18/2026 01:15:40 PM
-- Design Name:
-- Module Name: shift_reg_ctrl - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity shift_reg_ctrl is
    Generic (
        CLK_counter: integer := 25_000;  -- Contador per generar el CLK
        G_TX_WIDTH : integer := 48;   -- Tamany per defecte del vector TX
        G_RX_WIDTH : integer := 24   -- Tamany per defecte del vector RX
    );
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        error      : out STD_LOGIC;    -- Potser millor posar una senyal d'OK. Opcio 1 clock ok. if set to 1 error.
        TX         : in  STD_LOGIC_VECTOR (G_TX_WIDTH - 1 downto 0);
        RX         : out STD_LOGIC_VECTOR (G_RX_WIDTH - 1 downto 0);
        SRCLK      : out STD_LOGIC;
        RCLK       : out STD_LOGIC;
        DATA_M2S   : out STD_LOGIC;
        nOE        : out STD_LOGIC;
        nSRCLR     : out STD_LOGIC;
        SH_nLD     : out STD_LOGIC;
        DATA_S2M   : in  STD_LOGIC
    );
end entity shift_reg_ctrl;

architecture Behavioral of shift_reg_ctrl is
constant clk_cnt_bits : integer := integer(floor(log2(real(CLK_counter))));
constant data_cnt_bits : integer := integer(ceil(log2(real(G_TX_WIDTH + G_RX_WIDTH ))));
signal DATA_CNT : unsigned (data_cnt_bits - 1 downto 0);
signal counter : unsigned (clk_cnt_bits - 1 downto 0);
signal SHR_CLK_r, nSRCLR_r	        : std_logic;
--signal SHFTREG_CLK	        : std_logic;
signal trama  : STD_LOGIC_VECTOR (G_TX_WIDTH + G_RX_WIDTH - 1 downto 0);


    -- 1. Definició dels estats de la màquina
    type state_type is (RESET, IDLE, SEND, CHECK);
    signal current_state, next_state : state_type;

    Signal state_dbg : STD_LOGIC_VECTOR (3 downto 0);

begin



    DATA_M2S <= trama(G_TX_WIDTH + G_RX_WIDTH - 1);
    --SRCLK <= SHR_CLK_r when next_state = SEND else '1';
    process(clk)
    begin
        if rising_edge(clk) then
            nSRCLR <= nSRCLR_r;
            if next_state = SEND then
                SRCLK <= SHR_CLK_r;
            else
                SRCLK <= '1';
            end if;

            if (rst = '1')  then
                counter   <= (others => '0');
                SHR_CLK_r <= '0';
                DATA_CNT <= (others => '0');

            elsif current_state /= SEND then
                SHR_CLK_r <= '1';
                DATA_CNT <= (others => '0');
                trama(G_TX_WIDTH -1 downto 0) <= TX;
            elsif counter = to_unsigned((CLK_counter /2), counter'length) then
                counter  <= (others => '0');
                if SHR_CLK_r = '1' then
                    trama(G_TX_WIDTH + G_RX_WIDTH -1 downto 0) <= trama(G_TX_WIDTH + G_RX_WIDTH - 2 downto 0) & DATA_S2M;
                    DATA_CNT <= DATA_CNT + 1;

                    SHR_CLK_r <= '0';

                else
                    SHR_CLK_r <= '1';

                end if;

            else
                counter   <= counter + 1;
            end if;
        end if;
    end process;




    -- 2. Procés seqüencial: Actualització de l'estat amb el rellotge
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= RESET; -- Estat inicial al fer reset
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;


    -- 3. Procés combinacional: Lògica de pròxim estat i sortides
    process(current_state, SHR_CLK_r)
    begin
        -- Valors per defecte per evitar latents innecessaris
        next_state <= current_state;
        -- RESET, IDLE, SEND, READ, CHECK
        case current_state is
            when RESET =>
                nSRCLR_r <= '0';
                next_state <= CHECK;
                nOE <= '1';
                RCLK  <= '0';
                SH_nLD <= '0';
                error <= '0';
                state_dbg <= x"0";

            when IDLE =>
                nSRCLR_r <= '1';
                RCLK <= '0';
                nOE <= '0';
                next_state <= SEND;

                state_dbg <= x"1";

            when SEND =>
                nSRCLR_r <= '1';
                SH_nLD <= '1';
                RCLK <= '0';
                nOE <= '0';

                if SHR_CLK_r = '1' then
                    RCLK  <= '0';
                else
                    if DATA_CNT = to_unsigned( G_TX_WIDTH + G_RX_WIDTH, DATA_CNT'length)then
                        next_state <= CHECK;

                        RX <= trama(G_RX_WIDTH + G_TX_WIDTH - 1 downto G_TX_WIDTH);
                        error <= '1';
                    end if;
                end if;
                state_dbg <= x"3";

            when CHECK =>
                nSRCLR_r <= '1';
                RCLK  <= '1';
                nOE <= '0';
                SH_nLD <= '0';

                if trama(G_TX_WIDTH-1 downto 0) = TX then
                    error <= '0';
                else
                    error <= '1';
                end if;

                next_state <= IDLE;

                state_dbg <= x"4";
             when OTHERS =>
                error <= '1';
                state_dbg <= x"5";
        end case;
    end process;



end Behavioral;