library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circularfifobuffer_tb is
end entity circularfifobuffer_tb;

architecture tb_arch of circularfifobuffer_tb is
    component circularfifobuffer is
        generic (
            DATA_WIDTH : integer := 8;
            DATA_DEPTH : integer := 8
        );
        port (
            clk : in std_logic;
            rst : in std_logic;
            write_fifo : in std_logic;
            read_fifo  : in std_logic;
            data_in  : in std_logic_vector(DATA_WIDTH-1 downto 0);
            data_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
            fifo_empty : out std_logic;
            fifo_full  : out std_logic;
            stored_elements : out integer range 0 to DATA_DEPTH - 1
        );
    end component circularfifobuffer;

    constant CLK_PERIOD : time := 30.303 ns;

    signal clk   : std_logic := '0';
    signal simDone : boolean := false;
    
    constant DATA_WIDTH : integer := 8;
    constant DATA_DEPTH : integer := 8;
    
    signal rst : std_logic := '0';
    signal write_fifo : std_logic := '0';
    signal read_fifo : std_logic := '0';
    signal data_in : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal data_out : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal fifo_empty : std_logic;
    signal fifo_full : std_logic;
    signal stored_elements : integer range 0 to DATA_DEPTH - 1;

begin

    circbuf_inst : circularfifobuffer
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            DATA_DEPTH => DATA_DEPTH
        )
        port map (
            clk => clk,
            rst => rst,
            write_fifo => write_fifo,
            read_fifo => read_fifo,
            data_in => data_in,
            data_out => data_out,
            fifo_empty => fifo_empty,
            fifo_full => fifo_full,
            stored_elements => stored_elements
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

    fifo_process : process
    begin
        rst <= '1';
        wait for CLK_PERIOD*10;
        rst <= '0';
        write_fifo <= '1';
        data_in <= X"00";
        wait for CLK_PERIOD/2;
        data_in <= X"01";
        wait for CLK_PERIOD;
        data_in <= X"02";
        wait for CLK_PERIOD;
        data_in <= X"03";
        wait for CLK_PERIOD;
        data_in <= X"04";
        wait for CLK_PERIOD;
        data_in <= X"05";
        wait for CLK_PERIOD;
        data_in <= X"06";
        wait for CLK_PERIOD;
        data_in <= X"07";
        wait for CLK_PERIOD;
        data_in <= X"08";
        wait for CLK_PERIOD;
        data_in <= X"09";
        write_fifo <= '0';
        wait for CLK_PERIOD;
        read_fifo <= '1';
        wait for CLK_PERIOD;
        read_fifo <= '0';
        wait for CLK_PERIOD;
        write_fifo <= '1';
        data_in <= X"00";
        wait for CLK_PERIOD/2;
        data_in <= X"01";
        wait for CLK_PERIOD;
        data_in <= X"02";
        wait for CLK_PERIOD;
        data_in <= X"03";
        wait for CLK_PERIOD;
        data_in <= X"04";
        wait for CLK_PERIOD;
        data_in <= X"05";
        wait for CLK_PERIOD;
        data_in <= X"06";
        wait for CLK_PERIOD;
        data_in <= X"07";
        wait for CLK_PERIOD;
        data_in <= X"08";
        wait for CLK_PERIOD;
        data_in <= X"09";
        write_fifo <= '0';
        wait for CLK_PERIOD;
        read_fifo <= '1';
        wait for 20*CLK_PERIOD;
        read_fifo <= '0';

        write_fifo <= '1';
        data_in <= X"FF";
        wait for CLK_PERIOD;
        read_fifo <= '1';
        data_in <= X"AA";
        wait for CLK_PERIOD;
        data_in <= X"BB";
        wait for CLK_PERIOD;
        data_in <= X"CC";
        wait for CLK_PERIOD;
        write_fifo <= '0';
        wait for CLK_PERIOD*5;
        read_fifo <= '0';


        simDone <= true;
        wait;
    end process;
end architecture tb_arch;