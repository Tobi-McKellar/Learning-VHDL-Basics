library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Author : Tobias McKellar

-- A 7 segment display driver, with a 4 bit input and a decimal place.
-- There are special codes given to display a blank digit, all segments, and a dash (-).
-- This is modular and allows the user to change the active state of the segments and the overall display.

-- The segment layout used is as shown below.
        

     
--   1111
-- 6      2
-- 6      2
--   7777
-- 5      3
-- 5      3
-- 8 4444

entity seg7 is
    generic(
        segment_active_state : std_logic := '1';
        display_active_state : std_logic := '0'
    );
    port(
        clk  : in std_logic;
        rst  : in std_logic;
        data : in std_logic_vector(3 downto 0);
        dp   : in std_logic;
        en   : in std_logic;
        seg  : out std_logic_vector(7 downto 0);
        an   : out std_logic
    );
end entity seg7;

architecture rtl of seg7 is

    signal s_seg : std_logic_vector(7 downto 0);

begin
        
    with data select
        s_seg <= "00000001" when "0000",  -- if BCD is "0000" write a zero to display
                 "01001111" when "0001",	-- etc...
                 "00010010" when "0010",
                 "00000110" when "0011",
                 "01001100" when "0100",
                 "00100100" when "0101",
                 "01100000" when "0110",
                 "00001111" when "0111",
                 "00000000" when "1000",
                 "00001100" when "1001",
                 "01100000" when "1011",  -- dash
                 "11111111" when others;
    seg(6 downto 0) <= s_seg(6 downto 0) when (en = '1') else (others => not segment_active_state);
    seg(7) <= segment_active_state when (dp = '1' and en = '1') else not segment_active_state;
    an <= display_active_state when (en = '1') else not display_active_state;
end architecture rtl;