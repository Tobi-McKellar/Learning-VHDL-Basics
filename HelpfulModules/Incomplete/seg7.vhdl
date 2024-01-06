-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;

-- -- Author : Tobias McKellar

-- -- A 7 segment display driver, with a 4 bit input and a decimal place.
-- -- There are special codes given to display a blank digit, all segments, and a dash (-).

-- -- The segment layout used is as shown below.
        

     
-- --   1111
-- -- 6      2
-- -- 6      2
-- --   7777
-- -- 5      3
-- -- 5      3
-- -- 8 4444

-- entity seg7 is
--     generic(
--         active_state : std_logic := '0'
--     );
--     port(
--         clk : in std_logic;
--         rst : in std_logic;
--         data : in std_logic_vector(3 downto 0);
--         dp   : in std_logic;
--         seg  : out std_logic_vector(7 downto 0);

--     );
-- end entity seg7;

-- architecture rtl of seg7 is

        
--     with data select
--         seg <= "00000001" when "0000",  -- if BCD is "0000" write a zero to display
--                "01001111" when "0001",	-- etc...
--                "00010010" when "0010",
--                "00000110" when "0011",
--                "01001100" when "0100",
--                "00100100" when "0101",
--                "01100000" when "0110",
--                "00001111" when "0111",
--                "00000000" when "1000",
--                "00001100" when "1001",
--                "01100000" when "1011",  -- dash
--                "11111111" when others;

--     if dp = '1' seg(7) <= active_state else seg(7) <= not active_state;
    