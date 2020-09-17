import re
import sys

print('-'.join(re.findall(r'[a-zA-z0-9]+', sys.argv[1])))
