# Modifier le contenu du site — guide pas à pas pour les PO

Ce guide vous rend **autonome** pour faire de **petites modifications de contenu**
un peu partout sur le site, puis les proposer à l'équipe, **sans rien connaître
à la technique**. Par exemple :

- la documentation d'un endpoint (« fiche métier » : périmètre, FAQ, description,
  mots-clés…) ;
- une question/réponse de FAQ ;
- une correction de texte, une reformulation, un lien à mettre à jour ;
- du wording ici ou là (libellés, intitulés, messages).

C'est l'outil idéal pour les retouches fréquentes et localisées : vous décrivez
le changement, l'agent l'applique, vous l'envoyez.

> Ce guide fonctionne sur **macOS** et sur **Windows**. Le **workflow est
> identique** sur les deux ; seules quelques étapes d'**installation** diffèrent.
> Quand c'est le cas, suivez le bloc marqué **🍎 macOS** ou **🪟 Windows** selon
> votre machine. (Sous Linux, demandez à l'équipe : c'est très proche de macOS.)
>
> **🪟 Windows :** l'agent tourne dans **WSL2** (un Linux intégré à Windows) via
> `agent-vm-windows`. Prérequis : **Windows 11**, droits administrateur, et la
> virtualisation activée (cas par défaut de la plupart des machines).

