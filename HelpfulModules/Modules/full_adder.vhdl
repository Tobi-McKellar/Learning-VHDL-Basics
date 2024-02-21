library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder is
    port(
        a, b, cin : in std_logic; -- SW : in std_logic_vector(2 downto 0);
        sum, cout : out std_logic -- LED: out std_logic_vector(1 downto 0);
    );
end entity full_adder;

architecture structural of full_adder is
    -- I prefer component instantiation over entity instantiation.
    -- It's mostly personal preference, but I find it easier to read.

    component half_adder is
        port(
            a, b: in std_logic; -- SW in std_logic_vector(1 downto 0);
            sum, carry: out std_logic -- LED out std_logic_vector(1 downto 0)
        );
    end component half_adder;

    signal s1, c1, c2 : std_logic; -- a, b, c

begin

    -- I also prefer to break the port mapping into different lines.
    -- It helps readability for long signal names and long port lists.
    half_adder_1 : half_adder
    port map(
        a => a,
        b => b,
        sum => s1,
        carry => c1
    );
    half_adder_2 : half_adder 
    port map(
        a => s1,
        b => cin,
        sum => sum,
        carry => c2
    );

    cout <= c1 or c2; -- LED(1) <= c1 or c2;

end architecture structural;
