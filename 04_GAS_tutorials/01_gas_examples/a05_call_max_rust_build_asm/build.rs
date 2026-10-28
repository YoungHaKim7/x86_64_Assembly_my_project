fn main() {
    // Tell Cargo to invalidate the built crate if the assembly file changes
    println!("cargo:rerun-if-changed=src/maxofthree.s");

    // Use the `cc` crate to compile the assembly file
    cc::Build::new().file("src/maxofthree.s").compile("cc"); // Compiles to libfoo.a
}
