use std::fmt::{Display, Error, Formatter};
use std::slice::Iter;
use std::str::FromStr;
use std::{ops, write};

#[derive(Clone)]
enum Expr {
    Var,
    Num(f64),
    Add(Box<Expr>, Box<Expr>),
    Sub(Box<Expr>, Box<Expr>),
    Mul(Box<Expr>, Box<Expr>),
    Div(Box<Expr>, Box<Expr>),
    Pow(Box<Expr>, Box<Expr>),
    Cos(Box<Expr>),
    Sin(Box<Expr>),
    Tan(Box<Expr>),
    Exp(Box<Expr>),
    Ln(Box<Expr>),
}

impl FromStr for Expr {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        fn parse(iter: &mut Iter<u8>) -> Expr {
            while let Some(c) = iter.next() {
                match c {
                    b'x' => return Expr::Var,
                    b'0'..=b'9' => {
                        let mut num = (c - b'0') as i64;
                        while let Some(c @ b'0'..=b'9') = iter.next() {
                            num = num * 10 + (c - b'0') as i64;
                        }
                        return Expr::Num(num as f64);
                    }
                    b'+' => return parse(iter) + parse(iter),
                    b'-' => {
                        if let Some(c @ b'0'..=b'9') = iter.next() {
                            let mut num = (c - b'0') as i64;
                            while let Some(c @ b'0'..=b'9') = iter.next() {
                                num = num * 10 + (c - b'0') as i64;
                            }
                            return Expr::Num(-num as f64);
                        } else {
                            return parse(iter) - parse(iter);
                        }
                    }
                    b'*' => return parse(iter) * parse(iter),
                    b'/' => return parse(iter) / parse(iter),
                    b'^' => return parse(iter).pow(parse(iter)),
                    b'c' => {
                        iter.next();
                        iter.next();
                        return parse(iter).cos();
                    }
                    b's' => {
                        iter.next();
                        iter.next();
                        return parse(iter).sin();
                    }
                    b't' => {
                        iter.next();
                        iter.next();
                        return parse(iter).tan();
                    }
                    b'e' => {
                        iter.next();
                        iter.next();
                        return parse(iter).exp();
                    }
                    b'l' => {
                        iter.next();
                        return parse(iter).ln();
                    }
                    _ => continue,
                }
            }
            unreachable!()
        }

        Ok(parse(&mut s.as_bytes().into_iter()))
    }
}

impl Display for Expr {
    fn fmt(&self, f: &mut Formatter) -> Result<(), Error> {
        match self {
            Expr::Var => write!(f, "x"),
            Expr::Num(n) => write!(f, "{}", n),
            Expr::Add(a, b) => write!(f, "(+ {} {})", a, b),
            Expr::Sub(a, b) => write!(f, "(- {} {})", a, b),
            Expr::Mul(a, b) => write!(f, "(* {} {})", a, b),
            Expr::Div(a, b) => write!(f, "(/ {} {})", a, b),
            Expr::Pow(a, b) => write!(f, "(^ {} {})", a, b),
            Expr::Cos(a) => write!(f, "(cos {})", a),
            Expr::Sin(a) => write!(f, "(sin {})", a),
            Expr::Tan(a) => write!(f, "(tan {})", a),
            Expr::Exp(a) => write!(f, "(exp {})", a),
            Expr::Ln(a) => write!(f, "(ln {})", a),
        }
    }
}

impl ops::Add for Expr {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        match (self, rhs) {
            (Expr::Num(a), Expr::Num(b)) => Expr::Num(a + b),
            (a, b) if a.eq_f64(0.) => b,
            (a, b) if b.eq_f64(0.) => a,
            (a, b) => Expr::Add(Box::new(a), Box::new(b)),
        }
    }
}

impl ops::Sub for Expr {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self::Output {
        match (self, rhs) {
            (Expr::Num(a), Expr::Num(b)) => Expr::Num(a - b),
            (a, b) if b.eq_f64(0.) => a,
            (a, b) => Expr::Sub(Box::new(a), Box::new(b)),
        }
    }
}

impl ops::Mul for Expr {
    type Output = Self;

    fn mul(self, rhs: Self) -> Self::Output {
        match (self, rhs) {
            (Expr::Num(a), Expr::Num(b)) => Expr::Num(a * b),
            (a, b) if a.eq_f64(0.) || b.eq_f64(1.) => a,
            (a, b) if a.eq_f64(1.) || b.eq_f64(0.) => b,
            (a, b) => Expr::Mul(Box::new(a), Box::new(b)),
        }
    }
}

impl ops::Div for Expr {
    type Output = Self;

    fn div(self, rhs: Self) -> Self::Output {
        match (self, rhs) {
            (Expr::Num(a), Expr::Num(b)) => Expr::Num(a / b),
            (a, b) if a.eq_f64(0.) || b.eq_f64(1.) => a,
            (a, b) => Expr::Div(Box::new(a), Box::new(b)),
        }
    }
}

impl ops::Neg for Expr {
    type Output = Self;

    fn neg(self) -> Self::Output {
        Expr::Mul(Box::new(Expr::Num(-1.)), Box::new(self))
    }
}

impl Expr {
    fn pow(self, rhs: Self) -> Self {
        match (self, rhs) {
            (Expr::Num(a), Expr::Num(b)) => Expr::Num(a.powf(b)),
            (_, b) if b.eq_f64(0.) => Expr::Num(1.),
            (a, b) if a.eq_f64(1.) || b.eq_f64(1.) => a,
            (a, b) => Expr::Pow(Box::new(a), Box::new(b)),
        }
    }

    fn powf(self, rhs: f64) -> Self {
        self.pow(Expr::Num(rhs))
    }

    fn cos(self) -> Self {
        Expr::Cos(Box::new(self))
    }

    fn sin(self) -> Self {
        Expr::Sin(Box::new(self))
    }

    fn tan(self) -> Self {
        Expr::Tan(Box::new(self))
    }

    fn exp(self) -> Self {
        Expr::Exp(Box::new(self))
    }

    fn ln(self) -> Self {
        Expr::Ln(Box::new(self))
    }

    fn eq_f64(&self, rhs: f64) -> bool {
        match self {
            Expr::Num(n) => (n - rhs).abs() < f64::EPSILON,
            _ => false,
        }
    }

    fn diff(&self) -> Self {
        match self {
            Expr::Var => Expr::Num(1.),
            Expr::Num(_) => Expr::Num(0.),
            Expr::Add(a, b) => a.diff() + b.diff(),
            Expr::Sub(a, b) => a.diff() - b.diff(),
            Expr::Mul(a, b) => a.diff() * *b.clone() + *a.clone() * b.diff(),
            Expr::Div(a, b) => (a.diff() * *b.clone() - *a.clone() * b.diff()) / b.clone().powf(2.),
            Expr::Pow(a, b) => a.diff() * (*b.clone() * a.clone().pow(*b.clone() - Expr::Num(1.))),
            Expr::Cos(a) => a.diff() * -a.clone().sin(),
            Expr::Sin(a) => a.diff() * a.clone().cos(),
            Expr::Tan(a) => a.diff() * (Expr::Num(1.) + a.clone().tan().powf(2.)),
            Expr::Exp(a) => a.diff() * a.clone().exp(),
            Expr::Ln(a) => a.diff() * (Expr::Num(1.) / *a.clone()),
        }
    }
}

fn diff(expr_str: &str) -> String {
    Expr::from_str(expr_str).unwrap().diff().to_string()
}
