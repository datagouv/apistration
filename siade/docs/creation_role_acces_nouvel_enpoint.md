# Création d'un rôle d'accès à un nouvel endpoint

Lors de l'ajout d'une nouvelle API il faut (quasiment à chque fois) ajouter un
nouveau rôle d'accès à ladie ressource.

1.Dans SIADE, créer une nouvelle policy Pundit avec le tag associé ; le tag
    est passé à la méthode `authorize` dans le controller `authorize :new_scope` ;

2.Créer le nouveau rôle dans les API Admin : se connecter au
    [dashboard](https://dashboard.entreprise.api.gouv.fr/login) et créer le rôle
    (depuis le menu adéquat sur la gauche).
    Le "code" doit être indentique au tag Pundit utilisé dans SIADE ;

3.Communiquer le code/tag à DataPass afin qu'ils mettent le formulaire de
    demande d'accès à jour
