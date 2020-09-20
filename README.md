# My Codewars Solutions

\>>> [[My Codewars Profile]](https://www.codewars.com/users/QuarticCat) <<<

Here are my codewars solutions. They are organized by question names, languages, and orders of completion.

Since not any character used in Codewars questions can be used in path, I write a script. Usage:

```console
$ python3 convert.py [question-name]
[directory-name]
```

For example:

```console
$ python3 convert.py "Simple Encryption #1 - Alternating Split"
Simple-Encryption-1-Alternating-Split
```

## TODO

Sometimes my current convert method may cause conflict. For example:

- "A+B=B+A? Prove it!" -> "A-B-B-A-Prove-it"
- "A\*B=B\*A? Prove it!" -> "A-B-B-A-Prove-it"

I'm looking for a less conflicting and still human readable mapping way.
