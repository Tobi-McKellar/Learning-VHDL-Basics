library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Author: Tobias McKellar
-- A customisable UART transmitter module. 
-- It is capable of performing with an arbitrary number of start, stop , and data bits
-- Additionally, it will support any sensible baud_rate and clock_freq combination,
-- and is capable of being configured as active high or low.

-- Assumes that STOP_BITS is always <= START_BITS
-- Assumes that PARITY is always 0 (no parity) as this allows for higher throughput


entity uart_tx is
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
        byte_to_transmit  : in std_logic_vector(7 downto 0);
        send_byte : in std_logic;
        
        tx_serial_out : out std_logic;
        tx_active : out std_logic
    );
end entity;

architecture behavioural of uart_tx is

    constant BIT_PERIOD : integer := CLOCK_FREQ / BAUD_RATE;

    type tx_state_type is (idle, startbits, databits, stopbits);
    signal s_tx_state : tx_state_type;
    signal s_tx_state_check : integer range 0 to 3;
    
    signal s_counter : natural range 0 to START_BITS*BIT_PERIOD - 1;
    signal s_bit_index : natural range 0 to DATA_BITS;
    signal s_stop_bit_index : natural range 0 to STOP_BITS - 1;
    signal s_byte_to_transmit : std_logic_vector(7 downto 0);
    signal s_tx_serial_out_reg : std_logic;

begin

 

    process (clk)
    begin

        if rising_edge(clk) then
            -- Synchronous reset
            if reset = '1' then
                s_tx_state <= idle;
                s_counter <= 0;
                s_bit_index <= 0;
                s_byte_to_transmit <= (others => '0');
                s_tx_serial_out_reg <= not ACTIVE_STATE;
            end if;
            case s_tx_state is
                when idle =>
                    if send_byte = '1' then
                        s_byte_to_transmit <= byte_to_transmit;
                        s_tx_state <= startbits;
                        s_counter <= 0;
                    else
                        s_tx_serial_out_reg <= not ACTIVE_STATE;
                    end if;

                when startbits =>
                    if s_counter = (START_BITS*BIT_PERIOD) - 1 then
                        s_counter <= 0;
                        s_tx_state <= databits;
                    else
                        s_counter <= s_counter + 1;
                        s_tx_serial_out_reg <= ACTIVE_STATE;
                    end if;

                when databits =>
                    s_tx_serial_out_reg <= s_byte_to_transmit(s_bit_index);
                    if s_counter = BIT_PERIOD - 1 then
                        s_counter <= 0;
                        if s_bit_index = DATA_BITS - 1 then
                            s_tx_state <= stopbits;
                        else
                            s_bit_index <= s_bit_index + 1;
                        end if;
                    else
                        s_counter <= s_counter + 1;
                    end if;

                when stopbits =>
                    s_tx_serial_out_reg <= not ACTIVE_STATE;
                    if s_counter = STOP_BITS*BIT_PERIOD - 1 then
                        s_counter <= 0;
                        s_bit_index <= 0;
                        s_byte_to_transmit <= (others => '0');
                        s_tx_state <= idle;
                    else
                        s_counter <= s_counter + 1;
                    end if;
            end case;
        end if;
    end process;
    tx_serial_out <= s_tx_serial_out_reg;
    tx_active <= '0' when s_tx_state = idle else '1';
     -- s_tx_state_check is only useful for debugging. Can safely be removed to optimise LUT usage.
    -- s_tx_state_check <= 0 when s_tx_state = idle else
    --                 1 when s_tx_state = startbits else
    --                 2 when s_tx_state = databits else
    --                 3 when s_tx_state = stopbits;

end architecture;