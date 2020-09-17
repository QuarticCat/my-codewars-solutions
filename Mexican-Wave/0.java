import java.util.ArrayList;

public class MexicanWave {
    public static String[] wave(String str) {
        var ret = new ArrayList<String>();
        for (int i = 0; i < str.length(); ++i) {
            if (!Character.isLetter(str.charAt(i))) continue;
            var temp = new StringBuilder(str);
            temp.setCharAt(i, Character.toUpperCase(str.charAt(i)));
            ret.add(temp.toString());
        }
        System.out.println(ret);
        return ret.toArray(new String[0]);
    }
}
