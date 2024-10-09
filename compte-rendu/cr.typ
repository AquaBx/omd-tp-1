
#let problem_counter = counter("problem")

#let prob(body) = {
  // let current_problem = problem_counter.step()
  block(fill:rgb(250, 255, 250),
   width: 100%,
   inset:8pt,
   radius: 4pt,
   stroke:rgb(31, 199, 31),
   body)
  }

// Some math operators
#let prox = [#math.op("prox")]
#let proj = [#math.op("proj")]
#let argmin = [#math.arg]+[#math.min]

#let logo_esir = "esir.png"
#let logo_univ = "univ.png"

#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

// Initiate the document title, author...
#let assignment_class(title, author, course_id, professor_name, due_time, body) = {
  set document(title: title, author: author)
  set heading(numbering: "1.")
  set page(
    paper:"us-letter", 
    header: locate( 
        loc => if (
            counter(page).at(loc).first()==1) { none } 
        else if (counter(page).at(loc).first()==2) { align(right, 
              [*#author* | *#course_id #title*  ]
            ) }
        else { 
          align(right, 
            [*#author* | *#course_id #title* ]
          ) 
        }
    ),
    footer: locate(
      loc => {
        if counter(page).at(loc).first() != 1 {
          let page_number = counter(page).at(loc).first()-1
          let total_pages = counter(page).final(loc).last()-1
          align(center)[#page_number/#total_pages]
        }
      }
    )
  )

  align(center, [
    #grid(
      columns: (30%,30%),
      align(center, image(logo_esir, width: 100%)),
      align(center, image(logo_univ, width: 100%)),
  )])
  block(height:25%,fill:none)
  align(center, text(17pt)[
    *#course_id: #title*])
  align(center, text(10pt)[
    A rendre le #due_time])
  align(center, [_Responsable: #professor_name _])
  block(height:35%,fill:none)
  align(center)[*#author*]
  
  pagebreak(weak: false)

  body
}



#let title = "TP - Conception OO"
#let author = "CHAUVEL Tom, JOSSO Célia, Gr. TP1"
#let course_id = "OMD"
#let instructor = "FEUILLATRE Hélène"
#let semester = "Semestre 6"
#let due_time = "lundi 14 octobre"
#set enum(numbering: "a)")
#show: assignment_class.with(title, author, course_id, instructor, due_time)
#set par(justify: true)

#import "@preview/codelst:2.0.0": sourcecode
#import "@preview/algo:0.3.3": algo, i, d, comment, code

#import "@preview/ctheorems:1.1.2": *
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Théorème", fill: rgb("#EEEEEE"))

#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
) 

#outline(
  title: [Sommaire],
  indent: auto,
  depth: 3,
)

#pagebreak()
= Introduction
max 5 lignes

#pagebreak()
= Analyse fonctionnelle

== Description générale
Suite à la lecture et à l'analyse du sujet, voici la description du système telle que nous l'avons interprété.

=== Système

Le système est le cinéma. Il est modélisé par deux interfaces : une borne physique située à l’entrée et une application web accessible en ligne.

=== But 

Le but serait d'informatiser le système de réservation de place pour ce système (un nouveau cinéma) afin de permettre aux clients de réserver en ligne ou via une borne au cinéma, et aux employés et membres du personnel de gérer ce système de réservation de manière efficace.

=== Acteurs

Les acteurs seraient :
- L'Employé : il vérifie les informations concernant les réductions tarifaires et la disponibilité des places.
- Le Membre du personnel : il gère la répartition des films dans les salles et met à jour le système.
- Le Client sans compte : il peut consulter les films et créer un compte pour réserver.
- Le Client avec compte : il peut réserver des places, bénéficier d'avantages fidélité, et gérer ses informations personnelles.

== Diagramme de cas d'utilisation

Voici le diagramme de cas d'utilisation que nous en avons déduit :

#figure(
  image("../uml/img/1-diagrammeCasUtilisation.png", width:12cm)
)

== Description des cas d'utilisation

Voici la description de chaque cas d'utilisation.

#set text(8.49pt)
#table(
  columns: (0.4fr, 0.4fr, 1.1fr, 1.1fr, 1.1fr),
  inset: 3pt,
  
  // Headers
  [*Cas \d'utilisation*], [*Acteurs*], [*Scénario nominal*], [*Scénario alternatif*], [*Scénario exception*],
  
  [Modifier ses informations personnelles], [Client \ connecté], [
    1. Consulte son compte
    2. Clique sur un bouton "Modifier ses informations personnelles"
    3. Une page apparaît avec tous les champs modifiables
    4. Clique sur un bouton "Valider"
    5. Une pop-up confirme la modification des informations personnelles
  ], [
    1. Décide de ne modifier aucune information et quitte simplement la page.
    2. Annule la modification en cliquant sur un bouton « Annuler ».
  ], [
    1. L'adresse mail existe déjà : message d'erreur affiché.
    2. Le client n'est pas majeur : message d'erreur affiché.
    3. Problème de connexion au serveur : un message d'erreur s'affiche.
  ],
  
  [Consulter son compte], [Client \ connecté], [
    1. Appuie sur un bouton "Mon compte"
    2. Consulte son compte
  ], [
    1. N'a pas de réservations ou de points de fidélité, un message « Aucune information à afficher » est affiché.
  ], [
    1. Problème de connexion au serveur : un message d'erreur s'affiche.
  ],
  
  [Réserver un film #footnote[Réserver une séance (film, horaire) et un nombre de place voulu]], [Client \ connecté], [
    1. Sélectionne un film et une séance
    2. Choisit le nombre de places et les tarifs associés
    3. Procède au paiement
    4. Réservation validée si le paiement est accepté
    5. Reçoit une confirmation par mail avec un billet électronique
  ], [
    1. Accumule suffisamment de points pour obtenir un billet gratuit, le système lui propose de l'utiliser avant de payer.
    2. Décide d'annuler la réservation ou de changer de film.
  ], [
    1. Paiement refusé : Le client est informé de vérifier ses informations bancaires.
    2. Plus de places disponibles : La séance est complète, réservation impossible.
    3. Problème de connexion au serveur : un message d'erreur s'affiche.
  ],
  
  [Créer un compte], [Client non connecté], [
    1. Clique sur "Créer mon compte"
    2. Remplit le formulaire de création de compte
    3. Appuie sur "Valider"
    4. Reçoit une confirmation par mail
  ], [
    1. Décide de ne pas créer de compte et quitte la page.
    2. Fournit des informations incomplètes : le système met en évidence les champs manquants.
  ], [
    1. L'adresse mail existe déjà : Message d'erreur affiché.
    2. Le client n'est pas majeur : Message d'erreur affiché.
    3. Mot de passe invalide : Message d'erreur affiché
    3. Problème de connexion au serveur : un message d'erreur s'affiche.
  ],
  
  [Se \ connecter à un compte], [Client non connecté], [
    1. Clique sur "Se connecter"
    2. Remplit le formulaire de connexion
    3. Appuie sur "Valider"
  ], [
    1. N'a pas de compte : Il crée un compte.
    2. Oublie son mot de passe : Il clique sur « Mot de passe oublié » pour le réinitialiser.
  ], [
    1. Mauvais identifiant : Message d'erreur affiché.
    2. Problème de connexion au serveur : Message d'erreur affiché.
  ],
  
  [Consulter les informations de réservation], [Employé], [
    1. Se connecte à son espace
    2. Consulte les informations des salles et des réservations sous forme de tableau
  ], [
    1. Peut trier et filtrer les réservations selon le titre du film, l'heure, la salle...
  ], [
    1. Pas de réservations pour une période donnée : Message « Aucune réservation disponible ».
    2. Problème de connexion au serveur : Message d'erreur affiché.
  ],
  
  [Attribuer une salle à un film et une séance], [Membre du \ personnel], [
    1. Se connecte à son espace
    2. Consulte les séances
    3. Sélectionne une séance sans salle attribuée
    4. Fournit les salles disponibles
    5. Choisit une salle
    6. Confirme l'attribution de la salle via une pop-up
  ], [
    1. Peut attribuer automatiquement une salle en fonction de la taille de la salle,  la présence de 3D).
    2. Aucune salle n'est disponible, le système décide d'annuler le processus d'attribution.
  ], [
    1. Problème de connexion au serveur : un message d'erreur s'affiche.
  ]
)

#set text(11pt)
#pagebreak()
= Analyse structurelle

== Diagrammes de séquence

Nous avons réalisé trois diagrammes de séquence correspondant à différents cas d'utilisation décrits précédemment : _Créer un compte_, _Attribuer une salle à un film et un horaire_, et _Réserver un film_.

=== Cas d'utilisation "Créer un compte"

Le cas d'utilisation "Créer un compte" a été décrit ainsi dans la partie précédente :
- Acteur : Client non connecté.
- Scénario nominal :
  - 1. Le client clique sur le bouton "Créer mon compte".
  - 2. Il remplit le formulaire de création de compte avec ses informations.
  - 3. Il valide le formulaire en cliquant sur "Valider".
  - 4. Une confirmation de création de compte est envoyée par mail.
- Scénarios alternatifs :
  - Le client décide d'abandonner la création du compte et quitte la page.
  - Le client soumet des informations incomplètes : le système met en évidence les champs manquants.
- Scénarios d'exception :
  - L'adresse mail est déjà utilisée : un message d'erreur est affiché.
  - Le client est mineur : un message d'erreur est affiché.
  - Le mot de passe est invalide : un message d'erreur est affiché.
  - Problème de connexion au serveur : un message d'erreur est affiché (Pour des soucis de simplifications, nous ne modéliserons pas ce dernier scénario).

Un diagramme de séquence correspondant pourrait être illustré comme suit :
  
#figure(
  image("../uml/img/2-diagrammeSéquence1.png", width: 3.22cm)
)

=== Cas d'utilisation "Attribuer une salle à un film et un horaire"

Le cas d'utilisation "Attribuer une salle à un film et un horaire" a été décrit ainsi dans la partie précédente :
- Acteur : Membre du personnel.
- Scénario nominal :
  - 1. Le membre du personnel se connecte à son espace de travail sécurisé.
  - 2. Il consulte la liste des séances sans salle attribuée.
  - 3. Il sélectionne une séance à laquelle il faut attribuer une salle.
  - 4. Le système affiche les salles disponibles.
  - 5. Le membre du personnel choisit une salle adaptée à la séance.
  - 6. L'attribution de la salle est confirmée par une pop-up de validation.
- Scénarios alternatifs :
  - Le membre du personnel peut opter pour une attribution automatique en fonction de critères prédéfinis comme la taille de la salle ou la présence de la technologie 3D. (Pour des soucis de simplifications, nous ne modéliserons pas ce dernier scénario)
  - Aucune salle n'est disponible, le système décide d'annuler le processus d'attribution.
- Scénarios d'exception :
  - Problème de connexion au serveur : un message d'erreur est affiché (Pour des soucis de simplifications, nous ne modéliserons pas ce dernier scénario).

Un diagramme de séquence correspondant pourrait être illustré comme suit :
  
#figure(
  image("../uml/img/2-diagrammeSéquence2.png", width: 10cm)
)

#pagebreak()
=== Cas d'utilisation "Réserver un film"

Le cas d'utilisation "Réserver un film" a été décrit ainsi dans la partie précédente :
- Acteur : Client connecté.
- Scénario nominal :
  - 1. Le client connecté sélectionne un film et une séance
  - 2. Il choisit le nombre de places et les tarifs associés
  - 3. Il procède au paiement
  - 4. La réservation est validée si le paiement est accepté
  - 5. Reçoit une confirmation par mail avec un billet électronique
- Scénarios alternatifs :
  - *1. Accumule suffisamment de points pour obtenir un billet gratuit, le système lui propose de l'utiliser avant de payer. => on a oublié de modéliser ça !*
  - 2. Décide d'annuler la réservation ou de changer de film. (Pour des soucis de simplifications, nous ne modéliserons pas ce dernier scénario)
- Scénarios d'exception :
  - 1. Paiement refusé : Le client est informé de vérifier ses informations bancaires.
  - 2. Plus de places disponibles : La séance (comprend le film et l'horaire) est complète, réservation impossible.
  - 3. Problème de connexion au serveur : un message d'erreur s'affiche. (Pour des soucis de simplifications, nous ne modéliserons pas ce dernier scénario)

Un diagramme de séquence correspondant pourrait être illustré comme suit :

  
#figure(
  image("../uml/img/2-diagrammeSéquence3.png", width:7.21cm)
)

== Diagrammes de classe

A partir des diagrammes de séquence, nous pouvons désormais mieux imaginer un diagramme de classes possible pour ce problème.

#figure(
image("../uml/img/3-diagrammeClasses.png")
)

dire nos choix (TODO)

#pagebreak()
= Analyse comportementale

- Etat de la réservation d'une séance (à rédiger)

#figure(
image("../uml/img/4-diagrammeEtat1.png")
)

- Etat de la connexion/déconnexion d'un client (à rédiger)

#figure(
image("../uml/img/4-diagrammeEtat2.png")
)
= Conclusion
max 10 lignes


