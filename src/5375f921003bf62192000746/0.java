import java.util.regex.Pattern;

public class Abbreviator {
    public String abbreviate(String string) {
        return Pattern.compile("[a-zA-Z]{4,}").matcher(string).replaceAll(m -> {
            var s = m.group();
            var l = s.length();
            return s.charAt(0) + Integer.toString(l - 2) + s.charAt(l - 1);
        });
    }
}
