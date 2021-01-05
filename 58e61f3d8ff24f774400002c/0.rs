use std::cmp::Ordering;
use std::collections::HashMap;

pub struct AssemblerInterpreter<'a> {
    instr_list: Vec<Vec<&'a str>>,
    reg_map: HashMap<&'a str, i64>,
    label_map: HashMap<&'a str, usize>,
}

impl<'a> AssemblerInterpreter<'a> {
    fn parse(input: &'a str) -> Self {
        let mut instr_list: Vec<Vec<&str>> = Vec::new();
        let mut label_map = HashMap::new();
        for line in input.split('\n') {
            let mut instr = Vec::new();
            let mut last_idx = 0usize;
            let mut is_in_str = false;
            let mut is_in_token = false;
            for (idx, c) in line.char_indices() {
                if is_in_str {
                    if c == '\'' {
                        is_in_str = false;
                        instr.push(&line[last_idx..idx]); // strs are stored as 'xxx
                    }
                    continue;
                }
                match c {
                    '\'' => {
                        is_in_str = true;
                        last_idx = idx;
                    }
                    ';' => break,
                    ':' => {
                        is_in_token = false;
                        label_map.insert(&line[last_idx..idx], instr_list.len() - 1);
                    }
                    ' ' | ',' => {
                        if is_in_token {
                            is_in_token = false;
                            instr.push(&line[last_idx..idx]);
                        }
                    }
                    _ => {
                        if !is_in_token {
                            is_in_token = true;
                            last_idx = idx;
                        }
                    }
                }
            }
            if is_in_token {
                instr.push(&line[last_idx..]);
            }
            if !instr.is_empty() {
                instr_list.push(instr);
            }
        }
        Self {
            instr_list,
            reg_map: HashMap::new(),
            label_map,
        }
    }

    fn get_val(&self, s: &str) -> i64 {
        match s.parse::<i64>() {
            Ok(val) => val,
            Err(_) => self.reg_map[s],
        }
    }

    fn jump(&self, pc: &mut usize, a: &str, cond: bool) {
        if cond {
            *pc = self.label_map[a];
        }
    }

    fn execute(&mut self) -> Option<String> {
        let mut cmp = Ordering::Less;
        let mut is_ended = false;
        let mut output = String::new();
        let mut pc_stack = Vec::new();
        let mut pc = 0;

        while let Some(instr) = self.instr_list.get(pc) {
            match instr.as_slice() {
                ["mov", a, b] => {
                    self.reg_map.insert(a, self.get_val(b));
                }
                ["inc", a] => *self.reg_map.get_mut(a).unwrap() += 1,
                ["dec", a] => *self.reg_map.get_mut(a).unwrap() -= 1,
                ["add", a, b] => *self.reg_map.get_mut(a).unwrap() += self.get_val(b),
                ["sub", a, b] => *self.reg_map.get_mut(a).unwrap() -= self.get_val(b),
                ["mul", a, b] => *self.reg_map.get_mut(a).unwrap() *= self.get_val(b),
                ["div", a, b] => *self.reg_map.get_mut(a).unwrap() /= self.get_val(b),
                ["cmp", a, b] => cmp = self.get_val(a).cmp(&self.get_val(b)),
                ["jmp", a] => pc = self.label_map[a],
                ["je", a] => self.jump(&mut pc, a, cmp == Ordering::Equal),
                ["jne", a] => self.jump(&mut pc, a, cmp != Ordering::Equal),
                ["jl", a] => self.jump(&mut pc, a, cmp == Ordering::Less),
                ["jge", a] => self.jump(&mut pc, a, cmp != Ordering::Less),
                ["jg", a] => self.jump(&mut pc, a, cmp == Ordering::Greater),
                ["jle", a] => self.jump(&mut pc, a, cmp != Ordering::Greater),
                ["call", a] => {
                    pc_stack.push(pc);
                    pc = self.label_map[a];
                }
                ["ret"] => pc = pc_stack.pop().unwrap(),
                ["msg", msgs @ ..] => {
                    for ele in msgs {
                        if ele.chars().next().unwrap() == '\'' {
                            output += &ele[1..];
                        } else {
                            output += &self.reg_map[ele].to_string();
                        }
                    }
                }
                ["end"] => {
                    is_ended = true;
                    break;
                }
                _ => panic!(),
            }
            pc += 1;
        }

        if is_ended {
            Some(output)
        } else {
            None
        }
    }

    pub fn interpret(input: &'a str) -> Option<String> {
        Self::parse(input).execute()
    }
}
