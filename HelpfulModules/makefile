# Set the VHDL compiler and simulator
VHDL_COMPILER = ghdl
SIMULATOR = ghdl

# Set the source files
SOURCE_FILES := $(wildcard Modules/*.vhdl)
TESTBENCH_FILES = $(wildcard Testbenches/*.vhdl)
# Set the testbench entity
TESTBENCH_ENTITY = matmul_tb

# Set the output VCD file
VCD_FILE = matmul_tb.ghw

# Default target
all: run

# Target to run the simulation
run:
	$(VHDL_COMPILER) -a --workdir=bld $(SOURCE_FILES) 
	$(VHDL_COMPILER) -a --workdir=bld $(TESTBENCH_FILES)
	$(VHDL_COMPILER) -e --workdir=bld $(TESTBENCH_ENTITY)
	$(SIMULATOR) -r --workdir=bld $(TESTBENCH_ENTITY) --wave=vcd/$(VCD_FILE)

view:
	gtkwave vcd/$(VCD_FILE)
	

# Clean target to remove generated files
clean:
	rm -f *.o *.cf $(VCD_FILE)
	rm -rf bld vcd schematics Verilog json
	mkdir bld vcd schematics Verilog json


MODULES = matmul
schematic: $(MODULES)
$(MODULES):
	cd bld;\
	ghdl -a ../Modules/$@.vhdl;\
	$(VHDL_COMPILER) --synth --out=verilog $@ > ../Verilog/$@.v;\
	yosys -p "prep -top $@; write_json ../json/$@.json" ../Verilog/$@.v;\
	netlistsvg ../json/$@.json -o ../schematics/$@.svg;\

synthesise: $(MODULES)
$(MODULES):
	cd bld;\
	ghdl -a ../Modules/$@.vhdl;\
	$(VHDL_COMPILER) --synth --out=verilog $@ > ../Verilog/$@.v;\
	nextpnr -ice40 --hx8k --json $@.json --pcf $@.pcf --asc $@.asc;\

# yosys -p 'synth_ice40 -top $@ -json ../json/$@.json' ../Verilog/$@.v;\    
# 	#    # run place and route
# 	# icepack $@.asc $@.bin;\                                               # generate binary bitstream file
# 	# iceburn $@.bin;\        #for iceblink board use this as not FTDI based                                                   # upload design to iCEstick
# 	# icetime -tmd lp8k $@.asc;\