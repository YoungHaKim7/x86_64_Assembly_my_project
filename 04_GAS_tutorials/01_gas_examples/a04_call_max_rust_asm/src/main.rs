use std::arch::global_asm;

// Assemble src/maxofthree.s (GAS AT&T syntax, System V AMD64) into this crate.
// global_asm! takes a string literal, so include_str! splices the file in;
// rustc's assembler defaults to Intel syntax, hence options(att_syntax).
global_asm!(include_str!("maxofthree.s"), options(att_syntax));

unsafe extern "C" {
    fn maxofthree(x: i64, y: i64, z: i64) -> i64;
}

fn main() {
    unsafe {
        println!("{}", maxofthree(1, -4, -7));
        println!("{}", maxofthree(2, -6, 1));
        println!("{}", maxofthree(2, 3, 1));
        println!("{}", maxofthree(-2, 4, 3));
        println!("{}", maxofthree(2, -6, 5));
        println!("{}", maxofthree(2, 4, 6));
    }
}
