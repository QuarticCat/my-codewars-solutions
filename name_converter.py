import sys
from urllib.parse import quote_plus, unquote_plus

if len(sys.argv) != 3:
    print('Too many or too few arguments')
elif sys.argv[1] == 'encode':
    print(quote_plus(sys.argv[2]))
elif sys.argv[1] == 'decode':
    print(unquote_plus(sys.argv[2]))
else:
    print('Unknown argument: ', sys.argv[1])
