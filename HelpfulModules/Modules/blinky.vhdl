-- FILEPATH: /Users/tobimckellar/Desktop/FPGA/Learning VHDL Basics/HelpfulModules/Modules/blinky.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blinky is
    port (
        clk : in std_logic;
        led0 : out std_logic;
        led1 : out std_logic;
        led2 : out std_logic;
        led3 : out std_logic
    );
end entity blinky;

architecture rtl of blinky is
    signal counter : unsigned(27 downto 0) := (others => '0');
    signal blink : unsigned(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
            blink <= counter(27 downto 24);
        end if;
    end process;

    led0 <= std_logic(blink(0));
    led1 <= std_logic(blink(1));
    led2 <= std_logic(blink(2));
    led3 <= std_logic(blink(3));
end architecture rtl;
