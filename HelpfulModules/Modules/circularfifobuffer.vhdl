library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circularfifobuffer is
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
        stored_elements : out integer range 0 to DATA_DEPTH -- not necessary, can be left open to reduce LUT usage
    );
end entity circularfifobuffer;

architecture rtl of circularfifobuffer is
    type ram_type is array (DATA_DEPTH downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0); -- leave an extra slot for the empty/full check
    signal ram : ram_type := (others => (others => '0'));
    signal s_write_ptr : integer range 0 to DATA_DEPTH := 0;
    signal s_read_ptr  : integer range 0 to DATA_DEPTH := 0;
    signal s_fifo_empty : std_logic := '1';
    signal s_fifo_full  : std_logic := '0';
    signal s_stored_elements : integer range 0 to DATA_DEPTH := 0;

    -- increment pointer with wraparound
    procedure incr(signal index : inout integer range 0 to DATA_DEPTH) is
        begin
          if index = DATA_DEPTH then
            index <= 0;
          else
            index <= index + 1;
          end if;
        end procedure;

begin

    write_pointer_update : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_write_ptr <= 0;
            else
                if write_fifo = '1' and s_fifo_full = '0' then
                    ram(s_write_ptr) <= data_in;
                    incr(s_write_ptr);
                end if;
            end if;
        end if;
    end process;

    read_pointer_update : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_read_ptr <= 0;
            else
                if read_fifo = '1' and s_fifo_empty = '0' then
                    incr(s_read_ptr);
                end if;
            end if;
        end if;
    end process;

    ram_read_write : process (clk)
    begin
        if rising_edge(clk) then
            if write_fifo = '1' and s_fifo_full = '0' then
                ram(s_write_ptr) <= data_in;
            end if;
            data_out <= ram(s_read_ptr);
        end if;
    end process;

    s_fifo_empty <= '1' when s_stored_elements = 0 else '0';
    s_fifo_full  <= '1' when s_stored_elements = DATA_DEPTH else '0';

    s_stored_elements <= s_write_ptr - s_read_ptr + DATA_DEPTH + 1 when s_write_ptr < s_read_ptr 
                        else s_write_ptr - s_read_ptr;

    fifo_empty <= s_fifo_empty;
    fifo_full  <= s_fifo_full;
    stored_elements <= s_stored_elements;
    
end architecture rtl;
