ASM_FOLDER := example_asm
SCRIPT_FOLDER := scripts

%: %.s
	@mips64-linux-gnu-as -O0 -mips64r6 $< -o $@
	@mips64-linux-gnu-ld -T $(dir $<)script.ld $@ -o $@.elf
	@mips64-linux-gnu-objdump --section=.text -D $@.elf > ./memory_dump.text.dat
	@mips64-linux-gnu-objdump --section=.data -D $@.elf > ./memory_dump.data.dat || rm -f ./memory_dump.data.dat
	@python $(dir $@)../$(SCRIPT_FOLDER)/objdump2dat.py

%: %.c
	# TODO support compact branch inst and remove `-mcompact-branches=never` 
	@mips64-linux-gnu-gcc -O0 -mips64r6 -mcompact-branches=never -fomit-frame-pointer -nostartfiles -nostdlib -fno-asynchronous-unwind-tables -fomit-frame-pointer -fno-stack-protector -T $(dir $<)script.ld $< -o $@.elf
	@mips64-linux-gnu-objdump --section=.text -D $@.elf > ./memory_dump.text.dat
	@mips64-linux-gnu-objdump --section=.data -D $@.elf > ./memory_dump.data.dat || rm -f ./memory_dump.data.dat
	@python $(dir $@)../$(SCRIPT_FOLDER)/objdump2dat.py

clean_asm:
	rm -f  $(ASM_FOLDER)/*.o $(ASM_FOLDER)/*.elf
	rm -f ./memory_dump.text.dat ./memory_dump.data.dat ./memory.text.dat ./memory.data.dat

