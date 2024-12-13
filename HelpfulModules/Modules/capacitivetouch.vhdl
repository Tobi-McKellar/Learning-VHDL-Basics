library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity capacitivetouch is
    port (
        clk       : in  std_logic;  -- System clock
        reset     : in  std_logic;  -- Asynchronous reset
        cap_inout : inout std_logic;
        led       : out std_logic   -- LED output
    );
end capacitivetouch;

architecture Behavioral of capacitivetouch is

    type ctrl_state_t is (S_INIT_DISCHARGE, S_INIT_SAMPLE, S_RUN_DISCHARGE, S_RUN_SAMPLE);
    signal state : ctrl_state_t := S_INIT_DISCHARGE;


    -- Signals
    signal counter        : integer range 0 to 2**10 - 1 := 0; -- Counts clock cycles for rise time measurement
    signal calibration_rise_time      : integer range 0 to 2**10 - 1 := 0; -- Recorded rise time in clock cycles
    signal rise_time      : integer range 0 to 2**10 - 1 := 0; -- Recorded rise time in clock cycles
    signal discharging : std_logic := '0'; -- Indicates discharge phase completion
    signal led_state      : std_logic := '1'; -- LED default state
    signal led_state_prev : std_logic := '1';

    signal sync_ff1 : std_logic := '0';
    signal sync_ff2 : std_logic := '0';
begin

    -- Tri-State Driver
    cap_inout <= '0' when discharging = '1' else 'Z';

    -- Main process
    process(clk, reset)
    begin
        if reset = '0' then
            counter        <= 0;
            rise_time      <= 0;
            discharging    <= '1';
            led_state      <= '1';
            sync_ff1       <= '0';
            sync_ff2       <= '0';

        elsif rising_edge(clk) then
            sync_ff1 <= cap_inout;
            sync_ff2 <= sync_ff1;

            case state is
                when S_INIT_DISCHARGE =>
                    counter <= counter + 1;
                    discharging <= '1';
                    if counter >= 10 then
                        counter <= 0;
                        state <= S_INIT_SAMPLE;
                        discharging <= '0';
                    end if;

                when S_INIT_SAMPLE =>
                    counter <= counter + 1;
                    if sync_ff2 = '1' then
                        calibration_rise_time <= counter;
                        counter <= 0;
                        state <= S_RUN_DISCHARGE;
                        discharging <= '1';
                    end if;

                when S_RUN_DISCHARGE =>
                    counter <= counter + 1;
                    discharging <= '1';
                    if counter >= 10 then
                        counter <= 0;
                        state <= S_RUN_SAMPLE;
                        discharging <= '0';
                    end if;

                when S_RUN_SAMPLE =>
                counter <= counter + 1;
                    if sync_ff2 = '1' then
                        rise_time <= counter;
                        counter <= 0;
                        discharging <= '1';

                        if rise_time > calibration_rise_time + to_integer(shift_right(to_unsigned(calibration_rise_time, 10), 3)) then
                            if led_state = '1' then
                                led_state <= '0';
                            end if;
                        else
                            led_state <= '1';
                        end if;
                        state <= S_RUN_DISCHARGE;
                        discharging <= '1';
                        counter <= 0;
                    end if;
            end case;
        end if;
    end process;

    -- Assign LED output
    led <= led_state;

end Behavioral;
