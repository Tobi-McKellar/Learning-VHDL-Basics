library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity blinker is
    generic(
        max_count : natural := 1_000_000
    );
    port(
        clk : in std_logic;
        led : out std_logic
    );
end blinker;

architecture Behavioural of blinker is
    signal counter : natural range 0 to max_count;
    signal s_led : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = max_count then
                counter <= 0;
                s_led <= not s_led;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    led <= s_led;
end architecture;
