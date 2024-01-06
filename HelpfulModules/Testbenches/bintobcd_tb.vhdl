library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bintobcd_tb is
end entity bintobcd_tb;

architecture test of bintobcd_tb is

    constant OUTPUT_DIGITS : integer := 5;
    constant INPUT_BITS : integer := 32;

    signal CLK_PERIOD : time := 30 ns;
    signal clk : std_logic := '0';
    signal simDone : boolean := false;


    signal binary:     std_logic_vector(15 downto 0);
    signal bcd:   std_logic_vector(4*5 - 1 downto 0);

    component bintobcd is
        generic (
            num_output_digits : integer := 1;
            num_input_bits : integer := 32
        );
        port (
            clk       : in std_logic;
            reset     : in std_logic;
            binary_in : in std_logic_vector(num_input_bits - 1 downto 0);
            bcd_out   : out std_logic_vector(num_output_digits*4 - 1 downto 0)
        );
    end component;

begin

    bintobcd_inst : bintobcd
        generic map (
            num_output_digits => 5,
            num_input_bits => 16
        )
        port map (
            clk       => clk,
            reset     => '0',
            binary_in => binary,
            bcd_out   => bcd
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
        binary <= std_logic_vector(to_unsigned(0, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(243, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(999, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(132, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(54, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(187, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(65535, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(0, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(1, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(32000, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(111, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(222, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(333, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(444, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(555, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(666, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(777, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(888, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(999, 16));
        wait for CLK_PERIOD*10;
        binary <= std_logic_vector(to_unsigned(1000, 16));
        wait for CLK_PERIOD*10;
        simDone <= true;
        wait;
    end process;

end architecture test;
