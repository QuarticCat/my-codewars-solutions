import re
import sys

print('-'.join(re.findall(r'[a-zA-z]+', sys.argv[1])))
