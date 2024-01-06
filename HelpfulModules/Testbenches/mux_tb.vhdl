library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_tb is
end entity mux_tb;

architecture test of mux_tb is

    component mux
        generic (
            select_width : integer;
            bus_width : integer
        );
        port (
            clk     : in std_logic;
            selects : in std_logic_vector(select_width-1 downto 0);
            inputs  : in std_logic_vector(bus_width*2**select_width-1 downto 0);
            output  : out std_logic_vector(bus_width-1 downto 0)
        );
    end component mux;

    constant CLK_PERIOD : time := 30.303 ns;

    signal clk   : std_logic := '0';
    signal simDone : boolean := false;

    constant select_width : integer := 2;
    constant bus_width : integer := 32;
    signal selects : std_logic_vector(select_width-1 downto 0) := "00";
    signal inputs  : std_logic_vector(bus_width*2**select_width-1 downto 0);
    signal output  : std_logic_vector(bus_width-1 downto 0);
begin
    -- Instantiate the mux
    mux_inst : mux
        generic map (
            select_width => select_width,
            bus_width => bus_width
        )
        port map (
            clk => clk,
            selects => selects,
            inputs => inputs,
            output => output
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

    -- Testbench process
    tb: process
    begin
        inputs(31 downto 0) <=  X"FFFFFFFF";
        inputs(63 downto 32) <= X"EEEEEEEE";
        inputs(95 downto 64) <= X"DDDDDDDD";
        inputs(127 downto 96) <= X"CCCCCCCC";
        wait for CLK_PERIOD;
        -- Test 1: 
        selects <= "00";
        wait for CLK_PERIOD;
        assert output = inputs(31 downto 0) report "Output mismatch for Test 1" severity error;

        -- Test 2: 
        selects <= "01";
        wait for CLK_PERIOD;
        assert output = inputs(63 downto 32) report "Output mismatch for Test 2" severity error;

        -- Test 3: 
        selects <= "10";
        wait for CLK_PERIOD;
        assert output = inputs(95 downto 64) report "Output mismatch for Test 3" severity error;

        -- Test 4: 
        selects <= "11";
        wait for CLK_PERIOD;
        assert output = inputs(127 downto 96) report "Output mismatch for Test 4" severity error;

        simDone <= true;

        wait;
    end process tb;
end architecture test;