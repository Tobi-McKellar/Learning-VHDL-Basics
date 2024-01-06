library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity seg7_tb is
end entity seg7_tb;

architecture sim of seg7_tb is

    component seg7 is
        generic(
            segment_active_state : std_logic := '1'
            display_active_state : std_logic := '0'
        );
        port(
            clk  : in std_logic;
            rst  : in std_logic;
            data : in std_logic_vector(3 downto 0);
            dp   : in std_logic;
            en   : in std_logic;
            seg  : out std_logic_vector(7 downto 0)
            an   : out std_logic;
        );
    end component;


    signal CLK_PERIOD : time := 30 ns;
    signal clk : std_logic := '0';
    signal simDone : boolean := false;

    signal rst : std_logic := '0';
    signal data : std_logic_vector(3 downto 0) := "0000";
    signal dp : std_logic := '0';
    signal en : std_logic := '0';
    signal seg : std_logic_vector(7 downto 0);
    signal an : std_logic := '0';

begin

    seg7_inst : seg7
    generic map(
        active_state => '1'
    )
    port map(
        clk  => clk,
        rst  => rst,
        data => data,
        dp   => dp,
        en  => en,
        seg  => seg,
        an   => an
    );


    clk_process : process
    begin 
        if simDone then
            wait;
        else
            clk <= '1';
            wait for CLK_PERIOD/2;
            clk <= '0';
            wait for CLK_PERIOD/2;
        end if;
    end process;

    test_process : process
    begin
        en <= '1';
        dp <= '1';
        data <= "0000";
        wait for CLK_PERIOD;
        dp <= '0';
        data <= "0001";
        wait for CLK_PERIOD;
        data <= "0010";
        wait for CLK_PERIOD;
        data <= "0011";
        wait for CLK_PERIOD;
        data <= "0100";
        wait for CLK_PERIOD;
        data <= "0101";
        wait for CLK_PERIOD;
        data <= "0110";
        wait for CLK_PERIOD;
        data <= "0111";
        wait for CLK_PERIOD;
        data <= "1000";
        wait for CLK_PERIOD;
        data <= "1001";
        wait for CLK_PERIOD;
        dp <= '1';

