import java.math.BigInteger;

public class Fibonacci {
    static BigInteger[] mul(BigInteger[] a, BigInteger[] b) {
        return new BigInteger[]{
                a[0].multiply(b[0]).add(a[1].multiply(b[2])),
                a[0].multiply(b[1]).add(a[1].multiply(b[3])),
                a[2].multiply(b[0]).add(a[3].multiply(b[2])),
                a[2].multiply(b[1]).add(a[3].multiply(b[3])),
        };
    }

    static BigInteger[] pow(BigInteger[] a, BigInteger n) {
        if (n.equals(BigInteger.ZERO)) {
            return new BigInteger[]{
                    BigInteger.ONE,
                    BigInteger.ZERO,
                    BigInteger.ZERO,
                    BigInteger.ONE,
            };
        } else {
            var t = pow(a, n.divide(BigInteger.TWO));
            if (n.mod(BigInteger.TWO).equals(BigInteger.ZERO))
                return mul(t, t);
            else
                return mul(mul(t, t), a);
        }
    }

    public static BigInteger fib(BigInteger n) {
        return pow(new BigInteger[]{
                BigInteger.ZERO,
                BigInteger.ONE,
                BigInteger.ONE,
                n.compareTo(BigInteger.ZERO) < 0
                        ? BigInteger.ONE.negate()
                        : BigInteger.ONE,
        }, n)[1];
    }
}
