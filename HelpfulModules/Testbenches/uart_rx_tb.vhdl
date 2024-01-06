library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Author: Tobias McKellar

-- A more comprehensive test module for both the uart_rx and uart_tx modules.
-- This verifies the ability to send and transmit data between the two modules.

entity uart_rx_tb is
end entity uart_rx_tb;


architecture tb_arch of uart_rx_tb is
    component uart_rx is
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
    end component;

    component uart_tx is
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
    end component;

    constant CLK_PERIOD : time := 30.303 ns;

    signal clk   : std_logic := '0';
    signal simDone : boolean := false;

    signal reset : std_logic := '0';
    signal rx_byte_out  : std_logic_vector(7 downto 0);
    signal rx_byte_valid: std_logic;

    signal byte_to_transmit : std_logic_vector(7 downto 0);
    signal send_byte : std_logic := '0';
    signal tx_serial_out : std_logic;
    signal tx_active : std_logic;

begin

    rx_inst : uart_rx
    generic map (
        START_BITS => 1,
        DATA_BITS => 8,
        STOP_BITS => 1,
        BAUD_RATE => 19_200,
        CLOCK_FREQ => 33_300_000,
        ACTIVE_STATE => '0'
    )
    port map (
        clk => clk,
        reset => reset,
        rx_serial_in => tx_serial_out,
        rx_byte_out => rx_byte_out,
        rx_byte_valid => rx_byte_valid
    );

    tx_inst : uart_tx
    generic map (
        START_BITS => 1,
        DATA_BITS => 8,
        STOP_BITS => 1,
        BAUD_RATE => 19_200,
        CLOCK_FREQ => 33_300_000,
        ACTIVE_STATE => '0'
    )
    port map (
        clk => clk,
        reset => reset,
        byte_to_transmit => byte_to_transmit,
        send_byte => send_byte,
        tx_serial_out => tx_serial_out,
        tx_active => tx_active
    );

    clk_process : process
    begin 
        if simDone then
            wait;
        else
            clk <= '1';
            wait for CLK_PERIOD/2;
            clk <= '0';
            wait for CLK_PERIOD/2;
        end if;
    end process;

    serial_process : process
    begin
        wait for 100 us;
        send_byte <= '1';
        byte_to_transmit <= X"00";
        wait until tx_active = '0';
        assert rx_byte_out = byte_to_transmit report "Received byte does not match byte_to_transmit" severity error;

        byte_to_transmit <= X"0F";
        wait until tx_active = '0';
        assert rx_byte_out = byte_to_transmit report "Received byte does not match byte_to_transmit" severity error;

        byte_to_transmit <= X"FF";
        wait until tx_active = '0';
        assert rx_byte_out = byte_to_transmit report "Received byte does not match byte_to_transmit" severity error;

        byte_to_transmit <= X"F0";
        wait until tx_active = '0';
        assert rx_byte_out = byte_to_transmit report "Received byte does not match byte_to_transmit" severity error;

        byte_to_transmit <= X"11";
        wait until tx_active = '0';
        assert rx_byte_out = byte_to_transmit report "Received byte does not match byte_to_transmit" severity error;

        byte_to_transmit <= X"33";
        wait until tx_active = '0';
        assert rx_byte_out = byte_to_transmit report "Received byte does not match byte_to_transmit" severity error;

        byte_to_transmit <= X"52";
        wait until tx_active = '0';
        assert rx_byte_out = byte_to_transmit report "Received byte does not match byte_to_transmit" severity error;

        byte_to_transmit <= X"0D";
        wait until tx_active = '0';
        assert rx_byte_out = byte_to_transmit report "Received byte does not match byte_to_transmit" severity error;


        simDone <= true;
        wait;
    end process;

end architecture tb_arch;

    