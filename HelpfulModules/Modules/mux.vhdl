library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Author : Tobias McKellar
-- A simple MUX with a generic select and bus width. Can be configured as either synchronous or asynchronous.
-- Due to VHDL lacking the ability to declare a port as an array,
-- the inputs are intended to be hooked up as (0) -> 31 downto 0, (1) -> 63 downto 32, etc.


entity mux is
    generic (
        select_width : integer := 2;
        bus_width : integer := 32
    );
    port (
        clk     : in std_logic;
        selects : in std_logic_vector(select_width-1 downto 0);
        inputs  : in std_logic_vector(bus_width*2**select_width-1 downto 0);
        output  : out std_logic_vector(bus_width-1 downto 0)
    );
end entity mux;
architecture rtl of mux is
begin

    -- Synchronous mux logic. Comment out to use Asynchronous logic.
    process (clk)
    begin
        if rising_edge(clk) then
            -- eg for bus width of 32 and select width of 2
            -- output <= (3+1)*32 - 1 downto 3*32 = 127 downto 96
            output <= inputs((to_integer(unsigned(selects))+ 1)*bus_width - 1 downto to_integer(unsigned(selects))*bus_width);
        end if;
    end process;

    -- Asynchronous mux logic. Uncomment to use.
    -- output <= inputs((to_integer(unsigned(selects))+ 1)*bus_width - 1 downto to_integer(unsigned(selects))*bus_width);
end architecture;

