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
