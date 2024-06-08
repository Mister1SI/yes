KERNELSRC=$(wildcard kernel/*.c)
KERNELOBJ=$(foreach src,$(KERNELSRC) out/obj/boot.o, out/obj/$(notdir $(basename $(src))).o)
ALLOBJ=$(wildcard out/obj/*.o)

$(info KERNELSRC: $(KERNELSRC))
$(info KERNELOBJ: $(KERNELOBJ))
$(info ALLOBJ: $(ALLOBJ))


all: qemu
qemu: cleanout iso
	qemu-system-i386 out/iso/os.iso

out/obj/%.o: kernel/%.c
	i686-elf-gcc -c $^ -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

out/obj/boot.o: boot.s
	nasm -felf32 -o out/obj/boot.o boot.s

iso: cleaniso $(KERNELOBJ) $(ALLOBJ) out/obj/boot.o
	@echo "KSRC: $(KERNELSRC) ||| KOBJ: $(KERNELOBJ) ||| ALLOBJ: $(ALLOBJ)"
	i686-elf-gcc -T linker.ld -o out/bin/os.bin -ffreestanding -O2 -nostdlib $(ALLOBJ)
	mkdir -p iso/boot/grub
	cp grub.cfg iso/boot/grub/
	cp out/bin/os.bin iso/boot/
	grub-mkrescue -o out/iso/os.iso iso

cleaniso:
	rm -rf iso

cleanout:
	rm -rf out
	mkdir -p out/obj
	mkdir out/bin
	mkdir out/iso

