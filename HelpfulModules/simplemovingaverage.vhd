library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simplemovingaverage is
    generic (
        num_bits : integer := 32;
        num_samples : integer := 16 -- must be power of 2
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        din : in std_logic_vector(num_bits-1 downto 0);
        dout : out std_logic_vector(num_bits-1 downto 0)
        average_valid : out std_logic; -- high when output is composed of 16 samples
        samples_used : out integer range 0 to num_samples-1
    );
end entity simplemovingaverage;

architecture rtl of simplemovingaverage is

    signal s_sum : integer range 0 to 2**num_bits-1 := 0;
    signal s_samples_used : integer range 0 to num_samples-1;
    signal s_sample_valid : std_logic;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_sum <= (others => '0');
                s_samples_used <= 0;
                s_sample <= (others => '0');
                average_valid <= '0';
            else
                    s_sum <= s_sum + din;
                    if s_samples_used = num_samples-1 then
                        s_samples_used <= s_samples_used
                        average_valid <= '1';
                    else
                        s_samples_used <= s_samples_used + 1;
                    end if;
                    average_valid <= '0';
                end if;
                if s_samples_used = num_samples-1 then
                    dout <= std_logic_vector(s_sum / to_unsigned(num_samples, num_bits));
                    sample_valid <= '1';
                    s_sum <= (others => '0');
                    s_samples_used <= 0;
                else
                    dout <= (others => '0');
                    sample_valid <= '0';
                end if;
            end if;
        end if;
    end process;