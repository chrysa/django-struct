from django.shortcuts import render


def extend_admin(request, template, dict_vars):
    return render(request, 'admin/' + template + '.html', dict_vars)


def extend_error(request, template, dict_vars):
    return render(request, 'errors/' + template + '.html', dict_vars)


def extend_front(request, template, dict_vars):
    return render(request, 'front/' + template + '.html', dict_vars)
