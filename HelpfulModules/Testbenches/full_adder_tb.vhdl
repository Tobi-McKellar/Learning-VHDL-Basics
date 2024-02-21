library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder_tb is
end entity full_adder_tb;

architecture behavioural of full_adder_tb is

    component full_adder
        port(
            a, b, cin : in std_logic;
            sum, cout : out std_logic
        );
    end component full_adder;

    signal a, b, cin, sum, cout : std_logic;
    
    begin
        full_adder_inst : full_adder
            port map(
                a => a,
                b => b,
                cin => cin,
                sum => sum,
                cout => cout
            );

    simulation : process
    begin
        a <= '0';
        b <= '0';
        cin <= '0';
        wait for 10 ns;
        
        a <= '0';
        b <= '1';
        cin <= '0';
        wait for 10 ns;
        
        a <= '1';
        b <= '0';
        cin <= '0';
        wait for 10 ns;
        
        a <= '1';
        b <= '1';
        cin <= '0';
        wait for 10 ns;
        
        a <= '0';
        b <= '0';
        cin <= '1';
        wait for 10 ns;
        
        a <= '0';
        b <= '1';
        cin <= '1';
        wait for 10 ns;
        
        a <= '1';
        b <= '0';
        cin <= '1';
        wait for 10 ns;
        
        a <= '1';
        b <= '1';
        cin <= '1';
        wait for 10 ns;
        
        wait;
    end process simulation;

end behavioural;