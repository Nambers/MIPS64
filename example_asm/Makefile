ASM_FILES := $(wildcard *.s)

%.o: %.s
	mips64-linux-gnu-as -Wall -O0 -mips64 $< -o $@
	mips64-linux-gnu-ld -T script.ld $@ -o $@.elf
	mips64-linux-gnu-objdump --section=.text -D $@.elf > ../memory_dump.text.dat
	mips64-linux-gnu-objdump --section=.data -D $@.elf > ../memory_dump.data.dat
	cd .. && python objdump2dat.py

clean:
	rm -f *.o *.elf
	rm -f ../memory_dump.text.dat ../memory_dump.data.dat ../memory.text.dat ../memory.data.dat

