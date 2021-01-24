public class Kata {
    public static String encrypt(final String text, final int n) {
        if (n <= 0) return text;
        var buffer = new char[text.length()];
        var offset = text.length() / 2;
        for (int i = 0; i < text.length(); ++i) {
            if (i % 2 == 1) buffer[i / 2] = text.charAt(i);
            else buffer[i / 2 + offset] = text.charAt(i);
        }
        return encrypt(new String(buffer), n - 1);
    }

    public static String decrypt(final String text, final int n) {
        if (n <= 0) return text;
        var buffer = new char[text.length()];
        var offset = text.length() / 2;
        for (int i = 0; i < text.length(); ++i) {
            if (i % 2 == 1) buffer[i] = text.charAt(i / 2);
            else buffer[i] = text.charAt(i / 2 + offset);
        }
        return decrypt(new String(buffer), n - 1);
    }
}
