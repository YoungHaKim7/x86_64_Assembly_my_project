r:
		rm -rf target
		mkdir target
		nasm -felf64 src/main.asm
		mv ./src/main.o ./target/.
		ld ./target/main.o
		mv a.out target/.
		./target/a.out

clean:
		rm -rf target
