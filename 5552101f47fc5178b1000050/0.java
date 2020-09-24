public class DigPow {
    public static long digPow(int n, int p) {
        var buffer = new int[21];
        var ptr = 21;
        var m = n;
        while (m > 0) {
            buffer[--ptr] = m % 10;
            m /= 10;
        }

        var sum = 0;
        while (ptr < 21) {
            sum += Math.pow(buffer[ptr++], p++);
        }

        if (sum % n == 0)
            return sum / n;
        else
            return -1;
    }
}
