library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_capacitive_button is
end tb_capacitive_button;

architecture Behavioral of tb_capacitive_button is
    -- Component declaration
    component capacitivetouch
        generic (
            CLK_FREQ  : real := 33.3e6;   -- Clock frequency in Hz
            R_VAL     : real := 100.0e3;  -- Resistance in ohms
            C_VAL     : real := 100.0e-12; -- Capacitance in farads
            C_VAL_PRESSED : real := 105.0e-12
        );
        port (
            clk       : in  std_logic;  -- System clock
            reset     : in  std_logic;  -- Asynchronous reset
            cap_inout : inout std_logic; -- Capacitive button pin
            led       : out std_logic   -- LED output
        );
    end component;

    -- Signals
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal cap_inout_tb : std_logic := 'Z';
    signal cap_inout_tb_delayed : std_logic := '0';
    signal led       : std_logic;

    -- Constants
    constant CLK_PERIOD : time := 30 ns; -- Clock period for 33.3 MHz
    constant UNPRESSED_RISE_TIME : integer := integer(0.35*100.0e3*100.0e-12/30.0e-9); -- Approx cycles for unpressed
    constant PRESSED_RISE_TIME : integer := integer(0.35*100.0e3*115.0e-12/30.0e-9); -- Approx cycles for pressed

    signal uprt : integer := UNPRESSED_RISE_TIME;
    signal prt : integer := PRESSED_RISE_TIME;

    signal test : std_logic := '0';

    -- Test signals for button simulation
    signal button_state : std_logic := '0'; -- Represents the physical button state
    signal rise_counter : integer := 0;    -- Counter to simulate rise time

    signal simdone : boolean := false;
begin

    -- DUT instantiation
    uut: capacitivetouch
        generic map (
            CLK_FREQ  => 33.3e6,
            R_VAL     => 100.0e3,
            C_VAL     => 100.0e-12
        )
        port map (
            clk       => clk,
            reset     => reset,
            cap_inout => cap_inout_tb,
            led       => led
        );

    -- Clock generation
    clk_process: process
    begin
        if simdone = false then
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end if;
    end process;

    -- Button simulation
    button_simulation: process
    begin
        -- Reset the system
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;

        -- Simulate an unpressed button
        button_state <= '0';
        wait for 2 ms; -- Let the system measure unpressed state

        -- Simulate a button press
        button_state <= '1';
        wait for 2 ms; -- Let the system detect the press

        -- Simulate another unpressed state
        button_state <= '0';
        wait for 2 ms;

        -- Simulate another button press
        button_state <= '1';
        wait for 2 ms;

        -- End simulation
        simdone <= true;
        wait;
    end process;

    -- Cap input rise time simulation
    cap_input_simulation: process
    begin
        if simdone = false then
            wait until rising_edge(clk);
            cap_inout_tb_delayed <= cap_inout_tb;
                if (cap_inout_tb_delayed = '0' and cap_inout_tb = 'Z' and button_state = '0') then
                    wait for UNPRESSED_RISE_TIME * CLK_PERIOD;
                    cap_inout_tb <= '1';
                    wait until falling_edge(clk);
                    cap_inout_tb <= 'Z';
                    -- test <= '1';
                else if (cap_inout_tb_delayed = '0' and cap_inout_tb = 'Z' and button_state = '1') then
                    wait for PRESSED_RISE_TIME * CLK_PERIOD;
                    cap_inout_tb <= '1';
                    wait until falling_edge(clk);
                    cap_inout_tb <= 'Z';
                    -- test <= '1';
                end if;
            end if;
        else
            wait;
        end if;
    end process;
end Behavioral;
