library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity debouncer_tb is
    end debouncer_tb;
    
    architecture testbench of debouncer_tb is

        -- Component instantiation
        component debouncer is
            generic (
                clk_freq : integer := 50_000_000;
                debounce_time_ms : integer := 100_000;
                num_buttons : integer := 4
            );
            port (
                clk : in std_logic;
                rst : in std_logic;
                buttons : in std_logic_vector(num_buttons-1 downto 0);
                button_debounced : out std_logic_vector(num_buttons-1 downto 0)
            );
        end component;
    
        -- Constants
        constant CLK_PERIOD : time := 30.303 ns;
    
        -- Signals
        signal simDone : boolean := false;

        signal clk : std_logic := '0';
        signal rst : std_logic := '0';
        signal buttons : std_logic_vector(3 downto 0) := (others => '0');
        signal button_debounced : std_logic_vector(3 downto 0);
    

    
    begin
    
        debouncer_inst : debouncer
            generic map (
                clk_freq => 33_300_000,
                debounce_time_ms => 10,
                num_buttons => 4
            )
            port map (
                clk => clk,
                rst => rst,
                buttons => buttons,
                button_debounced => button_debounced
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
    

        test : process
        begin
            rst <= '1';
            wait for 10 ns;
            rst <= '0';
            wait for 20 ms;
            buttons <= "1010";
            wait for 20 ms;
            buttons <= "0101";
            wait for 20 ms;
            buttons <= "1111";
            wait for 20 ms;
            buttons <= "0000";
            wait for 9 ms;
            buttons <= "1100";
            wait for 20 ms;

            simDone <= true;
            wait;

        end process;
    
    end testbench;
    