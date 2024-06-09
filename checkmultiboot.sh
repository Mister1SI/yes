if grub-file --is-x86-multiboot out/bin/os.bin; then
  echo "==========\nMULTIBOOT    [OK]\n==========\n"
else
  echo "==========\nMULTIBOOT  [FAIL]\n==========\n"
fi