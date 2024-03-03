
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.matrix_pkg.all;

entity matmul_tb is
end entity matmul_tb;

architecture tb_arch of matmul_tb is

    component matmul is
        port (
            clk : in  std_logic;
            reset : in  std_logic;
            a : in  matrix;
            b : in  matrix;
            c : out matrix
        );
    end component;

    constant CLK_PERIOD : time := 30.303 ns;

    signal clk   : std_logic := '0';
    signal simDone : boolean := false;


    signal reset : std_logic := '1';
    signal a : matrix := (others => (others => 0));
    signal b : matrix := (others => (others => 0));
    signal c : matrix;
    
begin

    matmul_inst : matmul
        port map (
            clk => clk,
            reset => reset,
            a => a,
            b => b,
            c => c
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

    
    stimulus_process : process
    begin
        reset <= '1';
        wait for 10*CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD * 1;
        a <= (others => (others => 1));
        b <= (others => (others => 1));
        wait for CLK_PERIOD * 1;
        a <= ((1, 0), (0, 1));
        b <= b;
        wait for CLK_PERIOD * 1;
        a <= ((1, 2), (3, 4));
        b <= ((1, 2), (3, 4));
        wait for CLK_PERIOD * 1;
        simDone <= true;
        wait;
    end process stimulus_process;

end architecture tb_arch;
