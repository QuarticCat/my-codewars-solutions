import re
import sys

print(re.sub(r'[^a-zA-Z]+', '-', sys.argv[1]))
