package matrix_pkg is
    -- type vector is array(0 to 3) of integer;
    constant n : integer := 1; -- row
    constant m : integer := 1; -- col
    type matrix is array(0 to n, 0 to m) of integer range -2**3 to 2**3-1;
end package matrix_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.matrix_pkg.all;

entity matmul is
    port (
        clk : in  std_logic;
        reset : in  std_logic;
        a : in  matrix;
        b : in  matrix;
        c : out matrix
    );
end entity matmul;

architecture rtl of matmul is
begin

    mul: process(clk)
    variable s_c : matrix := (others => (others => 0));
    begin
        if rising_edge(clk) then
            if reset = '1' then
                s_c := (others => (others => 0));
            else
                for i in 0 to n loop
                    for j in 0 to m loop
                        s_c(i, j) := 0;
                        for k in 0 to n loop
                            s_c(i, j) := s_c(i, j) + a(i, k) * b(k, j);
                        end loop;
                    end loop;
                end loop;
            end if;
        end if;
        c <= s_c;
    end process;

end architecture rtl;