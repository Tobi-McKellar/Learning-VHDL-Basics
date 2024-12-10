library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity capacitivetouch is
    generic (
        CLK_FREQ  : real := 33.3e6;   -- Clock frequency in Hz
        R_VAL     : real := 100.0e3;  -- Resistance in ohms
        C_VAL     : real := 100.0e-12; -- Capacitance in farads
        C_VAL_PRESSED : real := 105.0e-12
    );
    port (
        clk       : in  std_logic;  -- System clock
        reset     : in  std_logic;  -- Asynchronous reset
        cap_input : in  std_logic; -- Capacitive button pin
        cap_output: out std_logic;
        led       : out std_logic   -- LED output
    );
end capacitivetouch;

architecture Behavioral of capacitivetouch is
    -- Calculate RC time constant and thresholds
    constant RC_TIME      : real := R_VAL * C_VAL;         -- RC time constant in seconds
    constant UNPRESSED_RISE_CYCLES : integer := integer(0.35*R_VAL*C_VAL*CLK_FREQ); -- Approx cycles for unpressed
    constant PRESSED_RISE_CYCLES : integer := integer(0.35*R_VAL*C_VAL_PRESSED*CLK_FREQ); -- Approx cycles for pressed

    -- Convert thresholds to clock cycles
    constant DETECTION_MARGIN : integer := PRESSED_RISE_CYCLES - UNPRESSED_RISE_CYCLES; -- Expected cycle difference

    -- Signals
    signal counter        : integer := 0; -- Counts clock cycles for rise time measurement
    signal sampling       : std_logic := '0'; -- Sampling state
    signal rise_time      : integer := 0; -- Recorded rise time in clock cycles
    signal discharge_done : std_logic := '0'; -- Indicates discharge phase completion
    signal led_state      : std_logic := '1'; -- LED default state
    signal led_state_prev : std_logic := '1';
    -- signal cap_input_s    : std_logic := '0';
begin


    -- Main process
    process(clk, reset)
    begin
        if reset = '0' then
            counter        <= 0;
            rise_time      <= 0;
            discharge_done <= '0';
            sampling       <= '0';
            -- cap_input      <= '0'; -- Discharge button
            cap_output <= '0';
            led_state      <= '1'; -- Default LED to on
        elsif rising_edge(clk) then
            if discharge_done = '0' then
                -- Discharge phase
                cap_output <= '0'; -- Drive button to logic '0'
                counter <= counter + 1;

                if counter = 10 * PRESSED_RISE_CYCLES then
                    discharge_done <= '1'; -- Move to sampling phase
                    counter <= 0;
                    cap_output <= 'Z'; -- Release the button
                    sampling <= '1';
                end if;

            elsif sampling = '1' then
                -- Sampling phase
                counter <= counter + 1;
                if cap_input = '1' then
                    -- Button has risen to logic '1', record rise time
                    rise_time <= counter;
                    sampling <= '0';
                    counter <= 0;

                    -- Determine if button is pressed
                    if (rise_time > UNPRESSED_RISE_CYCLES + DETECTION_MARGIN / 2) then
                        if led_state = '1' then
                            led_state <= '0';
                        end if;
                    else
                        led_state <= '1';
                    end if;

                    discharge_done <= '0'; -- Restart discharge phase
                end if;
            end if;
        end if;
    end process;

    -- Assign LED output
    led <= led_state;

end Behavioral;
