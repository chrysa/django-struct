from django.shortcuts import render


def extend_admin(request, template, dict_vars):
    return render(request, 'admin/' + template, dict_vars)

def extend_front(request, template, dict_vars):
    return render(request, 'front/' + template, dict_vars)