> # 🚨 À LIRE AVANT TOUTE CHOSE — sécurité & données
>
> Ce que vous tapez à l'agent et ce que vous écrivez dans une fiche **peut finir
> publié sur GitHub** et **envoyé à un service tiers** (l'agent IA). Considérez
> que **rien n'est secret**.
>
> **❌ NE JAMAIS écrire — ni dans un message à l'agent, ni dans une fiche, ni
> dans un commit :**
>
> - une **clé d'API**, un **jeton (token)**, un **mot de passe**, un secret,
>   une URL contenant un identifiant ;
> - des **données personnelles** : nom, prénom, email, téléphone, adresse,
>   **SIREN/SIRET d'une vraie entreprise nommée**, NIR/numéro de sécurité
>   sociale, etc. (RGPD) ;
> - tout extrait de données réelles renvoyées par une API.
>
> **✅ À FAIRE :**
>
> - utilisez uniquement des **exemples fictifs** ou des valeurs déjà publiques
>   (ex. SIRET de démonstration de la documentation) ;
> - **avant** d'envoyer un message à l'agent ou d'enregistrer une modification,
>   **relisez-vous** : aucun secret, aucune donnée personnelle ?
> - dans le doute, **ne l'envoyez pas** et demandez à l'équipe.
>
> Une clé ou un secret exposé, même supprimé ensuite, est considéré comme
> **compromis** : prévenez immédiatement l'équipe pour le faire révoquer.

**Quelques exemples de demandes que vous pourrez formuler :**

> Ajoute à la FAQ de l'API TVA (DGFIP) la question :
> « Une entreprise peut-elle avoir plusieurs numéros de TVA intracommunautaire ? »
> Réponse : « Une entreprise assujettie à la TVA peut posséder un numéro de TVA
> pour chacun de ses codes d'activité (NAF/APE). Les numéros de TVA affichés sur
> l'Annuaire des Entreprises sont les numéros actifs à la date d'extraction des
> données. »

> Sur la fiche INSEE établissements, reformule le périmètre pour qu'il soit plus
> clair, et corrige la faute « établissment ».

> Mets à jour le lien vers le décret dans la fiche CMA France RNM, il est cassé.

### L'agent répond aussi à vos questions

Vous n'êtes pas obligé de savoir où se trouvent les choses, ni de recopier un
exemple de ce guide. L'agent est **conversationnel** : interrogez-le directement
pour explorer, comprendre, puis décider — sans rien connaître à la structure du
projet. Par exemple :

> Montre-moi la FAQ actuelle de l'API TVA (DGFIP).

> Dans quel fichier se trouve la fiche INSEE établissements ?

> Quelles fiches parlent de TVA ?

> Explique-moi ce que tu vas changer avant de le faire.

> Cette modification a-t-elle un impact ailleurs sur le site ?

---

## 1. Vue d'ensemble : comment ça marche

Vous allez travailler à **deux endroits**, et c'est normal :

| Endroit | À quoi ça sert | Qui y travaille |
| --- | --- | --- |
| **Votre ordinateur** (« l'hôte ») | Lancer le site pour voir le rendu, et envoyer vos modifications à GitHub | Vous |
| **La VM** (`agent-vm`) | Faire écrire les modifications par l'agent (Claude ou Codex) | L'agent, à qui vous parlez |

La « VM » est une machine Linux isolée : **Lima** sur macOS, **WSL2** sur
Windows. Dans les deux cas vous l'utilisez avec les mêmes commandes `agent-vm`.

Le dossier du projet est **partagé** entre les deux : quand l'agent modifie un
fichier dans la VM, le changement apparaît immédiatement sur votre ordinateur.

**Le déroulé type d'une modification :**

1. Vous lancez le site en local (Docker) pour voir l'état actuel.
2. Vous lancez l'agent (`agent-vm claude`) et vous lui demandez la modification
   en langage courant (« ajoute une FAQ à l'API TVA… », « corrige ce texte… »).
3. L'agent modifie le bon fichier.
4. Vous rafraîchissez le site pour vérifier le rendu.
5. Vous **enregistrez et envoyez** la modification depuis votre ordinateur
   (commit + push + pull request).
6. L'équipe relit et publie.

> ⚠️ Les étapes 1 à 4 sont réversibles et sans risque. L'étape 5 publie votre
> travail sur GitHub : prenez le temps de bien vérifier avant.

> 💡 Lancer le site en local (étapes 1 et 4) est **optionnel**. Pour une
> modification simple (corriger un texte, ajouter une FAQ, ajuster un
> périmètre…), c'est souvent inutile et plus lourd : vous pouvez relire la
> modification directement (étape 5) et laisser l'équipe vérifier le rendu à la
> relecture. Lancez le site surtout en cas de doute sur le rendu (mise en forme,
> liens, tableaux…).

**Chaque étape d'installation ci-dessous suit le même schéma : on vérifie
d'abord si c'est déjà installé, et on n'installe que si nécessaire.**

### Quelques mots de vocabulaire

Quelques notions qui reviennent dans ce guide, expliquées simplement :

- **Un agent (Claude ou Codex)** — un assistant intelligent à qui vous parlez en
  français, comme à un collègue. Vous lui décrivez ce que vous voulez (« ajoute
  une FAQ à cette fiche ») et il modifie lui-même les bons fichiers. Vous n'avez
  pas à savoir lesquels ni comment. Deux agents sont disponibles, au choix :
  **Claude** (`agent-vm claude`) ou **Codex** (`agent-vm codex`) ; ils
  s'utilisent de la même façon.

- **Un skill** — une « fiche de procédure » que l'agent connaît déjà pour le
  projet. Le dépôt en contient pour, par exemple, savoir exactement comment et où
  modifier une fiche métier. **Vous n'avez rien à faire** : l'agent choisit et
  applique le bon skill tout seul. C'est ce qui le rend fiable sur ce projet.

- **Un MCP** — une « prise de connexion » qui branche l'agent sur un outil
  extérieur. Ici, le MCP Linear permet à l'agent de **lire vos tickets Linear**
  pour travailler à partir d'une demande déjà écrite (étape 9).

- **Le dépôt (repo)** — le dossier qui contient tout le projet, y compris les
  fiches métier. Vous en avez une copie sur votre ordinateur.

- **Une branche** — un brouillon séparé de la version officielle, où vous faites
  votre modification tranquillement avant de la proposer.

- **Un commit** — une modification enregistrée, avec un message qui explique
  pourquoi. C'est une étape, datée et signée.

- **Une pull request (PR)** — la demande de publication de votre modification.
  L'équipe la relit puis la valide. C'est l'aboutissement de votre travail.

---

## 2. Le terminal : votre outil de base

Quelques commandes de ce guide se tapent dans un **terminal**.

**🍎 macOS** — l'application **Terminal** :
- Ouvrez-la : `Cmd + Espace`, tapez `Terminal`, `Entrée`.
- Coller : `Cmd + V`.
- Si une commande demande votre mot de passe Mac, tapez-le (rien ne s'affiche,
  c'est normal) puis `Entrée`.

**🪟 Windows** — l'application **Terminal** (ou **PowerShell**) :
- Ouvrez-la : touche `Windows`, tapez `Terminal`, `Entrée`.
- Coller : `Ctrl + V` (ou clic droit).
- Lancez-la **en administrateur** uniquement quand l'étape le précise
  (clic droit ▸ *Exécuter en tant qu'administrateur*).

Généralités (les deux) : une commande = vous tapez (ou collez) le texte, puis
`Entrée`. Placez-vous dans le dossier du projet au début de chaque session
(voir l'étape 6 pour le récupérer) :

```sh
# 🍎 macOS
cd ~/work/apistration

# 🪟 Windows (PowerShell)
cd ~\work\apistration
```

---

## 3. Le gestionnaire d'installation

Un « gestionnaire de paquets » installe les outils en une commande.

### 🍎 macOS — Homebrew

**Vérifier :**

```sh
brew --version
```

- Version affichée (ex. `Homebrew 4.x`) → passez à l'étape 4.
- « command not found » → installez-le :

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

À la fin, l'installeur affiche **deux commandes à copier-coller** (commençant
par `echo ... >> ~/.zprofile` et `eval ...`) pour activer `brew`. Exécutez-les,
fermez puis rouvrez le Terminal, et revérifiez avec `brew --version`.

### 🪟 Windows — winget

`winget` est **déjà installé** sur Windows 11.

**Vérifier :**

```powershell
winget --version
```

- Version affichée → passez à l'étape 4.
- Erreur → ouvrez le **Microsoft Store**, cherchez **« App Installer »** et
  mettez-le à jour (il fournit `winget`).

---

## 4. Git et votre identité

Git est l'outil qui enregistre vos modifications.

**Vérifier :**

```sh
git --version
```

- Version affichée → bon.
- Sinon, installez-le :
  - **🍎 macOS** : `brew install git` (ou tapez `git`, macOS propose d'installer
    les « outils de développement en ligne de commande » : acceptez).
  - **🪟 Windows** : `winget install --id Git.Git -e`, puis **fermez et rouvrez**
    le terminal.

**Configurer votre identité** (une seule fois). Utilisez votre **vrai nom** et
l'**email de votre compte GitHub** :

```sh
git config --global user.name  "Prénom Nom"
git config --global user.email "vous@exemple.gouv.fr"
git config --global pull.rebase true
git config --global init.defaultBranch main
```

Le projet exige un `Signed-off-by` sur chaque commit (voir
[`CONTRIBUTING.md`](../CONTRIBUTING.md)). Ce n'est **pas** un réglage de config :
- avec **GitHub Desktop**, vous l'ajoutez à la main dans la description du commit
  (étape 10f) ;
- au **terminal**, utilisez `git commit -s` (le `-s` ajoute la mention).

**Vérifier la configuration :**

```sh
git config --global --get user.name
git config --global --get user.email
```

---

## 5. GPG — signer ses modifications (badge « Verified »)

> 🔒 **Exigence de sécurité interne.** Chez nous, la signature GPG des commits
> est **obligatoire** — ce n'est pas optionnel. Toute modification doit être
> signée. Ne sautez pas cette étape.

GitHub affiche un badge **« Verified »** sur les modifications signées
cryptographiquement. La signature repose sur une clé GPG, qui vit **sur votre
ordinateur** (c'est pourquoi on enregistrera les modifications depuis l'hôte, pas
depuis la VM).

> Ne pas confondre : le `Signed-off-by` de l'étape 4 (une simple mention texte,
> obligatoire) et la **signature GPG** (une preuve cryptographique, ci-dessous).
> On veut les deux.

**Vérifier si GPG est installé :**

```sh
gpg --version
```

- Version affichée → passez à « Avez-vous déjà une clé ? ».
- Sinon, installez-le :
  - **🍎 macOS** : `brew install gnupg pinentry-mac`
  - **🪟 Windows** : `winget install --id GnuPG.Gpg4win -e`, puis **fermez et
    rouvrez** le terminal. (Gpg4win fournit `gpg` et la fenêtre de saisie de la
    phrase secrète, déjà configurée.)

**Avez-vous déjà une clé ?**

```sh
gpg --list-secret-keys --keyid-format=long
```

- Si une ligne `sec   ...` s'affiche avec votre email → vous avez déjà une clé,
  notez son identifiant (voir plus bas) et passez à « Connecter GPG à git ».
- Si rien ne s'affiche → créez une clé :

**Créer une clé :**

```sh
gpg --full-generate-key
```

Répondez :
- type : `ECC (sign and encrypt)` (choix par défaut) ou `RSA and RSA` → `Entrée`
- taille (si RSA) : `4096`
- validité : `0` (n'expire jamais) → `o` pour confirmer
- nom : votre **vrai nom** (identique à l'étape 4)
- email : votre **email GitHub** (identique à l'étape 4) — c'est indispensable
  pour obtenir le badge « Verified »
- une **phrase secrète** : choisissez-en une et **mémorisez-la**, elle protège
  votre clé.

**Récupérer l'identifiant de votre clé :**

```sh
gpg --list-secret-keys --keyid-format=long
```

Cherchez la ligne `sec`. L'identifiant est la suite après la barre oblique, par
exemple :

```
sec   ed25519/3AA5C34371567BD2 2026-06-25 [SC]
                ^^^^^^^^^^^^^^^^  ← ceci est votre KEY_ID
```

Dans la suite, remplacez `VOTRE_KEY_ID` par cette valeur.

**Connecter GPG à git :**

```sh
git config --global user.signingkey VOTRE_KEY_ID
git config --global commit.gpgsign true
```

Indiquez ensuite à git où est `gpg` :

```sh
# 🍎 macOS
git config --global gpg.program "$(which gpg)"

# 🪟 Windows (PowerShell)
git config --global gpg.program "C:\Program Files (x86)\GnuPG\bin\gpg.exe"
```

**🍎 macOS uniquement — permettre la saisie de la phrase secrète :**

```sh
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
echo 'export GPG_TTY=$(tty)' >> ~/.zshrc
gpgconf --kill gpg-agent
```

Fermez puis rouvrez le Terminal. (Sous **🪟 Windows**, rien à faire : Gpg4win
gère déjà la fenêtre de saisie.)

**Donner votre clé publique à GitHub :**

```sh
# 🍎 macOS
gpg --armor --export VOTRE_KEY_ID | pbcopy

# 🪟 Windows (PowerShell)
gpg --armor --export VOTRE_KEY_ID | clip
```

Cela copie la clé dans le presse-papier. Ensuite :
1. Ouvrez <https://github.com/settings/gpg/new>
2. Collez (`Cmd + V` / `Ctrl + V`) dans le champ, puis **Add GPG key**.

**Vérifier que la signature fonctionne :**

```sh
echo "test" | gpg --clearsign
```

- Une fenêtre demande votre phrase secrète, puis un bloc
  `-----BEGIN PGP SIGNED MESSAGE-----` s'affiche → tout est bon.
- Une erreur → revoyez les étapes ci-dessus ou demandez de l'aide à l'équipe.

**Sauvegarder votre clé (obligatoire).**

Votre clé privée est **irremplaçable** : si vous perdez votre ordinateur sans
sauvegarde, vous perdez définitivement votre capacité à signer. Faites-en une
sauvegarde **dès maintenant**.

Exportez la clé privée et un certificat de révocation (qui sert à invalider la
clé si elle est un jour compromise) :

```sh
gpg --armor --export-secret-keys VOTRE_KEY_ID > ~/cle-gpg-privee.asc
gpg --armor --gen-revoke VOTRE_KEY_ID > ~/cle-gpg-revocation.asc
```

Mettez **ces deux fichiers et votre phrase secrète** dans un endroit sécurisé
**et personnel** :

- de préférence votre **gestionnaire de mots de passe personnel** (Bitwarden,
  1Password, KeePass…), en pièce jointe d'une entrée dédiée ;
- cette clé est **personnelle** : ne la mettez **jamais** dans un coffre/espace
  **partagé d'équipe**, ni dans le dépôt, un dossier partagé, un email ou une
  note non chiffrée.

Une fois la sauvegarde confirmée, **supprimez les fichiers** de votre dossier
personnel pour ne pas les laisser en clair sur le disque :

```sh
# 🍎 macOS
rm ~/cle-gpg-privee.asc ~/cle-gpg-revocation.asc

# 🪟 Windows (PowerShell)
Remove-Item ~\cle-gpg-privee.asc, ~\cle-gpg-revocation.asc
```

> En cas de perte ou de compromission de la clé, prévenez immédiatement
> l'équipe : il faudra révoquer la clé et en regénérer une.

---

## 6. GitHub Desktop : se connecter et récupérer le projet

GitHub Desktop est une **application graphique** qui remplace presque toutes les
commandes git. Dans ce guide, c'est elle qui fait : se connecter, récupérer le
projet, créer une branche, enregistrer (commit), envoyer (push) et ouvrir la
pull request. **Aucune commande git à retenir.**

**Pré-requis :** avoir un **compte GitHub** et avoir été **ajouté à
l'organisation `datagouv`** par l'équipe (demandez-leur si ce n'est pas fait).

**Vérifier si GitHub Desktop est installé :** cherchez « GitHub Desktop »
(🍎 Launchpad / 🪟 menu Démarrer).

- Présent → ouvrez-le.
- Absent → installez-le :
  - **🍎 macOS** : `brew install --cask github`
  - **🪟 Windows** : `winget install --id GitHub.GitHubDesktop -e`
  - (ou téléchargez-le sur <https://desktop.github.com/>), puis ouvrez-le.

**Se connecter :** au premier lancement, **Sign in to GitHub.com** et suivez la
connexion dans le navigateur. GitHub Desktop gère alors tout seul votre
authentification (plus besoin de mot de passe pour envoyer vos modifications).

**Vérifier votre identité de commit :** menu `GitHub Desktop ▸ Settings ▸ Git`
(🍎 `GitHub Desktop ▸ Settings` / 🪟 `File ▸ Options`).
Le **Name** et l'**Email** doivent correspondre à ce que vous avez mis à
l'étape 4 (et à l'email de votre clé GPG, étape 5). Corrigez si besoin.

**Récupérer le projet** (une seule fois) :

1. `File ▸ Clone repository…`
2. Onglet **GitHub.com**, cherchez **`datagouv/apistration`** (s'il n'apparaît
   pas, vérifiez que l'équipe vous a bien ajouté à l'organisation).
3. **Local path** : choisissez où le mettre, par exemple `~/work` → le projet
   sera dans `~/work/apistration`.
4. **Clone**.

> Ce guide utilise le chemin `~/work/apistration` pour les rares commandes au
> Terminal (site, agent) ; adaptez-le si vous avez choisi un autre dossier.

---

## 7. Lancer le site en local (optionnel)

Faire tourner le site sur votre ordinateur permet de voir vos modifications
**avant** de les envoyer.

> 💡 **Cette étape est optionnelle.** Pour une modification simple, vous pouvez
> la sauter entièrement : la relecture du texte (étape 10e) suffit, et l'équipe
> vérifie le rendu à la relecture de la pull request. Lancez le site surtout pour
> prévisualiser des rendus complexes (mise en forme, liens, tableaux). Vous
> pourrez toujours y revenir plus tard.

### 🍎 macOS — Docker Desktop sur l'hôte

**Vérifier :**

```sh
docker --version
docker info
```

- `docker --version` affiche une version **et** `docker info` ne montre pas
  d'erreur → Docker tourne, passez à « Lancer le site ».
- `command not found` → installez Docker Desktop : `brew install --cask docker`.
  Puis ouvrez **Docker Desktop** (icône baleine) et laissez-le démarrer. Une
  icône de baleine apparaît dans la barre de menus quand il est prêt.
  Re-vérifiez avec `docker info`.

**Lancer le site** (depuis la racine du projet) :

```sh
cd ~/work/apistration/site
make install   # uniquement la PREMIÈRE fois (construit l'image + la base) — peut être long
make start     # les fois suivantes
```

### 🪟 Windows — le site tourne dans la VM

Sur Windows, pas besoin d'installer Docker séparément : la VM `agent-vm`
(étape 8) contient déjà Docker. Lancez le site **depuis la VM**, une fois
l'étape 8 faite :

```powershell
cd ~\work\apistration
agent-vm shell
```

Puis, **dans la VM** :

```sh
cd site
make install   # uniquement la PREMIÈRE fois — peut être long
make start     # les fois suivantes
```

Les ports sont automatiquement redirigés vers Windows : les adresses ci-dessous
s'ouvrent dans votre navigateur Windows normalement.

### Accéder au site (les deux)

Ouvrez ensuite dans votre navigateur :

- API Entreprise : <http://entreprise.api.localtest.me:5000/>
- API Particulier : <http://particulier.api.localtest.me:5000/>

Pour vous connecter en tant qu'admin (contourne la connexion ProConnect) :

```
http://entreprise.api.localtest.me:5000/compte/dev-login?email=user@yopmail.com
```

**Après une modification de fiche**, le site peut garder l'ancienne version en
mémoire. Pour forcer le rechargement :

```sh
make stop && make start
```

**Arrêter le site** quand vous avez fini :

```sh
make stop
```

> Ces commandes `make` se lancent là où tourne le site : sur l'**hôte** en
> 🍎 macOS, **dans `agent-vm shell`** en 🪟 Windows.
>
> En cas de base de données corrompue : `make reset_database`.

---

## 8. agent-vm : l'environnement de l'agent

L'agent (Claude ou Codex) travaille dans une machine virtuelle isolée,
`agent-vm`. La configuration **du projet** est déjà fournie dans le dépôt, et le
dossier du projet y est **partagé** avec votre ordinateur. Dans la VM, l'agent ne
fait qu'**éditer des fichiers** : il n'a donc besoin ni de votre clé SSH, ni de
votre clé GPG, ni de votre identité git (vous enregistrerez et signerez vos
modifications depuis l'hôte, à l'étape 10).

Résultat : la seule configuration personnelle utile ici est l'activation du
**MCP Linear** (étape 9). Tout le reste est déjà prêt.

**Vérifier si agent-vm est installé** (les deux) :

```sh
agent-vm status
```

- Des informations sur la VM s'affichent → installé, passez à « Vérifier que la
  VM démarre ».
- `command not found` (🍎) / `agent-vm n'est pas reconnu` (🪟) → installez-le
  selon votre système ci-dessous.

### 🍎 macOS — agent-vm (Lima)

```sh
git clone https://github.com/sylvinus/agent-vm.git ~/src/agent-vm
echo "source ~/src/agent-vm/agent-vm.sh" >> ~/.zshrc
exec $SHELL
agent-vm setup --disk 30 --memory 8 --cpus 4
```

### 🪟 Windows — agent-vm-windows (WSL2)

1. Installer WSL2 (une fois), puis **redémarrer** :

   ```powershell
   wsl --install --no-distribution
   wsl --update
   ```

2. Récupérer `agent-vm-windows` et l'activer dans PowerShell :

   ```powershell
   git clone https://github.com/skelz0r/agent-vm-windows $HOME\tools\agent-vm-windows
   notepad $PROFILE
   # ajoutez cette ligne, enregistrez, fermez :
   . "$HOME\tools\agent-vm-windows\agent-vm.ps1"
   ```

3. Ouvrez un **nouveau** terminal, puis :

   ```powershell
   agent-vm setup
   ```

`agent-vm setup` installe les dépendances et crée la VM ; c'est **long la
première fois** (🍎 quelques minutes, 🪟 idem une fois WSL2 prêt). Re-vérifiez
avec `agent-vm status`.

**Vérifier que la VM démarre.** Depuis la racine du projet :

```sh
cd ~/work/apistration        # 🪟 Windows : cd ~\work\apistration
agent-vm shell
```

Une invite de commande s'ouvre **dans la VM**. Tapez `exit` pour en sortir.

Votre fichier de configuration personnelle (`~/.agent-vm/runtime.sh`, **dans la
VM**) ne sert, pour ce guide, qu'à activer le MCP Linear : sa création est
décrite à l'étape suivante.

---

## 9. MCP Linear : donner accès aux tickets à l'agent (optionnel)

Le « MCP Linear » permet à l'agent de **lire vos tickets Linear**, pour
travailler à partir d'une demande déjà décrite dans un ticket. **C'est
optionnel** : si vous décrivez vos modifications directement à l'agent, vous
pouvez sauter cette étape.

**Pré-requis :** avoir un **compte Linear** sur l'espace de l'équipe.

On utilise le **serveur Linear distant** (hébergé par Linear) : rien à
installer, l'authentification se fait dans votre navigateur.

**Activer Linear (une seule fois).** Le bloc ci-dessous configure Linear
**globalement** pour Claude **et** Codex, à chaque démarrage de la VM. Pas de
fichier à éditer à la main. Où le coller :

- **🍎 macOS** : directement dans le **Terminal** de l'hôte.
- **🪟 Windows** : le fichier vit **dans la VM**. Ouvrez d'abord la VM, puis
  collez le bloc dedans :

  ```powershell
  cd ~\work\apistration
  agent-vm shell
  ```

```sh
mkdir -p ~/.agent-vm
touch ~/.agent-vm/runtime.sh && chmod +x ~/.agent-vm/runtime.sh
grep -q 'mcp.linear.app' ~/.agent-vm/runtime.sh || cat >> ~/.agent-vm/runtime.sh <<'EOF'

# MCP Linear (serveur distant) — pour Claude et Codex
claude mcp add --scope user --transport sse linear https://mcp.linear.app/sse 2>/dev/null || true
mkdir -p ~/.codex
grep -q 'mcp_servers.linear' ~/.codex/config.toml 2>/dev/null || cat >> ~/.codex/config.toml <<'TOML'

[mcp_servers.linear]
command = "npx"
args = ["-y", "mcp-remote", "https://mcp.linear.app/sse"]
TOML
EOF
```

**Se connecter à Linear (une seule fois).** Lancez l'agent depuis le projet :

```sh
cd ~/work/apistration
agent-vm claude      # ou : agent-vm codex
```

- **Claude** : tapez `/mcp`, sélectionnez `linear`, puis **Authenticate**.
- **Codex** : l'authentification se déclenche au premier accès à Linear.

Une **URL** s'affiche : copiez-la dans le navigateur de votre ordinateur,
connectez-vous à Linear et autorisez l'accès.

**Vérifier :** demandez à l'agent « liste mes tickets Linear ». (Avec Claude,
`/mcp` doit afficher `linear` comme **connected**.)

---

## 10. Le workflow quotidien : modifier une fiche de A à Z

Tout est installé. Voici le déroulé complet d'une modification.

### a. Préparer une branche (dans GitHub Desktop)

Une **branche** est un espace de travail séparé pour votre modification, sans
toucher à la version officielle. Dans **GitHub Desktop** :

1. **Current branch** (en haut) → sélectionnez **`develop`**.
2. Cliquez **Fetch origin** puis **Pull origin** : votre `develop` est à jour.
3. **Current branch ▸ New branch** → donnez un nom court décrivant la modif
   (ex. `faq-tva-numeros-intracommunautaires`), basé sur **`develop`** →
   **Create branch**.

Vous travaillez désormais sur votre branche.

### b. Lancer le site — *optionnel, pour voir le rendu*

À sauter pour une modification simple. Sinon (🍎 sur l'hôte ; 🪟 dans
`agent-vm shell`, cf. étape 7) :

```sh
cd site && make start && cd ..
```

Ouvrez la fiche concernée dans le navigateur (catalogue sur
<http://entreprise.api.localtest.me:5000/>).

### c. Demander la modification à l'agent

```sh
agent-vm claude      # ou : agent-vm codex
```

> 🚨 **Avant de taper votre message :** relisez-le. **Aucune clé d'API, aucun
> secret, aucune donnée personnelle** (voir l'avertissement en tête de guide).
> Vous parlez à un service tiers.

Décrivez votre besoin en langage courant, par exemple :

> Ajoute à la FAQ de l'API TVA (DGFIP) la question : « Une entreprise peut-elle
> avoir plusieurs numéros de TVA intracommunautaire ? » Réponse : « Une
> entreprise assujettie à la TVA peut posséder un numéro de TVA pour chacun de
> ses codes d'activité (NAF/APE). Les numéros de TVA affichés sur l'Annuaire des
> Entreprises sont les numéros actifs à la date d'extraction des données. »

L'agent trouve tout seul le bon fichier, fait la modification et vous explique
ce qu'il a changé. N'hésitez pas à itérer (« non, plutôt comme ceci… »), et à lui
**poser des questions** pour explorer avant de modifier (voir
[« L'agent répond aussi à vos questions »](#lagent-répond-aussi-à-vos-questions)
au début du guide).

Quand c'est bon, quittez l'agent (`Ctrl + C` deux fois, ou tapez `/exit`).

### d. Vérifier le rendu — *optionnel, si le site est lancé*

Si vous n'avez pas lancé le site, passez directement à l'étape e. Sinon,
rechargez le site (🍎 sur l'hôte ; 🪟 dans `agent-vm shell`) :

```sh
cd site && make stop && make start && cd ..
```

Rafraîchissez la page dans le navigateur. Vérifiez le texte, la mise en forme,
les liens.

### e. Relire les modifications (dans GitHub Desktop)

Ouvrez **GitHub Desktop**, onglet **Changes** : la liste des fichiers modifiés
s'affiche à gauche, et le détail des changements (en vert/rouge) à droite quand
vous cliquez un fichier.

Relisez chaque changement : vous devez **comprendre et assumer** ce qui est
modifié (c'est une exigence du projet, voir
[`CONTRIBUTING.md`](../CONTRIBUTING.md)).

> 🚨 **Dernier contrôle avant publication :** ces changements ne contiennent
> **aucune clé d'API, aucun secret, aucune donnée personnelle** ? Une fois
> envoyé sur GitHub, c'est public. Dans le doute, n'envoyez pas et demandez à
> l'équipe.

### f. Enregistrer, signer et envoyer (dans GitHub Desktop)

Toujours dans **GitHub Desktop**, onglet **Changes** :

1. Vérifiez en haut que vous êtes bien sur **votre branche** (pas sur
   `develop`), et que les fichiers à inclure sont cochés.
2. En bas à gauche, écrivez le **résumé** (titre court décrivant *le pourquoi*),
   par exemple :
   `API TVA (DGFIP) : ajoute une FAQ sur les numéros de TVA intracommunautaire multiples`
3. Dans la **description**, ajoutez **obligatoirement** en dernière ligne le
   sign-off (GitHub Desktop ne l'ajoute pas tout seul ; exigé par le projet) :

   ```
   Signed-off-by: Prénom Nom <vous@exemple.gouv.fr>
   ```

4. Cliquez **Commit to <votre-branche>**. La **phrase secrète GPG** vous est
   demandée : c'est la signature (étape 5) qui s'applique.
5. Cliquez **Push origin** (en haut) pour envoyer votre travail.
6. Cliquez **Create Pull Request** : votre navigateur s'ouvre sur la page de
   création. Vérifiez que la cible est bien **`develop`**, remplissez la
   description (contexte, ce qui change, pourquoi), puis **Create pull request**.

L'équipe sera notifiée, relira, et publiera. Si on vous demande des ajustements,
refaites les étapes c à f sur la même branche (chaque nouveau commit s'ajoute
automatiquement à la pull request).

> 💡 **Vous préférez le terminal ?** Tout ceci a un équivalent en commandes
> (`git checkout -b`, `git commit -s`, `git push`, `gh pr create`) ; `commit -s`
> ajoute alors le sign-off automatiquement. Mais GitHub Desktop suffit pour tout
> ce guide.

---

## 11. Dépannage & questions fréquentes

**« command not found » sur une commande.**
L'outil n'est pas installé ou le Terminal n'a pas été rouvert depuis
l'installation. Fermez et rouvrez le Terminal, puis refaites l'étape concernée.

**Le site n'affiche pas ma modification.**
Forcez le rechargement : `cd site && make stop && make start` (🍎 sur l'hôte ;
🪟 dans `agent-vm shell`). Puis videz le cache du navigateur (rechargement forcé
`Cmd + Shift + R` / `Ctrl + Shift + R`).

**`docker info` : « Cannot connect to the Docker daemon ».**
Docker Desktop n'est pas démarré. Ouvrez l'application et attendez l'icône
baleine dans la barre de menus.

**GitHub Desktop refuse d'envoyer (« authentication failed »).**
Votre session GitHub a expiré : dans GitHub Desktop, `Settings ▸ Accounts ▸
Sign out` puis reconnectez-vous (étape 6).

**Le commit échoue avec une erreur GPG (« gpg failed to sign the data »).**
La signature GPG n'est pas opérationnelle. Re-testez `echo "test" | gpg
--clearsign` (étape 5) et vérifiez `git config --global gpg.program`.
- 🍎 macOS : vérifiez la présence de `pinentry-mac`.
- 🪟 Windows : vérifiez que Gpg4win est installé et que le chemin
  `C:\Program Files (x86)\GnuPG\bin\gpg.exe` existe.
En dépannage temporaire, vous pouvez committer sans signature :
`git commit --no-gpg-sign -m "…"` (mais corrigez ensuite la config).

**GitHub Desktop ne demande pas la phrase secrète / le commit n'est pas signé.**
GitHub Desktop s'appuie sur la config git de l'hôte : assurez-vous que `git config
--global commit.gpgsign` renvoie `true` et que la signature fonctionne au
terminal (test ci-dessus). Fermez puis rouvrez GitHub Desktop après tout
changement de configuration GPG.

**GitHub Desktop : ma PR est refusée pour « commit non signé » (DCO).**
GitHub Desktop n'ajoute pas le `Signed-off-by` automatiquement : ajoutez-le en
dernière ligne de la **description** du commit (étape 10f), au format
`Signed-off-by: Prénom Nom <vous@exemple.gouv.fr>`.

**Mon commit n'a pas le badge « Verified » sur GitHub.**
L'email du commit doit être **identique** à l'email de votre clé GPG **et** à un
email vérifié de votre compte GitHub. Vérifiez `git config --global user.email`
et l'email associé à la clé (`gpg --list-secret-keys`).

**Je me suis trompé, je veux tout annuler avant le commit.**
Dans GitHub Desktop, onglet **Changes** : clic droit sur un fichier →
**Discard changes** (ou **Discard all changes** pour tout annuler). Attention :
c'est irréversible pour ces modifications.

**Je veux repartir de zéro proprement.**
Dans GitHub Desktop : **Current branch ▸ `develop`**, **Fetch/Pull origin**,
puis **New branch** (étape 10a).

**Réinitialiser complètement la VM de l'agent.**
`agent-vm rm` (depuis l'hôte) supprime la VM ; le prochain `agent-vm claude` la
recrée et rejoue toute la configuration. (🪟 Windows : `agent-vm setup` la
reprovisionne.)

**🪟 Windows : `agent-vm` n'est pas reconnu.**
Le profil PowerShell n'est pas chargé. Vérifiez que `$PROFILE` contient bien la
ligne `. "$HOME\tools\agent-vm-windows\agent-vm.ps1"`, puis **ouvrez un nouveau
terminal**. Si PowerShell bloque le script, autorisez les scripts locaux :
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

**🪟 Windows : `agent-vm setup` échoue à créer la VM.**
Mettez WSL à jour (`wsl --update`) et assurez-vous d'être sous **Windows 11**
avec la virtualisation activée. En dernier recours, voir la procédure
`wsl --import` du README de `agent-vm-windows`.

**Une question sans réponse ici ?**
Ouvrez une [issue GitHub](https://github.com/datagouv/apistration/issues) ou
contactez l'équipe à equipe@entreprise.api.gouv.fr.
