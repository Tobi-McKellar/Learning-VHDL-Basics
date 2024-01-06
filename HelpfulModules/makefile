# Set the VHDL compiler and simulator
VHDL_COMPILER = ghdl
SIMULATOR = ghdl

# Set the source files
SOURCE_FILES := $(wildcard Modules/*.vhdl)
TESTBENCH_FILES = $(wildcard Testbenches/*.vhdl)
# Set the testbench entity
TESTBENCH_ENTITY = mux_tb

# Set the output VCD file
VCD_FILE = mux.ghw

# Default target
all: run

# Target to run the simulation
run:
	$(VHDL_COMPILER) -a  --workdir=bld $(SOURCE_FILES)
	$(VHDL_COMPILER) -a  --workdir=bld $(TESTBENCH_FILES)
	$(VHDL_COMPILER) -e  --workdir=bld $(TESTBENCH_ENTITY)
	$(SIMULATOR) -r --workdir=bld $(TESTBENCH_ENTITY) --wave=vcd/$(VCD_FILE)

view:
	gtkwave vcd/$(VCD_FILE)
	

# Clean target to remove generated files
clean:
	rm -f *.o *.cf $(VCD_FILE)
	rm -rf bld vcd
	mkdir bld vcd
