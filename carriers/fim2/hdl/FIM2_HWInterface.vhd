----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 08/11/2026 12:17:06 PM
-- Design Name:
-- Module Name: FIM2_HWInterface - Behavioral
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
Library UNISIM;
use UNISIM.vcomponents.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIM2_HWInterface is
    Port (  LED1 : out STD_LOGIC;
            HPA_p : inout STD_LOGIC_VECTOR (10 downto 0);
            HPA_n : inout STD_LOGIC_VECTOR (10 downto 0);
            LPA : inout STD_LOGIC_VECTOR (8 downto 0);
            HPB_p : inout STD_LOGIC_VECTOR (10 downto 0);
            HPB_n : inout STD_LOGIC_VECTOR (10 downto 0);
            LPB : inout STD_LOGIC_VECTOR (8 downto 0);
            I2C_SCL : out STD_LOGIC;
            I2C_SDA : inout STD_LOGIC;

            FIM_SW : out STD_LOGIC_VECTOR (19 downto 0);
            FIM_i : out STD_LOGIC_VECTOR (19 downto 0);
            FIM_o : in STD_LOGIC_VECTOR (5 downto 0);
            FIM_RST_ALRM : out STD_LOGIC;
            PMOD : inout STD_LOGIC_VECTOR (8 downto 1);
            hw_clk_25MH : inout STD_LOGIC;
            clk : in STD_LOGIC;
            reset : in STD_LOGIC);
end FIM2_HWInterface;




architecture Behavioral of FIM2_HWInterface is

component shift_reg_ctrl is
     Generic (
        CLK_counter: integer :=25_000;  -- Contador per generar el CLK
        G_TX_WIDTH : integer := 48;   -- Tamany per defecte del vector TX
        G_RX_WIDTH : integer := 24   -- Tamany per defecte del vector RX
    );
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        error      : out STD_LOGIC;
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
end component;

--component clk_generator is
--    port (
--        clk_out1 : out std_logic;
--        locked   : out std_logic;
--        reset    : in  std_logic;
--        clk_in1  : in  std_logic
--    );
--end component;


signal clk_150MHz       : std_logic;
signal rst150           : std_logic;
signal clk25Mz          : std_logic;
signal SHIFT_REG_nOE	: std_logic;
signal SHIFT_REG_RCLK	: std_logic;
signal SHIFT_REG_NSRCLR	: std_logic;
signal SHIFT_REG_SER	: std_logic;
signal SHIFT_REG_SRCLK	: std_logic;
signal FPGA_RDY	        : std_logic;
signal DATA_M2S 	    : std_logic;
signal SHR_nOE  	    : std_logic;
signal SHR_nSRCLR	    : std_logic;
signal SHR_RCLK	        : std_logic;
signal SHR_SRCLK	    : std_logic;
signal DATA_S2M	        : std_logic;
signal SH_nLD	        : std_logic;
signal FIM_FPGA_RDY     : STD_LOGIC;

-- Constant per definir els cicles en 1 segon (100 MHz) 100_000_000
    constant CYCLES_1S : unsigned(25 downto 0) := to_unsigned(25_000_000, 26);
    constant cSHR_data_in : integer := 24;
    constant cSHR_data_out : integer := 48;

    -- Comptador fins a 99,999,999 (necessita un integer o 27 bits)
    signal counter : unsigned (25 downto 0);
    signal counter1 : unsigned (25 downto 0);
signal LED1_reg	        : std_logic;
signal FIM_i_reg, FIM_i_reg1, FIM_i_reg2 :  STD_LOGIC_VECTOR (17 downto 0);
signal FIM_RST_ALRM_reg, FIM_RST_ALRM_reg1, FIM_RST_ALRM_reg2      : std_logic;
signal FIM_o_i  :  STD_LOGIC_VECTOR (5 downto 0);
signal PMOD_o_i  :  STD_LOGIC_VECTOR (8 downto 1);
signal LPB7, LPB8 : STD_LOGIC;

signal SHR_data_in :  STD_LOGIC_VECTOR (cSHR_data_in-1 downto 0);
signal SHR_data_out :  STD_LOGIC_VECTOR (cSHR_data_out-1 downto 0);
signal input_LEDS :  STD_LOGIC_VECTOR (18 downto 0);
--signal metas_index	: integer;

