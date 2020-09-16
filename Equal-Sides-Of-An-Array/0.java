public class Kata {
    public static int findEvenIndex(int[] arr) {
        int lsum = 0, rsum = 0;
        for (int num : arr) rsum += num;
        for (int i = 0; i < arr.length; ++i) {
            rsum -= arr[i];
            if (lsum == rsum) return i;
            lsum += arr[i];
        }
        return -1;
    }
}
