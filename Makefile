APP = django_struct
SETTINGS = $(APP)/settings.py

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
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'module' 'module *nom du/des module/modules*'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'remove' 'remove *nom du/des module/modules*'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'migrate' 'migrate'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'syncdb' 'syncdb'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'validate' 'validate'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'static' 'static'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'translate' 'translate'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'test' 'test'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'install' 'install'
	printf '$(ORANGE)[usage]$(WHITE)%s\t\t=>\t\t%s\n' 'launchserv' 'launchserv'

module: 
	printf '$(BLUE)création du/des module(s) $(CYAN)$(filter-out $@,$(MAKECMDGOALS)$(WHITE)\n'
	$(foreach mod, $(filter-out $@,$(MAKECMDGOALS)), python manage.py startapp $(mod) && mkdir $(mod)/static $(mod)/static/images $(mod)/templates $(mod)/templates/admin $(mod)/templates/front && touch $(mod)/urls.py;)
	$(foreach mod, $(filter-out $@,$(MAKECMDGOALS)), grep 'APPS_PERSO = \(.*\)' $(SETTINGS) >> tmp && sed -i 's/APPS_PERSO = \(.*\)/\1/g' tmp >> tmp && sed 's/[()]//g'  tmp >> tmp2 && echo \'$(mod)\', >> tmp2 && cat tmp2 | tr "\n" " " > tmp3 && sed -i "s/APPS_PERSO = \(.*\)/APPS_PERSO = \(`cat tmp3`\)/g"  $(SETTINGS) && rm tmp tmp2 tmp3)
	
remove:
	printf '$(BLUE)suppression du/des module(s) $(CYAN)$(filter-out $@,$(MAKECMDGOALS)$(WHITE)\n' 
	$(foreach mod, $(filter-out $@,$(MAKECMDGOALS)), rm -rf $(mod))
	$(foreach mod, $(filter-out $@,$(MAKECMDGOALS)), sed -i "s/'$(mod)',//" $(SETTINGS))

migrate:
	printf '$(BLUE)migration de la base de données$(WHITE)\n'
	python manage.py makemigrations
	python manage.py migrate

syncdb:
	printf '$(BLUE)syncronisation de la base de données$(WHITE)\n'
	python manage.py syncdb

validate:
	printf '$(BLUE)validation de la base de données$(WHITE)\n' 
	python manage.py validate

static:
	printf '$(BLUE)suppression des anciens fichiers statics$(WHITE)\n' 
	rm -rf statics
	printf '$(BLUE)collect des nouveax fichiers statics$(WHITE)\n' 
	python manage.py collectstatic

translate:
	printf '$(BLUE)récupération des fichers de traduction$(WHITE)\n' 
	python manage.py makemessages --all 
	printf '$(BLUE)compilation des fichiers de traduction$(WHITE)\n' 
	python manage.py compilemessages

test:
	printf '$(BLUE)lancement des tests unitaires$(WHITE)\n' 
	python manage.py test
	
install:
	printf '$(BLUE)installation du fichier requirements.txt$(WHITE)\n'
	pip install -r requirements.txt

launchserv: install static translate migrate syncdb validate test
	clear
	printf '$(BLUE)lancement du serveur$(WHITE)\n' 
	python manage.py runserver --verbosity=3 0.0.0.0:8000



