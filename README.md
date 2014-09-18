# django-struct
------------
django-struct is a basic development architecture based on the django framework designed to organize the code better and make life easier for the developer

## installation 
------------
### first step
`git clone https://github.com/chrysa/django-struct.git`
### second step
launch
`make install *name of your application*`
### step three
change in makefile APP value with applicaton's name
### step four
have fun

## makefile rules
-------------
    help => display how use makefile rules (actually in french)
    module => create new modules in parameters
    remove => remove list of modules in parameters
    migrate => migrate database after changing
    validate => valide databases
    static => collect alls statics files for the app
    translate => make trabslation files of the apps
    test => launch all the unit tests
    install => install requirements.txt
    uninstall => uninstall requirements.txt
    reinstall => reinstall requirements.txt
    launchserv => launchserver in level 3 of verbosity had done after install static translate migrate syncdb validate test
    configure => configure django-struct with name in paramter except for APP varible in makefile

## banchs
-------------
    master -> stable
    work -> in work
