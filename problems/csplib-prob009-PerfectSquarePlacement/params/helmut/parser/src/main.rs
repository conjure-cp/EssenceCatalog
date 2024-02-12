extern crate serde_json;

extern crate itertools;
use itertools::Itertools;

use serde_json::{Value};

use std::io;
use std::io::prelude::*;
use std::fs;

fn main() -> Result<(), io::Error> {
    let stdin = io::stdin();
    for line in stdin.lock().lines() {
        let json = format!("[{}]",line.unwrap());
        let v : Value = serde_json::from_str(&json).unwrap();

        let sequence : String = v[3].as_array()
                           .unwrap()
                           .iter()
                           .map(|x| x.to_string())
                           .intersperse(",".to_string()).collect();
        let file = format!(r###"
        $ From http://www.csplib.org/Problems/prob009/data/helmut.pdf
        $ Problem number {}
        $ Sequence length : {}
        language ESSENCE' 1.0
        letting sizemaster be {}
        letting sizes be sequence({})
        "###, v[0], v[1], v[2], sequence);
        let pos = v[0].as_i64().unwrap();
        let filename = format!("helmut{:03}.eprime-param", pos);
        fs::write(filename, file).unwrap()
    }
    Ok(())
}