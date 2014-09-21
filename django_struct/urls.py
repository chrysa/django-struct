from django.conf import settings
from django.conf.urls import patterns, include, url
from django.contrib import admin

if not settings.MAINTENANCE:
    urlpatterns = patterns('',
                           url(r'^admin/', include(admin.site.urls)),
                           url(r'^api-auth/',
                               include('rest_framework.urls', namespace='rest_framework'))
                           )
    if settings.DEBUG:
        import debug_toolbar
        urlpatterns += patterns('',
                                url(r'^__debug__/',
                                    include(debug_toolbar.urls)),
                                )
else:
    urlpatterns = patterns('',
                           url(r'^$', "core.views.maintenance"),
                           )
