library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity blinker_tb is
end entity;

architecture sim of blinker_tb is

component blinker is
    generic(
        max_count : natural := 1_000_000
    );
    port(
        clk : in std_logic;
        led : out std_logic
    );
end component;


    signal clk : std_logic := '0';
    signal led : std_logic;

    signal simDone : std_logic := '0';
    
    constant clk_period : time := 10 ns;

begin

    blinker_inst : blinker
    generic map(
        max_count => 100
    )
    port map(
        clk => clk,
        led => led
    );

    clk_gen : process is
    begin
        if simDone = '1' then
            wait;
        else
            wait for clk_period / 2;
            clk <= not clk;
        end if;
    end process;
       
    sim : process is
    begin
        wait for 100*10*5 ns;
        simDone <= '1';
        wait;
    end process;
    


end architecture;
