library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity half_adder is
    port(
        a, b: in std_logic; -- SW in std_logic_vector(1 downto 0);
        sum, carry: out std_logic -- LED out std_logic_vector(1 downto 0)
    );
end entity half_adder;

architecture rtl of half_adder is
begin
    sum <= a xor b; -- LED(0) <= SW(0) xor SW(1);
    carry <= a and b; -- LED(1) <= SW(0) and SW(1);
end architecture rtl;