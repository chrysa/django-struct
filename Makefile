APP = django_struct
SETTINGS = $(APP)/settings.py

COUNT_ARG = $(words $(filter-out $@,$(MAKECMDGOALS)))
PRELAST_ARG = $(shell echo $(COUNT_ARG)-1 | bc)
PREPRELAST_ARG = $(shell echo $(PRELAST_ARG)-1 | bc)

BLUE = \033[1;34m
CYAN = \033[1;36m
GREEN = \033[32m
GREENSUCCESS = \033[1;32m
ORANGE = \033[1;31m
RED = \033[31m
WHITE = \033[00m
YELLOW = \033[33m

.SILENT:

help:
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'module' 		'module [nom du/des module/modules]'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'remove' 		'remove [nom du/des module/modules]'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'migrate' 		'migrate'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'validate' 		'validate'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'static' 		'static'
	printf '$(ORANGE)[usage]$(WHITE)%s\t=>\t%s\n' 	'translate' 	'translate [code langue a traiter]'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'test' 			'test'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'install' 		'install'
	printf '$(ORANGE)[usage]$(WHITE)%s\t=>\t%s\n' 	'uninstall' 	'uninstall'
	printf '$(ORANGE)[usage]$(WHITE)%s\t=>\t%s\n' 	'reinstall' 	'reinstall'
	printf '$(ORANGE)[usage]$(WHITE)%s\t=>\t%s\n' 	'launchserv' 	'launchserv [numéro du port]'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'clean' 		'clean'
	printf '$(ORANGE)[usage]$(WHITE)%s\t=>\t%s\n' 	'configure' 	"configure [nom de l'application]"
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t%s\n' 'push' 			'push "[message du commit]" [remote] [branch]'

module: 
	printf '$(BLUE)création du/des module(s) $(CYAN)$(filter-out $@,$(MAKECMDGOALS))$(WHITE)\n'
	$(foreach mod, $(filter-out $@,$(MAKECMDGOALS)), python manage.py startapp $(mod)) && mkdir $(mod)/static $(mod)/static/images $(mod)/templates $(mod)/templates/admin $(mod)/templates/errors $(mod)/templates/front && touch $(mod)/urls.py;)
	$(foreach mod, $(filter-out $@,$(MAKECMDGOALS)), grep 'APPS_PERSO = \(.*\)' $(SETTINGS) >> tmp && sed -i 's/APPS_PERSO = \(.*\)/\1/g' tmp >> tmp && sed 's/[()]//g'  tmp >> tmp2 && echo \'$(mod)\', >> tmp2 && cat tmp2 | tr "\n" " " > tmp3 && sed -i "s/APPS_PERSO = \(.*\)/APPS_PERSO = \(`cat tmp3`\)/g"  $(SETTINGS) && rm tmp tmp2 tmp3)
	
remove:
	printf '$(BLUE)suppression du/des module(s) $(CYAN)$(filter-out $@,$(MAKECMDGOALS)$(WHITE)\n' 
	$(foreach mod, $(filter-out $@,$(MAKECMDGOALS)), rm -rf $(mod))
	$(foreach mod, $(filter-out $@,$(MAKECMDGOALS)), sed -i "s/'$(mod)',//" $(SETTINGS))

migrate:
	printf '$(BLUE)migration de la base de données$(WHITE)\n'
	python manage.py makemigrations
	python manage.py migrate

validate:
	printf '$(BLUE)validation de la base de données$(WHITE)\n' 
	python manage.py validate

static:
	printf '$(BLUE)suppression des anciens fichiers statics$(WHITE)\n' 
	rm -rf statics
	printf '$(BLUE)collect des nouveax fichiers statics$(WHITE)\n' 
	python manage.py collectstatic

translate:
	printf '$(BLUE)récupération des fichers de traduction $(CYAN)$(filter-out $@,$(MAKECMDGOALS))$(WHITE)\n' 
	$(foreach lang, $(filter-out $@,$(MAKECMDGOALS)), python manage.py makemessages --verbosity=3 -l $(lang);)
	printf '$(BLUE)compilation des fichiers de traduction$(WHITE)\n' 
	python manage.py compilemessages

test:
	printf '$(BLUE)lancement des tests unitaires$(WHITE)\n' 
	python manage.py test
	
install:
	printf '$(BLUE)installation du fichier requirements.txt$(WHITE)\n'
	pip install -r requirements.txt
	
uninstall:
	printf '$(BLUE)desinstallation du fichier requirements.txt$(WHITE)\n'
	pip uninstall -r requirements.txt

reinstall: uninstall install clean

clean:
	printf '$(BLUE)suppression des fichiers .pyc$(WHITE)\n'
	find . -name '*.pyc' -exec rm -rf {} \; 
	printf '$(BLUE)suppression des fichiers ~$(WHITE)\n'
	find . -name '*~' -exec rm -rf {} \; 
	printf '$(BLUE)suppression des fichiers .DS_STORE$(WHITE)\n'
	find . -name '*.DS_STORE' -exec rm -rf {} \; 
	printf '$(BLUE)suppression de la trace de debug$(WHITE)\n'
	rm -rf trace 

launchserv: clean install static migrate validate test
	printf '$(BLUE)compilation des fichiers de traduction$(WHITE)\n' 
	python manage.py compilemessages
	printf '$(BLUE)lancement du serveur$(WHITE)\n' 
	python manage.py runserver --verbosity=3 0.0.0.0:$(filter-out $@,$(MAKECMDGOALS))

configure: 
	printf '$(BLUE)configuration du projet pour le nom $(filter-out $@,$(MAKECMDGOALS))$(WHITE)\n'
	find . -name "*.py" -exec sed -i 's/django_struct/$(filter-out $@,$(MAKECMDGOALS))/g' {}
	mv django_struct $(filter-out $@,$(MAKECMDGOALS)
	launchserv

push: clean static
	printf '$(BLUE)compilation des fichiers de traduction$(WHITE)\n' 
	python manage.py compilemessages
	printf '$(BLUE)commit avec le message $(filter-out $@,$(MAKECMDGOALS))$(WHITE)\n'
	git add .
	git commit -a -m \"$(wordlist 1,$(PREPRELAST_ARG),$(filter-out $@,$(MAKECMDGOALS)))\"
	printf '$(BLUE)push$(WHITE)\n'
	git push $(word $(PRELAST_ARG), $(filter-out $@,$(MAKECMDGOALS))) $(lastword $(filter-out $@,$(MAKECMDGOALS)))