begin
--    FIM_SW <= (others => '0');
--    FIM_i <= (others => '0');
----    FIM_o_i <= FIM_o;
--    FIM_o_i <= "111111";


    process(clk25Mz)
    begin
        if rising_edge(clk25Mz) then
            if counter = CYCLES_1S then
                counter   <= (others => '0');
                LED1_reg <= not LED1_reg; -- Commuta el senyal cada segon
            else
                counter   <= counter + 1;
            end if;
        end if;
    end process;

    LPB7 <= LED1_reg;

    process(clk)
    begin
        if rising_edge(clk) then
--          if reset = '0' then
            if counter1 = CYCLES_1S then
                counter1   <= (others => '0');
                PMOD_o_i(2) <= not PMOD_o_i(2); -- Commuta el senyal cada segon
            else
                counter1   <= counter1 + 1;
            end if;
--          end if;
        end if;
    end process;


    ---FIM_FPGA_RDY
    process(clk25Mz)
    begin
      if rising_edge(clk25Mz) then
         if FIM_FPGA_RDY = '0' and LED1_reg = '1' then
            FIM_FPGA_RDY <= '0';
         else
            FIM_FPGA_RDY <= '1';
         end if;
      end if;
    end process;
    FPGA_RDY <= '1';

    --PMOD_o_i(3) <= PMOD_o_i(8);
    PMOD_o_i(4) <= reset;
    PMOD_o_i(5) <= LED1_reg;


    process(clk25Mz)
    begin
      if rising_edge(clk25Mz) then

         if FIM_RST_ALRM_reg2 = '1' then
            input_LEDS <= (others => '0');
         else
            --input_LEDS(17 downto 0) <= input_LEDS(17 downto 0) or FIM_i_reg2;
            input_LEDS(17 downto 0) <= FIM_i_reg2;
            input_LEDS(18) <= '1'; --remote ALARM
         end if;
      end if;
    end process;


   SHR_data_out(15 downto 0) <= (others => '0');
   SHR_data_out(16 downto 34) <= input_LEDS; -- input Front Panel LEDs
   SHR_data_out(35 downto 40) <= FIM_o_i;     -- output Front Panel LEDs
   SHR_data_out(41) <= FIM_RST_ALRM_reg2;     -- RESET
   SHR_data_out(42) <= FIM_FPGA_RDY;     --  FPGA STATUS
   SHR_data_out(43) <= LED1_reg;     -- FPGA STATUS

   SHR_inst: shift_reg_ctrl
   generic map (
        CLK_counter=> 25,  -- Contador per generar el CLK
        G_TX_WIDTH => cSHR_data_out, -- Nou tamany per a TX
        G_RX_WIDTH => cSHR_data_in  -- Nou tamany per a RX
    )
    Port map(
         clk => clk25Mz,
           rst => reset,
           error => PMOD_o_i(3),
           TX => SHR_data_out,
           RX => SHR_data_in,
           SRCLK => SHR_SRCLK,
           RCLK => SHR_RCLK,
           DATA_M2S => DATA_M2S,
           nOE => SHR_nOE,
           nSRCLR => SHR_nSRCLR,
           SH_nLD => SH_nLD,
           DATA_S2M => DATA_S2M
     );
   FIM_SW <= SHR_data_in(19 downto 0);


   PMOD_o_i(1) <= FIM_RST_ALRM_reg2;
   PMOD_o_i(6) <= FIM_i_reg2(14);
   FIM_o_i <= FIM_i_reg2(FIM_o_i'high + 11 downto FIM_o_i'low + 11);




   process(clk25Mz)  --To avoid meta-stabilities
    begin
        if rising_edge(clk25Mz) then

            FIM_i_reg1 <= FIM_i_reg;
            FIM_i_reg2 <= FIM_i_reg1;
            FIM_RST_ALRM_reg1 <= FIM_RST_ALRM_reg;
            FIM_RST_ALRM_reg2 <= FIM_RST_ALRM_reg1;
        end if;
    end process;


   SP4_OBUF : OBUF   -- SPARE 4
   port map (
      O => LPB(7), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => LPB7  -- 1-bit input: Buffer input
   );


   LPB8 <= '1';
   SP5_OBUF : OBUF   -- SPARE 5
   port map (
      O => LPB(8), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => LPB8  -- 1-bit input: Buffer input
   );


   IBUFDS_inst1 : IBUFDS  -- ArcDet1
    port map (
       O => FIM_i_reg(0),   -- 1-bit output: Buffer output
       I => HPB_p(1),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPB_n(1)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    IBUFDS_inst2 : IBUFDS  -- ArcDet2
    port map (
       O => FIM_i_reg(1),   -- 1-bit output: Buffer output
       I =>  HPB_p(2),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPB_n(2)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    IBUFDS_inst3 : IBUFDS  -- ArcDet3
    port map (
       O => FIM_i_reg(2),   -- 1-bit output: Buffer output
       I =>  HPA_p(10),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(10)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    IBUFDS_inst4 : IBUFDS  -- ArcDet4
    port map (
       O => FIM_i_reg(3),   -- 1-bit output: Buffer output
       I =>  HPB_p(0),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPB_n(0)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    IBUFDS_inst5 : IBUFDS  -- ArcDet5
    port map (
       O => FIM_i_reg(4),   -- 1-bit output: Buffer output
       I =>  HPA_p(7),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(7)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    IBUFDS_inst6 : IBUFDS  -- ArcDet6
    port map (
       O => FIM_i_reg(5),   -- 1-bit output: Buffer output
       I =>  HPA_p(8),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(8)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    RFDet1_IBUFDS_inst : IBUFDS  -- RFDet1
    port map (
       O => FIM_i_reg(6),   -- 1-bit output: Buffer output
       I =>  HPA_p(6),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(6)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    RFDet2_IBUFDS_inst : IBUFDS  -- RFDet2
    port map (
       O => FIM_i_reg(7),   -- 1-bit output: Buffer output
       I =>  HPA_p(5),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(5)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    RFDet3_IBUFDS_inst : IBUFDS  -- RFDet3
    port map (
       O => FIM_i_reg(8),   -- 1-bit output: Buffer output
       I =>  HPA_p(4),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(4)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    RFDet4_IBUFDS_inst : IBUFDS  -- RFDet4
    port map (
       O => FIM_i_reg(9),   -- 1-bit output: Buffer output
       I =>  HPA_p(3),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(3)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    SSPA_IN1_IBUFDS_inst : IBUFDS  -- SSPA_IN1
    port map (
       O => FIM_i_reg(10),   -- 1-bit output: Buffer output
       I =>  HPA_p(9),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(9)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    SSPA_IN2_IBUFDS_inst : IBUFDS  -- SSPA_IN2
    port map (
       O => FIM_i_reg(11),   -- 1-bit output: Buffer output
       I =>  HPA_p(2),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(2)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    Timming_IN1_IBUFDS_inst : IBUFDS  -- Timming
    port map (
       O => FIM_i_reg(13),   -- 1-bit output: Buffer output
       I =>  HPA_p(4),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(4)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    SPARE_IN1_IBUFDS_inst : IBUFDS  -- SPARE_IN1
    port map (
       O => FIM_i_reg(15),   -- 1-bit output: Buffer output
       I =>  HPA_p(1),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(1)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    SPARE_IN2_IBUFDS_inst : IBUFDS  -- SPARE_IN2
    port map (
       O => FIM_i_reg(16),   -- 1-bit output: Buffer output
       I =>  HPA_p(0),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       IB => HPA_n(0)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

     VAC_IBUF_inst0 : IBUF  --VACUUM_IN
       port map (
          O => FIM_i_reg(12), -- 1-bit output: Buffer output
          I => LPB(0)  -- 1-bit input: Buffer input  VACCUM IN
       );

    EPS_IBUF_inst0 : IBUF  --EPS_IN
       port map (
          O => FIM_i_reg(14), -- 1-bit output: Buffer output
          I => LPB(3)  -- 1-bit input: Buffer input  EPS IN
       );

      MALARM_IBUF_inst0 : IBUF  -- Manual ALarm
       port map (
          O => FIM_i_reg(17), -- 1-bit output: Buffer output
          I => LPB(4)  -- 1-bit input: Buffer input
       );

      RST_IBUF_inst0 : IBUF  -- ManualReset
       port map (
          O => FIM_RST_ALRM_reg, -- 1-bit output: Buffer output
          I => LPB(5)  -- 1-bit input: Buffer input
       );


    PIND1_OBUFDS_inst : OBUFDS  -- PinDiode 1
    port map (
       I => FIM_o_i(0),   -- 1-bit output: Buffer output
       O =>  HPB_p(6),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       OB => HPB_n(6)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    PIND2_OBUFDS_inst : OBUFDS  -- PinDiode 2
    port map (
       I => FIM_o_i(1),   -- 1-bit output: Buffer output
       O =>  HPB_p(7),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       OB => HPB_n(7)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    TIM1_OBUFDS_inst : OBUFDS  -- Timing 1
    port map (
       I => FIM_o_i(2),   -- 1-bit output: Buffer output
       O =>  HPB_p(4),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       OB => HPB_n(4)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    TIM2_OBUFDS_inst : OBUFDS  -- Timing 2
    port map (
       I => FIM_o_i(3),   -- 1-bit output: Buffer output
       O =>  HPB_p(5),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       OB => HPB_n(5)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    EPS_OBUFDS_inst : OBUFDS  -- EPS
    port map (
       I => FIM_o_i(4),   -- 1-bit output: Buffer output
       O =>  HPB_p(9),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       OB => HPB_n(9)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

    SPARE_OBUFDS_inst : OBUFDS  -- SPARE
    port map (
       I => FIM_o_i(5),   -- 1-bit output: Buffer output
       O =>  HPB_p(8),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
       OB => HPB_n(8)  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );

   FRdy_OBUF : OBUF   -- FPGA Ready
   port map (
      O => LPB(6), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => FPGA_RDY  -- 1-bit input: Buffer input
   );

   SHR_nOE_OBUF : OBUF   -- SHIFT REGISTER
   port map (
      O => LPA(0), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => SHR_nOE  -- 1-bit input: Buffer input
   );

   SHR_nSRCLR_OBUF : OBUF   -- SHIFT REGISTER SHR_nSRCLR
   port map (
      O => LPA(3), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => SHR_nSRCLR  -- 1-bit input: Buffer input
   );

   SHR_RCLK_OBUF : OBUF   -- SHIFT REGISTER SHR_RCLK
   port map (
      O => LPA(1), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => SHR_RCLK  -- 1-bit input: Buffer input
   );

   SHR_SRCLK_OBUF : OBUF   -- SHIFT REGISTER SHR_SRCLK
   port map (
      O => LPA(2), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => SHR_SRCLK  -- 1-bit input: Buffer input
   );

   SHR_SER_OBUF : OBUF   -- SHIFT REGISTER DATA_M2S
   port map (
      O => LPA(6), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => DATA_M2S  -- 1-bit input: Buffer input
   );

   SH_nLD_OBUF : OBUF   -- SHIFT REGISTER SH_nLD
   port map (
      O => LPA(5), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => SH_nLD  -- 1-bit input: Buffer input
   );

   D_F2M_IBUF_inst0 : IBUF  -- SHR_DATA_F2R DATA_S2M
       port map (
          O => DATA_S2M, -- 1-bit output: Buffer output
          I => LPA(4)  -- 1-bit input: Buffer input
       );

--    LPA(0) <= SHR_nOE; -- SHIFT REGISTER
--    LPA(3) <= SHR_nSRCLR;
--    LPA(1) <= SHR_RCLK;
--    LPA(2) <= SHR_SRCLK;
--    LPA(6) <= SHR_SER;
--    LPA(5) <= SH_nLD;


--    MMCM1:clk_generator
--    port map (
--        clk_in1 => hw_clk_25MH,
--        clk_out1 => clk_150MHz,
--        reset => reset,  --reset
--        locked => rst150
--    );

   BUFG_inst : BUFG
   port map (
      O => clk25Mz, -- 1-bit output: Clock output.
      I => hw_clk_25MH  -- 1-bit input: Clock input.
   );

   OBUF_inst1 : OBUF   --
   port map (
      O => PMOD(1), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => PMOD_o_i(1)  -- 1-bit input: Buffer input
   );

   OBUF_inst2 : OBUF   --
   port map (
      O => PMOD(2), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => PMOD_o_i(2)  -- 1-bit input: Buffer input
   );

   OBUF_inst3 : OBUF   --
   port map (
      O => PMOD(3), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => PMOD_o_i(3)  -- 1-bit input: Buffer input
   );

   OBUF_inst4 : OBUF   --
   port map (
      O => PMOD(4), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => PMOD_o_i(4)  -- 1-bit input: Buffer input
   );
   OBUF_inst5 : OBUF   --
   port map (
      O => PMOD(5), -- 1-bit output: Buffer output (connect directly to top-level port)
      I => PMOD_o_i(5)  -- 1-bit input: Buffer input
   );

      PMOD_IBUF_inst0 : IBUF  -- PMOD8
       port map (
          O => PMOD_o_i(8), -- 1-bit output: Buffer output
          I => PMOD(8)  -- 1-bit input: Buffer input
       );


--     IBUF_inst0 : IBUF  --VACUUM_IN
--   port map (
--      O => PMOD_0(8), -- 1-bit output: Buffer output
--      I => som240_1_c22  -- 1-bit input: Buffer input  VACCUM IN
--   );



   OBUF_inst0 : OBUF   -- LED1
   port map (
      O => LED1, -- 1-bit output: Buffer output (connect directly to top-level port)
      I => LED1_reg  -- 1-bit input: Buffer input
   );





end Behavioral;
