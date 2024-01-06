library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
    generic (
        clk_freq : integer := 50_000_000;
        debounce_time_ms : integer := 100_000;
        num_buttons : integer := 4
    ); 
    port (
        clk : in std_logic;
        rst : in std_logic;
        buttons : in std_logic_vector(num_buttons-1 downto 0);
        button_debounced : out std_logic_vector(num_buttons-1 downto 0)
    );
end debouncer;

architecture behavioural of debouncer is

    constant debounce_count_max : natural := clk_freq * debounce_time_ms / 1000;

    type counter_array is array (num_buttons-1 downto 0) of natural range 0 to debounce_count_max;
    signal s_counter : counter_array;

    signal s_state : std_logic_vector(num_buttons-1 downto 0);

begin

    process(clk, rst)
    begin

        -- Asynchronous reset can be exposed to the user via buttons or left internal
        if rst = '1' then
            s_state <= (others => '0');
            s_counter <= (others => 0);
        elsif rising_edge(clk) then
            for i in 0 to num_buttons-1 loop
                if buttons(i) /= s_state(i) then
                    if s_counter(i) = debounce_count_max then
                        s_state(i) <= buttons(i);
                    else
                        s_counter(i) <= s_counter(i) + 1;
                    end if;
                else
                    s_counter(i) <= 0;
                end if;
            end loop;
        end if;
    end process;

    button_debounced <= s_state;

end behavioural;
