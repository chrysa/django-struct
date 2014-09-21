from django.conf import settings

from datetime import datetime


def t_print(val):
    if settings.DEBUG:
        file = open('trace', 'a+')
        file.write('[' + str(datetime.now()) + ']' + str(val) + '\n')
        file.close()
