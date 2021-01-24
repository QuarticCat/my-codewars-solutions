use std::collections::HashMap;
use std::iter::Peekable;
use std::vec::IntoIter;

#[derive(Debug)]
enum Ast {
    UnOp(String, i32),
    BinOp(String, Box<Ast>, Box<Ast>),
}

struct Compiler();

impl Compiler {
    fn new() -> Compiler {
        Compiler()
    }

    fn tokenize(&self, program: &str) -> Vec<String> {
        let mut tokens: Vec<String> = vec![];
        let mut iter = program.chars().peekable();
        while let Some(&c) = iter.peek() {
            match c {
                'a'..='z' | 'A'..='Z' => {
                    let mut tmp = String::new();
                    while iter.peek().map_or(false, |c| c.is_alphabetic()) {
                        tmp.push(iter.next().unwrap());
                    }
                    tokens.push(tmp);
                }
                '0'..='9' => {
                    let mut tmp = String::new();
                    while iter.peek().map_or(false, |c| c.is_numeric()) {
                        tmp.push(iter.next().unwrap());
                    }
                    tokens.push(tmp);
                }
                ' ' => {
                    iter.next();
                }
                _ => {
                    tokens.push(iter.next().unwrap().to_string());
                }
            }
        }
        tokens
    }

    fn compile(&mut self, program: &str) -> Vec<String> {
        let ast = self.pass1(program);
        let ast = self.pass2(&ast);
        self.pass3(&ast)
    }

    fn pass1(&mut self, program: &str) -> Ast {
        type Iter = Peekable<IntoIter<String>>;

        fn parse_arg_list(iter: &mut Iter) -> HashMap<String, i32> {
            let mut ret = HashMap::new();
            while let Some(s) = iter.next() {
                match s.as_str() {
                    "[" => continue,
                    "]" => break,
                    _ => {
                        ret.insert(s, ret.len() as i32);
                    }
                }
            }
            ret
        }

        fn parse_sum(iter: &mut Iter, args: &HashMap<String, i32>) -> Ast {
            let mut ret = parse_product(iter, args);
            while let Some(s) = iter.peek() {
                match s.as_str() {
                    "+" | "-" => {
                        ret = Ast::BinOp(
                            iter.next().unwrap(),
                            Box::new(ret),
                            Box::new(parse_product(iter, args)),
                        );
                    }
                    _ => break,
                }
            }
            ret
        }

        fn parse_product(iter: &mut Iter, args: &HashMap<String, i32>) -> Ast {
            let mut ret = parse_value(iter, args);
            while let Some(s) = iter.peek() {
                match s.as_str() {
                    "*" | "/" => {
                        ret = Ast::BinOp(
                            iter.next().unwrap(),
                            Box::new(ret),
                            Box::new(parse_value(iter, args)),
                        );
                    }
                    _ => break,
                }
            }
            ret
        }

        fn parse_value(iter: &mut Iter, args: &HashMap<String, i32>) -> Ast {
            let s = iter.next().unwrap();
            match s.as_str() {
                "(" => {
                    let ret = parse_sum(iter, args);
                    iter.next(); // consume ')'
                    ret
                }
                _ => match args.get(&s) {
                    Some(&idx) => Ast::UnOp("arg".to_owned(), idx),
                    None => Ast::UnOp("imm".to_owned(), s.parse().unwrap()),
                },
            }
        }

        let mut token_iter = self.tokenize(program).into_iter().peekable();
        let args = parse_arg_list(&mut token_iter);
        parse_sum(&mut token_iter, &args)
    }

    fn pass2(&mut self, ast: &Ast) -> Ast {
        match ast {
            Ast::UnOp(t, v) => Ast::UnOp(t.clone(), *v),
            Ast::BinOp(op, l, r) => match (self.pass2(l), self.pass2(r)) {
                (Ast::UnOp(t1, v1), Ast::UnOp(t2, v2)) if t1 == "imm" && t2 == "imm" => Ast::UnOp(
                    "imm".to_owned(),
                    match op.as_str() {
                        "+" => v1 + v2,
                        "-" => v1 - v2,
                        "*" => v1 * v2,
                        "/" => v1 / v2,
                        _ => panic!(),
                    },
                ),
                (l, r) => Ast::BinOp(op.clone(), Box::new(l), Box::new(r)),
            },
        }
    }

    fn pass3(&mut self, ast: &Ast) -> Vec<String> {
        match ast {
            Ast::UnOp(t, v) => match t.as_str() {
                "arg" => vec![format!("AR {}", v)],
                "imm" => vec![format!("IM {}", v)],
                _ => panic!(),
            },
            Ast::BinOp(op, l, r) => {
                let mut ret = self.pass3(l);
                ret.push("PU".to_owned());
                ret.extend(self.pass3(r));
                ret.push("SW".to_owned());
                ret.push("PO".to_owned());
                ret.push(match op.as_str() {
                    "+" => "AD".to_owned(),
                    "-" => "SU".to_owned(),
                    "*" => "MU".to_owned(),
                    "/" => "DI".to_owned(),
                    _ => panic!(),
                });
                ret
            }
        }
    }
}
