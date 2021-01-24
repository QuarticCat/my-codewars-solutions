public class DRoot {
    public static int digital_root(int n) {
        int sum = 0;
        int remainder = n;
        while (remainder > 0) {
            sum += remainder % 10;
            remainder /= 10;
        }
        if (sum == n)
            return n;
        else
            return digital_root(sum);
    }
}
