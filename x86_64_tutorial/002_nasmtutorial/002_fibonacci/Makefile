r:
		rm -rf out
		mkdir out
		nasm -felf64 src/main.asm
		mv ./src/main.o ./out/.
		ld ./out/main.o
		mv a.out out/.
		./out/a.out

clean:
		rm -rf out
