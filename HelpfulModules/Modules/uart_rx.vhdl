library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Author: Tobias McKellar
-- A customisable UART transmitter module. 
-- It is capable of performing with an arbitrary number of start, stop , and data bits
-- Additionally, it will support any sensible baud_rate and clock_freq combination,
-- and is capable of being configured as active high or low.

entity uart_rx is
    generic (
        START_BITS : integer := 1;
        DATA_BITS : integer := 8;
        STOP_BITS : integer := 1;
        BAUD_RATE : integer := 9600;
        CLOCK_FREQ : integer := 50000000;
        ACTIVE_STATE : std_logic := '0'
    );
    port (
        clk   : in std_logic;
        reset : in std_logic;
        rx_serial_in : in std_logic;

        rx_byte_out : out std_logic_vector(7 downto 0);
        rx_byte_valid : out std_logic

    );
end entity uart_rx;

architecture behavioural of uart_rx is

    constant BIT_PERIOD : integer := CLOCK_FREQ / BAUD_RATE;
    
    type rx_state_type is (idle, startbits, databits, stopbits);
    signal s_rx_state : rx_state_type := idle;
    signal s_rx_state_check : integer range 0 to 3;
    signal s_rx_byte_out : std_logic_vector(DATA_BITS - 1 downto 0);
    signal s_rx_byte_valid : std_logic;

    signal s_counter : natural range 0 to START_BITS*BIT_PERIOD - 1;
    signal s_bit_index : natural range 0 to DATA_BITS - 1 := 0;

begin
        process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    s_rx_state <= idle;
                    s_counter <= 0;
                    s_bit_index <= 0;
                    s_rx_byte_out <= (others => '0');
                    s_rx_byte_valid <= '0';
                end if;

                case s_rx_state is
                    when idle =>
                        s_rx_byte_valid <= '0';
                        if rx_serial_in = ACTIVE_STATE then
                            s_counter <= s_counter + 1;
                            if s_counter = BIT_PERIOD/2 then
                                s_counter <= 0;
                                s_rx_state <= startbits;
                            end if;
                        else
                            s_counter <= 0;
                        end if;

                    when startbits =>
                        if s_counter = START_BITS*BIT_PERIOD - 1 then
                            s_counter <= 0;
                            s_rx_state <= databits;
                        else
                            s_counter <= s_counter + 1;
                        end if;

                    when databits =>
                        if s_counter = 0 then
                            s_rx_byte_out(s_bit_index) <= rx_serial_in;
                        end if;
                        if s_counter = BIT_PERIOD - 1 then
                            s_counter <= 0;
                            if s_bit_index < DATA_BITS - 1 then
                                s_bit_index <= s_bit_index + 1;
                            else
                                s_counter <= 0;
                                s_rx_state <= stopbits;
                            end if;
                        else
                            s_counter <= s_counter + 1;
                        end if;

                    when stopbits =>
                            s_counter <= 0;
                            s_rx_byte_valid <= '1';
                            s_rx_state <= idle;
                            s_bit_index <= 0;
                end case;
            end if;
        end process;
    rx_byte_out <= s_rx_byte_out;
    rx_byte_valid <= s_rx_byte_valid;
    -- s_rx_state_check is only useful for debugging. Can safely be removed to optimise LUT usage.
    s_rx_state_check <= 0 when s_rx_state = idle else
                    1 when s_rx_state = startbits else
                    2 when s_rx_state = databits else
                    3 when s_rx_state = stopbits;
end architecture behavioural;