library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Author: Tobias McKellar
-- A not terribly comprehensive testbench for the uart_tx module. 
-- More comprehensive testing is actually done in the uart_rx testbench,
-- as this validates the ability for the two modules to communicate properly.

entity uart_tx_test is
end entity;

architecture test of uart_tx_test is

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
signal simDone : boolean := false;

signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal byte_to_transmit : std_logic_vector(7 downto 0) := (others => '0');
signal send_byte : std_logic := '0';

signal tx_serial_out : std_logic;
signal tx_active : std_logic;

begin

    tx_inst : uart_tx
    generic map (
        START_BITS => 1,
        DATA_BITS => 8,
        STOP_BITS => 1,
        BAUD_RATE => 19_200,
        CLOCK_FREQ => 33_300_000,
        ACTIVE_STATE => '1'
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

        byte_to_transmit <= X"0F";
        wait until tx_active = '0';

        byte_to_transmit <= X"FF";
        wait until tx_active = '0';

        byte_to_transmit <= X"F0";
        wait until tx_active = '0';

        simDone <= true;
        wait;
    end process;
end architecture test;