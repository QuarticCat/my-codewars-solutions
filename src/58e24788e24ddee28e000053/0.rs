fn simple_assembler(program: Vec<&str>) -> HashMap<String, i64> {
    fn parse(reg_map: &HashMap<String, i64>, s: &str) -> i64 {
        match s.parse::<i64>() {
            Ok(val) => val,
            Err(_) => reg_map[s],
        }
    }

    let instr_list: Vec<Vec<&str>> = program.iter().map(|s| s.split(' ').collect()).collect();
    let mut reg_map = HashMap::new();
    let mut pc = 0usize;
    while pc < program.len() {
        let instr = &instr_list[pc];
        match instr[0] {
            "mov" => {
                reg_map.insert(instr[1].to_owned(), parse(&reg_map, instr[2]));
            }
            "inc" => {
                reg_map.get_mut(instr[1]).map(|v| *v += 1);
            }
            "dec" => {
                reg_map.get_mut(instr[1]).map(|v| *v -= 1);
            }
            "jnz" => {
                if parse(&reg_map, instr[1]) != 0 {
                    pc = pc.wrapping_add(instr[2].parse::<i64>().unwrap() as usize);
                    continue;
                }
            }
            _ => panic!(),
        }
        pc += 1;
    }
    reg_map
}
