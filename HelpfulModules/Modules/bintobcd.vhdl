library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bintobcd is
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
end entity bintobcd;

architecture rtl of bintobcd is

    

begin
    process (clk)
    variable BCD : unsigned ((num_output_digits*4)-1 downto 0) := (others => '0');
    begin
    
    if rising_edge(clk) then
        if reset = '1' then
            BCD := (others => '0');
        elsif binary_in'event then
            BCD := (others => '0');
            -- BCD(num_input_bits-1 downto 0) := binary_in;
            for i in num_input_bits-1  downto 0 loop
                
                for j in num_output_digits - 1 downto 0 loop
                    if BCD((j*4)+3 downto (j*4)) >= 5 then
                        BCD((j*4)+3 downto (j*4)) := BCD((j*4)+3 downto (j*4)) +3;
                    end if;
                end loop; 
                BCD := BCD(BCD'length-2 downto 0) & binary_in(i);
            end loop;
        end if;
    end if;
    bcd_out <= std_logic_vector(BCD);
    end process;
   

end architecture rtl;
