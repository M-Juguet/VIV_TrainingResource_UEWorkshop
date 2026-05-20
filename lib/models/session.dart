import 'package:flutter/material.dart';

// Enum for layout orientation
enum ContentLayout { textLeft, textRight, fullWidth }

// Abstract class for all content modules
abstract class ContentModule {
  final String id;
  const ContentModule({required this.id});
}

class TitleModule extends ContentModule {
  final String title;
  const TitleModule({required super.id, required this.title});
}

// Text only module
class TextModule extends ContentModule {
  final String? title;
  final String content;
  const TextModule({required super.id, this.title, required this.content});
}

// Media + Text split module
class SideBySideModule extends ContentModule {
  final String? title;
  final String content;
  final String imagePath;
  final String? caption;
  final ContentLayout layout;
  const SideBySideModule({
    required super.id,
    this.title,
    required this.content,
    required this.imagePath,
    this.caption,
    required this.layout,
  });
}

// Full width media module
class FullMediaModule extends ContentModule {
  final String imagePath;
  final String? caption;
  const FullMediaModule({
    required super.id,
    required this.imagePath,
    this.caption,
  });
}

// Highlight / Note types
enum InfoType { idea, tip, warning, info, objective, challenge }

// Info / Annotation module
class InfoModule extends ContentModule {
  final String text;
  final InfoType type;
  const InfoModule({
    required super.id,
    required this.text,
    this.type = InfoType.idea,
  });
}

// Resource / Download module
class ResourceModule extends ContentModule {
  final String title;
  final String description;
  final String fileName;
  final String downloadUrl;
  const ResourceModule({
    required super.id,
    required this.title,
    required this.description,
    required this.fileName,
    required this.downloadUrl,
  });
}

// List / Key Points module
class ListModule extends ContentModule {
  final String title;
  final String? intro;
  final List<String> items;
  final String? outro;
  const ListModule({
    required super.id,
    required this.title,
    this.intro,
    required this.items,
    this.outro,
  });
}

class QuizModule extends ContentModule {
  final String question;
  final List<String> options;
  final List<int> correctIndices;
  final String explanation;

  const QuizModule({
    required super.id,
    required this.question,
    required this.options,
    required this.correctIndices,
    required this.explanation,
  });
}

class SessionModel {
  final int id;
  final String title;
  final String objective;
  final List<String> technicalPoints;
  final String filRouge;
  final IconData icon;
  final List<ContentModule> modules;

  const SessionModel({
    required this.id,
    required this.title,
    required this.objective,
    required this.technicalPoints,
    required this.filRouge,
    required this.icon,
    this.modules = const [],
  });

  bool get isUnderConstruction =>
      (id >= 101 && id <= 103) || (id >= 4 && id <= 8);
}

const List<SessionModel> basicsSessions = [
  SessionModel(
    id: 101,
    title: 'Epic Games & Unreal Engine',
    objective:
        "Découvrir l'histoire d'Epic Games et la philosophie derrière Unreal Engine.",
    technicalPoints: [
      "Histoire d'Epic Games",
      "Évolution du moteur",
      "Philosophie du Real-time",
    ],
    filRouge: "Comprendre l'écosystème dans lequel vous allez évoluer.",
    icon: Icons.history_edu_rounded,
    modules: [
      InfoModule(
        id: 'basics_101_info',
        text:
            "Cette partie de la formation est actuellement en cours de développement. Elle sera disponible très prochainement dans une future mise à jour de l'application !",
        type: InfoType.info,
      ),
    ],
  ),
  SessionModel(
    id: 102,
    title: 'Epic Games Launcher',
    objective: "Maîtriser l'outil central de gestion de vos projets et assets.",
    technicalPoints: [
      "Installation du moteur",
      "Library management",
      "Marketplace & Fab",
    ],
    filRouge: "Configurer son environnement de travail.",
    icon: Icons.rocket_launch_rounded,
    modules: [
      InfoModule(
        id: 'basics_102_info',
        text:
            "Cette partie de la formation est actuellement en cours de développement. Elle sera disponible très prochainement dans une future mise à jour de l'application !",
        type: InfoType.info,
      ),
    ],
  ),
  SessionModel(
    id: 103,
    title: 'Fondamentaux de la 3D',
    objective: "Rappels essentiels sur les concepts universels de la 3D.",
    technicalPoints: [
      "Axes X, Y, Z",
      "Meshes & Materials",
      "Éclairage de base",
    ],
    filRouge: "Vérifier ses acquis théoriques.",
    icon: Icons.view_in_ar_rounded,
    modules: [
      InfoModule(
        id: 'basics_103_info',
        text:
            "Cette partie de la formation est actuellement en cours de développement. Elle sera disponible très prochainement dans une future mise à jour de l'application !",
        type: InfoType.info,
      ),
    ],
  ),
];

const List<SessionModel> unrealSessions = [
  SessionModel(
    id: 1,
    title: 'Fondations & Workflow de Production',
    objective:
        "Maîtriser la distinction entre les éléments de scène et utiliser les flux d'importation modernes comme Fab, l'USD et l'Alembic.",
    icon: Icons.architecture_rounded,
    technicalPoints: [
      "Interface & Navigation",
      "Concepts & Asset Management",
      "Organisation & Configuration",
      "Gestion des Levels",
      "Migration & Sauvegarde",
    ],
    filRouge:
        "Importation des premiers éléments du décor via Fab et configuration d'un étage USD pour le projet fil rouge.",
    modules: [
      TitleModule(
        id: '1_title_p1',
        title: "Interface & Optimisation du Viewport",
      ),
      TextModule(
        id: '1_intro_pilotage',
        title: "L'Interface comme Poste de Pilotage",
        content:
            "Pour un artiste cinématique, l'interface n'est pas un simple cadre, c'est un poste de pilotage. Contrairement au développement de jeu, nous cherchons ici à maximiser la visibilité du Viewport tout en gardant un accès chirurgical aux outils de transformation et à la timeline. Une interface mal rangée est la première cause de friction créative.",
      ),
      SideBySideModule(
        id: '1_anatomy',
        title: "Anatomie des Fenêtres Principales",
        content:
            "L'éditeur s'articule autour de quatre piliers : le Viewport (fenêtre de rendu centrale), le World Outliner (liste hiérarchique des acteurs de la scène), le panneau Details (accès aux réglages précis de l'objet sélectionné) et le Content Browser (votre bibliothèque de fichiers).",
        imagePath: 'assets/images/interface_anatomy.jpg',
        caption: "Vue d'ensemble de l'interface standard d'Unreal Engine 5",
        layout: ContentLayout.textRight,
      ),
      InfoModule(
        id: '1_content_browser_tip',
        text:
            "Vous pouvez invoquer le Content Browser à tout moment via Ctrl + Espace sans avoir à l'ancrer, libérant ainsi un espace visuel précieux.",
        type: InfoType.info,
      ),
      SideBySideModule(
        id: '1_custom_layout',
        title: "Agencement et Sauvegarde de Layouts",
        content:
            "Chaque fenêtre peut être détachée, déplacée et ancrée. Pour la cinématique, nous recommandons d'ancrer le Sequencer en bas et de grouper l'Outliner et les Details à droite. Une fois votre setup idéal trouvé, utilisez le menu Window > Save Layout As pour le mémoriser.",
        imagePath: 'assets/images/custom_layout.jpg',
        caption: "Exemple de layout optimisé pour la mise en scène",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '1_dual_screen_tip',
        text:
            "Si vous disposez de deux écrans, détachez le Sequencer et placez-le sur le second moniteur pour travailler sur un Viewport en plein écran sur votre écran principal.",
        type: InfoType.tip,
      ),
      ListModule(
        id: '1_nav_commands',
        title: "Commandes de Navigation",
        intro:
            "Apprenez ces raccourcis pour naviguer comme un pro dans l'espace 3D :",
        items: [
          "Clic Droit + Z,Q,S,D (ou WASD) pour voler",
          "Molette Souris pour ajuster la vitesse de vol",
          "Touche F (Focus) pour centrer la vue sur l'objet sélectionné",
          "Alt + Clic Gauche pour orbiter autour d'un pivot",
        ],
        outro:
            "Maîtriser ces touches est le premier pas vers la rapidité d'exécution.",
      ),
      InfoModule(
        id: '1_focus_tip',
        text:
            "La touche F est votre meilleure alliie : elle réinitialise le pivot de rotation de votre caméra sur l'objet choisi, évitant ainsi que votre vue ne 'dérive' dans le vide.",
        type: InfoType.idea,
      ),
      SideBySideModule(
        id: '1_pilot_mode',
        title: "Le Mode Pilotage (Pilot Actor)",
        content:
            "Pour placer une lumière ou cadrer une caméra avec une précision extrême, utilisez le mode Pilot. Faites un clic droit sur l'acteur dans l'Outliner > Pilot. Vos mouvements dans le Viewport déplacent maintenant l'objet lui-même.",
        imagePath: 'assets/images/pilot_mode.jpg',
        caption: "Pilotage d'une Cine Camera pour un cadrage précis",
        layout: ContentLayout.textLeft,
      ),
      ListModule(
        id: '1_viz_modes',
        title: "Modes de Visualisation",
        intro: "Unreal propose différents modes pour analyser votre scène :",
        items: [
          "Lit (Alt+4) : Rendu final avec éclairage",
          "Unlit (Alt+3) : Affiche uniquement les textures sans lumière",
          "Wireframe (Alt+2) : Affiche la structure polygonale",
          "Game View (G) : Masque les icônes d'éditeurs (lumières, grilles)",
        ],
        outro:
            "Utilisez la touche G fréquemment pour juger votre image sans pollution visuelle.",
      ),
      InfoModule(
        id: '1_bookmarks_tip',
        text:
            "Utilisez les Bookmarks (Signets) : Ctrl + [0-9] mémorise la position de votre caméra. Appuyez sur le chiffre correspondant pour y revenir instantanément.",
        type: InfoType.tip,
      ),
      TextModule(
        id: '1_opti_viewport',
        title: "Optimisation du Viewport en Production",
        content:
            "Pour garder un éditeur fluide, même avec des milliers d'assets, il faut maîtriser la Scalability. Ces réglages (Low à Cinematic) affectent uniquement la qualité d'affichage dans l'éditeur, pas la qualité de votre rendu final. Réduire la qualité pendant le world building permet de garder une navigation fluide.",
      ),
      InfoModule(
        id: '1_screen_perc_warning',
        text:
            "Un Screen Percentage supérieur à 100% dans les réglages de Scalability peut faire chuter vos performances sans gain réel durant la phase de construction.",
        type: InfoType.warning,
      ),
      SideBySideModule(
        id: '1_realtime_toggle',
        title: "Performance et Realtime Toggle",
        content:
            "Le menu 'Hamburger' du Viewport contient l'option Realtime (Ctrl+R). Si vous effectuez des tâches d'organisation, désactivez-le. Cela fige les calculs dynamiques et soulage considérablement votre carte graphique.",
        imagePath: 'assets/images/realtime_toggle.jpg',
        caption: "Accès au menu de performance du Viewport",
        layout: ContentLayout.textRight,
      ),
      QuizModule(
        id: '1_quiz_viewport',
        question:
            "Quel raccourci permet de masquer toutes les icônes d'aide (billboards) pour voir uniquement l'image finale ?",
        options: ["F11", "G", "Ctrl+R", "Alt+H"],
        correctIndices: [1],
        explanation:
            "La touche G (Game View) bascule entre le mode édition et le mode visionnage, masquant tout ce qui ne sera pas visible au rendu final (icônes de lumières, grilles, etc.).",
      ),
      TitleModule(
        id: '1_title_p2',
        title: "Concepts & Asset Management (L'entrée des données)",
      ),
      TextModule(
        id: '1_p2_data_ue',
        title: "Comprendre la donnée dans Unreal",
        content:
            "Pour travailler efficacement, il faut d'abord comprendre comment Unreal Engine traite l'information. Contrairement à un logiciel de 3D classique où tout est stocké dans un seul fichier scène, Unreal fonctionne comme une base de données connectée. Chaque élément a un rôle précis et une méthode de stockage spécifique.",
      ),
      SideBySideModule(
        id: '1_p2_asset_actor',
        title: "Concept 1 : Asset vs Actor",
        content:
            "L'Asset est le fichier source présent dans votre Content Browser (l'objet sur le disque). L'Actor est l'instance de cet objet que vous placez dans votre niveau. Si vous modifiez l'Asset, tous les Actors correspondants dans votre monde sont mis à jour simultanément.",
        imagePath: 'assets/images/asset_vs_actor.jpg',
        layout: ContentLayout.textRight,
        caption:
            "L'Asset est le \"moule\", l'Actor est le \"moulage\" dans le monde.",
      ),
      InfoModule(
        id: '1_p2_ref_info',
        text:
            "On peut voir un Actor comme une référence légère à un Asset lourd. Cela permet de placer des milliers de rochers sans saturer la mémoire vive.",
        type: InfoType.info,
      ),
      ListModule(
        id: '1_p2_origin',
        title: "Concept 2 : Origine des Assets",
        intro: "Il existe deux types de fichiers dans votre projet :",
        items: [
          "Assets Importés : Proviennent de fichiers externes (.fbx, .png, .abc). Ils conservent un lien vers leur source originale.",
          "Assets Natifs : Créés directement dans Unreal (Materials, Blueprints, Levels). Ils n'ont pas de dépendance externe.",
        ],
        outro:
            "La fonction Reimport est vitale pour les assets importés : elle permet de mettre à jour un modèle 3D tout en conservant ses réglages Unreal.",
      ),
      SideBySideModule(
        id: '1_p2_fab',
        title: "L'Écosystème Fab",
        content:
            "Fab est la nouvelle plateforme unifiée d'Epic Games remplaçant Quixel Bridge et Sketchfab. Elle permet d'accéder à des millions d'assets (Megascans, modèles 3D, environnements) directement depuis l'éditeur via un simple glisser-déposer.",
        imagePath: 'assets/images/fab_interface.jpg',
        layout: ContentLayout.textLeft,
        caption: "La fenêtre Fab intégrée à l'éditeur",
      ),
      InfoModule(
        id: '1_p2_fab_tip',
        text:
            "Dans Fab, privilégiez toujours le téléchargement des textures en \"Channel Packed\" (ORM) pour optimiser les performances de votre projet cinématique.",
        type: InfoType.tip,
      ),
      TextModule(
        id: '1_p2_nanite_import',
        title: "Importation Géométrique : FBX et Nanite",
        content:
            "Le format FBX reste le standard pour importer des objets isolés. Lors de l'import, Unreal utilise le système Interchange qui permet de gérer les collisions, les pivots et les matériaux. Pour les projets cinématiques, l'activation de Nanite à l'importation est une étape non négociable pour gérer des millions de polygones sans ralentissement.",
      ),
      InfoModule(
        id: '1_p2_unit_warn',
        text:
            "Vérifiez toujours l'unité d'export de votre logiciel 3D (Maya/Blender) : 1 unité Unreal égale 1 centimètre. Un mauvais réglage peut rendre vos objets microscopiques ou gigantesques.",
        type: InfoType.warning,
      ),
      SideBySideModule(
        id: '1_p2_usd',
        title: "Pipeline USD : Le Flux Non-Destructif",
        content:
            "L'USD (Universal Scene Description) révolutionne le travail en équipe. Au lieu d'importer et de convertir des fichiers, on utilise un USD Stage pour \"lire\" la scène originale. Cela permet de modifier le décor dans un autre logiciel et de voir le résultat instantanément dans Unreal sans réimportation.",
        imagePath: 'assets/images/usd_stage.jpg',
        layout: ContentLayout.textRight,
        caption:
            "Utilisation du panneau USD Stage pour gérer des couches de scène",
      ),
      InfoModule(
        id: '1_p2_usd_idea',
        text:
            "L'USD est idéal pour les environnements massifs. Il permet de charger des scènes entières sans alourdir votre dossier Content Browser avec des milliers de petits fichiers .uasset.",
        type: InfoType.idea,
      ),
      TextModule(
        id: '1_p2_alembic',
        title: "Alembic et Geometry Cache",
        content:
            "Pour les animations que les \"Rigs\" classiques ne peuvent pas gérer (simulations de fluides, tissus complexes, explosions), on utilise le format Alembic (.abc). Unreal importe ces données sous forme de Geometry Cache, permettant de lire des animations \"Vertex-per-frame\" avec une fidélité absolue.",
      ),
      InfoModule(
        id: '1_p2_alembic_info',
        text:
            "L'importation d'un Alembic peut être lourde. Utilisez Nanite sur vos Geometry Caches pour maintenir une fluidité de lecture constante dans le Sequencer.",
        type: InfoType.info,
      ),
      SideBySideModule(
        id: '1_p2_vt',
        title: "Préparation des Surfaces",
        content:
            "L'importation de textures haute résolution (4K/8K) nécessite l'utilisation des Virtual Textures (VT). Ce système permet à Unreal de ne charger que les parties de la texture visibles à l'écran, économisant ainsi énormément de mémoire vidéo.",
        imagePath: 'assets/images/virtual_textures.jpg',
        layout: ContentLayout.textLeft,
        caption: "Paramétrage d'une texture en mode Virtual Texture",
      ),
      InfoModule(
        id: '1_p2_import_warn',
        text:
            "Évitez de laisser Unreal générer automatiquement des matériaux lors de l'importation de fichiers FBX. Ces matériaux sont souvent basiques et polluent votre projet. Préférez l'application manuelle de vos propres Master Materials.",
        type: InfoType.warning,
      ),
      QuizModule(
        id: '1_p2_quiz',
        question:
            "Quel est l'avantage principal de la fonction \"Reimport\" pour un asset FBX ?",
        options: [
          "Elle change la couleur de l'objet",
          "Elle met à jour la géométrie tout en conservant les placements et réglages Unreal",
          "Elle supprime l'objet du disque",
          "Elle réduit la taille du fichier",
        ],
        correctIndices: [1],
        explanation:
            "Le Reimport permet de lier la production externe (3D) au moteur sans casser le travail de mise en scène déjà effectué.",
      ),
      TitleModule(
        id: '1_title_p3',
        title: "Organisation & Configuration du Projet",
      ),
      TextModule(
        id: '1_p3_hygiene',
        title: "L'Hygiène de Projet : Un Gain de Temps Invisible",
        content:
            "Dans une production professionnelle, l'organisation n'est pas une option, c'est une police d'assurance. Un projet mal structuré devient rapidement ingérable, provoque des erreurs de liens (broken links) et ralentit la collaboration. Cette section détaille comment transformer un projet \"bac à sable\" en un environnement de travail \"Production Ready\".",
      ),
      SideBySideModule(
        id: '1_p3_maps_modes',
        title: "Configuration Globale : Maps & Modes",
        content:
            "Rien n'est plus frustrant que de devoir chercher sa scène de travail à chaque ouverture d'Unreal. Dans les Project Settings, la rubrique Maps & Modes vous permet de définir l'Editor Startup Map. C'est ici que vous déterminez quel niveau doit se charger automatiquement au lancement du moteur.",
        imagePath: 'assets/images/maps_and_modes.jpg',
        layout: ContentLayout.textRight,
        caption:
            "Configuration de la map de démarrage dans les Project Settings",
      ),
      InfoModule(
        id: '1_p3_game_map_tip',
        text:
            "Pensez à configurer également la \"Game Default Map\" avec la même scène pour que vos exports de tests s'ouvrent directement sur le bon niveau.",
        type: InfoType.tip,
      ),
      ListModule(
        id: '1_p3_naming',
        title: "Nomenclature Standard (Naming Convention)",
        intro:
            "Pour retrouver un asset en une seconde parmi des milliers, appliquez systématiquement ces préfixes officiels :",
        items: [
          "SM_ : Static Mesh (Géométrie)",
          "M_ : Master Material (Matériau parent)",
          "MI_ : Material Instance (Variante de matériau)",
          "T_ : Texture",
          "SK_ : Skeletal Mesh (Personnage riggé)",
          "P_ : Particle System (FX)",
        ],
        outro:
            "Un asset bien nommé est un asset qui se trouve via une simple recherche textuelle.",
      ),
      InfoModule(
        id: '1_p3_suffix_idea',
        text:
            "Pour les textures, utilisez des suffixes clairs en fin de nom : _BC (Base Color), _N (Normal Map) et _ORM (Occlusion/Roughness/Metallic) pour une lecture instantanée du rôle de l'image.",
        type: InfoType.idea,
      ),
      SideBySideModule(
        id: '1_p3_structure',
        title: "Architecture \"Production Ready\"",
        content:
            "Ne mélangez jamais vos fichiers avec ceux téléchargés sur le Marketplace. Créez un dossier racine portant le nom de votre projet (ex: _MY_PROJECT). À l'intérieur, créez une structure logique : Maps, Assets, Materials, Core et VFX.",
        imagePath: 'assets/images/folder_structure.jpg',
        layout: ContentLayout.textLeft,
        caption: "Exemple d'une hiérarchie de dossiers propre et isolée",
      ),
      InfoModule(
        id: '1_p3_color_coding',
        text:
            "Activez le \"Color Coding\" (clic droit sur un dossier > Set Color) pour identifier visuellement vos dossiers les plus importants en un coup d'œil.",
        type: InfoType.info,
      ),
      TextModule(
        id: '1_p3_dependencies',
        title: "Maintenance et Gestion des Dépendances",
        content:
            "Au fil de la production, vous allez déplacer ou supprimer des fichiers. Unreal gère ces changements via des pointeurs invisibles appelés Redirectors. Si ces pointeurs s'accumulent sans être nettoyés, ils peuvent corrompre vos fichiers ou faire échouer vos futures migrations vers d'autres projets.",
      ),
      SideBySideModule(
        id: '1_p3_redirectors',
        title: "Fix Up Redirectors",
        content:
            "Chaque fois que vous déplacez un dossier ou un groupe d'assets, faites un clic droit sur le dossier parent et sélectionnez Fix Up Redirectors. Cette action \"recoud\" les liens proprement et supprime les fichiers fantômes sur votre disque dur.",
        imagePath: 'assets/images/fix_up_redirectors.jpg',
        layout: ContentLayout.textRight,
        caption: "Nettoyage des liens après un déplacement de fichiers",
      ),
      InfoModule(
        id: '1_p3_windows_warn',
        text:
            "Ne déplacez jamais vos fichiers Unreal directement via l'explorateur Windows (File Explorer). Faites-le uniquement depuis le Content Browser d'Unreal pour que le moteur puisse mettre à jour les références.",
        type: InfoType.warning,
      ),
      SideBySideModule(
        id: '1_p3_ref_viewer',
        title: "Reference Viewer : Visualiser les Liens",
        content:
            "Pour comprendre quel matériau est utilisé par quel objet, ou identifier les dépendances d'une map, utilisez le Reference Viewer (clic droit sur un asset > Reference Viewer). C'est l'outil ultime pour auditer votre projet avant un export ou une migration.",
        imagePath: 'assets/images/reference_viewer.jpg',
        layout: ContentLayout.textLeft,
        caption: "Visualisation des connexions entre les différents assets",
      ),
      InfoModule(
        id: '1_p3_replace_idea',
        text:
            "Si vous devez supprimer un asset déjà utilisé dans la scène, utilisez l'option Replace References dans la fenêtre de suppression pour rediriger tous les acteurs vers un nouvel asset sans créer de trous dans votre décor.",
        type: InfoType.idea,
      ),
      QuizModule(
        id: '1_p3_quiz',
        question:
            "Quel outil permet de nettoyer les liens \"fantômes\" créés après avoir déplacé des assets dans le Content Browser ?",
        options: [
          "Reference Viewer",
          "Fix Up Redirectors",
          "Project Settings",
          "Size Map",
        ],
        correctIndices: [1],
        explanation:
            "Fix Up Redirectors est l'outil indispensable pour maintenir l'intégrité des liens de votre projet.",
      ),
      TitleModule(id: '1_title_p4', title: "Gestion des Levels"),
      TextModule(
        id: '1_p4_segmentation',
        title: "Pourquoi segmenter sa scène ?",
        content:
            "Dans une production cinématique, travailler exclusivement dans le \"Persistent Level\" (le niveau racine) est une erreur stratégique. Segmenter votre scène en sous-niveaux permet de séparer les responsabilités (décor, lumière, animation), facilite la gestion des performances en masquant ce qui n'est pas nécessaire, et protège vos données contre les modifications accidentelles.",
      ),
      SideBySideModule(
        id: '1_p4_persistent_vs_sub',
        title: "Persistent Level vs Sub-levels",
        content:
            "Le Persistent Level est le conteneur principal, le \"cerveau\" du projet. Les Sub-levels sont des fichiers .umap indépendants qui viennent s'y superposer. Cette architecture permet de charger ou décharger des parties entières de la scène sans jamais affecter le reste de l'environnement.",
        imagePath: 'assets/images/persistent_vs_sublevels.jpg',
        layout: ContentLayout.textRight,
        caption:
            "Schéma de la relation entre le niveau maître et ses sous-niveaux",
      ),
      SideBySideModule(
        id: '1_p4_levels_panel',
        title: "Le Panneau Levels & Current Level",
        content:
            "Accessible via le menu Window > Levels, ce panneau est votre tour de contrôle. L'élément critique à maîtriser est le Current Level (affiché en bleu gras) : chaque nouvel objet créé dans le Viewport sera automatiquement affecté au niveau courant. Double-cliquez sur un nom de niveau pour le rendre \"actif\".",
        imagePath: 'assets/images/levels_panel_ui.jpg',
        layout: ContentLayout.textLeft,
        caption:
            "Le panneau Levels montrant le niveau courant et les icônes de visibilité",
      ),
      InfoModule(
        id: '1_p4_current_level_info',
        text:
            "Si vous placez un projecteur mais que vous ne le voyez pas dans votre liste d'objets attendue, vérifiez immédiatement quel est votre \"Current Level\".",
        type: InfoType.info,
      ),
      ListModule(
        id: '1_p4_layers_method',
        title: "Méthodologie de Calques de Production",
        intro:
            "Pour un projet cinématique sain, adoptez cette structure systématiquement :",
        items: [
          "L_SetDressing : Pour toute la géométrie, les rochers et les assets de décor",
          "L_Lighting : Pour les lumières, les volumes de brouillard et le Post-Process",
          "L_Sequencer : Pour les caméras et les acteurs qui possèdent des pistes d'animation",
          "L_FX : Pour les particules et les simulations complexes (Alembic)",
        ],
        outro:
            "Cette séparation permet, par exemple, de tester trois éclairages différents sans jamais toucher à la position des rochers.",
      ),
      InfoModule(
        id: '1_p4_lighting_scenario_idea',
        text:
            "Le mode Lighting Scenario est une option de sous-niveau permettant de stocker des données de lumière radicalement différentes (ex: Jour et Nuit) pour un même décor, sans alourdir la scène principale.",
        type: InfoType.idea,
      ),
      SideBySideModule(
        id: '1_p4_transfer',
        title: "Transfert d'Actors et Verrouillage",
        content:
            "Si vous avez placé des objets dans le mauvais niveau, sélectionnez-les, faites un clic droit sur le niveau de destination dans le panneau Levels, puis choisissez Move Selected Actors to Level. Une fois un décor terminé, utilisez l'icône du Verrou pour empêcher tout déplacement par erreur.",
        imagePath: 'assets/images/move_to_level_action.jpg',
        layout: ContentLayout.textRight,
        caption: "Action de transfert d'acteurs entre deux niveaux",
      ),
      InfoModule(
        id: '1_p4_hide_tip',
        text:
            "Masquez les niveaux sur lesquels vous ne travaillez pas (icône de l'œil) pour libérer de la mémoire vidéo et gagner en clarté visuelle dans votre composition.",
        type: InfoType.tip,
      ),
      TextModule(
        id: '1_p4_world_partition',
        title: "World Partition : La gestion des grands mondes",
        content:
            "Pour les environnements de grande envergure (Open World), Unreal Engine 5 utilise le World Partition. Au lieu de gérer manuellement des fichiers de niveaux, le moteur divise le monde en une grille et charge dynamiquement les cellules selon la position de la caméra. Bien que moins utilisé pour des courts-métrages de 30 secondes, c'est un concept fondamental à connaître pour les productions massives.",
      ),
      InfoModule(
        id: '1_p4_partition_warn',
        text:
            "Le World Partition et le système de sous-niveaux classique ne font pas toujours bon ménage. Pour nos projets cinématiques, nous privilégions la gestion manuelle via le panneau Levels pour un contrôle total.",
        type: InfoType.warning,
      ),
      QuizModule(
        id: '1_p4_quiz',
        question:
            "Comment appelle-t-on le niveau qui s'affiche en bleu gras dans le panneau Levels ?",
        options: [
          "Master Level",
          "Current Level",
          "Active Layer",
          "Parent Map",
        ],
        correctIndices: [1],
        explanation:
            "Le Current Level est le niveau dans lequel s'enregistrent toutes vos actions et créations actuelles.",
      ),
      TitleModule(id: '1_title_p5', title: "Migration & Sauvegarde"),
      TextModule(
        id: '1_p5_safety',
        title: "La Sécurité des Données en Production",
        content:
            "Un crash, une corruption de fichier ou un asset perdu peuvent anéantir des jours de travail. Dans Unreal Engine, la sauvegarde ne se limite pas à presser \"Ctrl+S\". Il s'agit de comprendre comment le moteur lie les fichiers entre eux et comment extraire proprement ces données pour les partager ou les archiver.",
      ),
      SideBySideModule(
        id: '1_p5_migrate',
        title: "L'Outil Migrate : Le Transfert Propre",
        content:
            "Pour déplacer un asset (ou une map entière) d'un projet A vers un projet B, n'utilisez jamais l'explorateur Windows. Utilisez l'outil Migrate (clic droit sur l'asset > Asset Actions > Migrate). Unreal analysera alors toutes les dépendances (matériaux, textures, sons) et les copiera intelligemment dans le dossier Content de destination.",
        imagePath: 'assets/images/migrate_tool_window.jpg',
        layout: ContentLayout.textRight,
        caption:
            "Fenêtre de migration listant toutes les dépendances d'un asset",
      ),
      InfoModule(
        id: '1_p5_path_info',
        text:
            "Lors d'une migration, Unreal conserve la structure des dossiers originale. Si votre asset était dans \"Content/Assets/Rocks\", il sera recréé exactement au même chemin dans le nouveau projet.",
        type: InfoType.info,
      ),
      InfoModule(
        id: '1_p5_plugins_warn',
        text:
            "La migration ne transfère pas les réglages du projet ni les Plugins. Assurez-vous que le projet de destination possède les mêmes Plugins activés (ex: USD, Alembic) avant d'importer vos assets.",
        type: InfoType.warning,
      ),
      SideBySideModule(
        id: '1_p5_size_map',
        title: "Audit et Nettoyage : La Size Map",
        content:
            "Avant de migrer ou d'archiver, il est vital de savoir ce qui pèse lourd dans votre projet. L'outil Size Map (clic droit sur un dossier/asset > Size Map) offre une visualisation graphique de l'espace disque occupé. C'est l'outil parfait pour identifier une texture 8K inutile ou un cache Alembic trop massif.",
        imagePath: 'assets/images/size_map_visualizer.jpg',
        layout: ContentLayout.textLeft,
        caption:
            "Visualisation de l'empreinte mémoire des fichiers via la Size Map",
      ),
      InfoModule(
        id: '1_p5_cleaning_idea',
        text:
            "Utilisez la Size Map pour \"faire le ménage\" avant une livraison. Supprimer les assets inutilisés (Unused Assets) permet d'alléger considérablement le poids final de vos archives.",
        type: InfoType.idea,
      ),
      ListModule(
        id: '1_p5_strategies',
        title: "Stratégies de Sauvegarde et Versioning",
        intro:
            "Pour ne jamais perdre votre progression, adoptez ces réflexes :",
        items: [
          "Autosave : Configurez une fréquence courte mais supportable (15-20 min)",
          "Save As : Avant chaque modification majeure d'un niveau, enregistrez une nouvelle version (ex: Map_V01, Map_V02)",
          "Snapshots : Utilisez le système de snapshots si vous travaillez avec des plugins de versioning",
          "External Backups : Copiez régulièrement votre dossier de projet sur un disque externe ou un Cloud",
        ],
        outro:
            "Le versioning manuel des Maps est la méthode la plus simple pour revenir en arrière en cas d'erreur artistique.",
      ),
      InfoModule(
        id: '1_p5_autosave_tip',
        text:
            "Configurez vos préférences d'Autosave dans Edit > Editor Preferences > Loading & Saving. Vous y trouverez également le dossier de récupération des fichiers en cas de crash (Saved/Autosaves).",
        type: InfoType.tip,
      ),
      SideBySideModule(
        id: '1_p5_zip',
        title: "Archivage : Le Zip Project",
        content:
            "Pour figer une étape de production ou transmettre l'intégralité d'un projet, utilisez la fonction File > Zip Project. Unreal va alors créer une archive compressée contenant uniquement les dossiers nécessaires (Config, Content, Source, .uproject), en ignorant les dossiers temporaires lourds (Binaries, DerivedDataCache).",
        imagePath: 'assets/images/zip_project_menu.jpg',
        layout: ContentLayout.textRight,
        caption: "Création d'une archive projet complète et sécurisée",
      ),
      QuizModule(
        id: '1_p5_quiz',
        question:
            "Pourquoi l'outil \"Migrate\" est-il préférable à un copier-coller manuel dans Windows ?",
        options: [
          "Il compresse les fichiers",
          "Il détecte et emporte automatiquement toutes les dépendances (matériaux, textures) liées à l'asset",
          "Il change le format des fichiers",
          "Il est plus rapide",
        ],
        correctIndices: [1],
        explanation:
            "Migrate garantit que l'asset arrivera dans le nouveau projet avec tous ses composants fonctionnels, évitant les textures manquantes.",
      ),
    ],
  ),
  SessionModel(
    id: 2,
    title: 'World Building & Optimisation',
    objective:
        "Créer un décor riche rapidement sans alourdir le moteur en maîtrisant les outils de sculpture et les systèmes d'instanciation.",
    icon: Icons.landscape_rounded,
    technicalPoints: [
      "Placements d'objets",
      "Landscape Tool",
      "Instances & Clones",
      "Foliage Tool",
      "Spline Meshes",
      "Nanite",
      "Introduction au PCG",
    ],
    filRouge:
        "Sculpture du relief principal et peuplement procédural de la scène pour accueillir les futurs éléments de décor.",
    modules: [
      TitleModule(id: '2_p1_title', title: "Placement d'objets & Précision"),
      InfoModule(
        id: '2_p1_obj',
        text:
            "Agencer une scène avec exactitude en maîtrisant les outils de transformation et les systèmes d'aimantation (Snapping).",
        type: InfoType.objective,
      ),
      TextModule(
        id: '2_p1_blocking',
        title: "L'Art du Blocking",
        content:
            "Le placement d'objets est la première étape créative après l'importation. Un bon \"Block-out\" ne se contente pas de poser des objets : il définit l'échelle, la silhouette et la composition de votre futur plan cinématique. Pour gagner en efficacité, vous devez abandonner le placement \"à l'œil\" pour une approche mathématique et magnétique.",
      ),
      SideBySideModule(
        id: '2_p1_gizmos',
        title: "Les Gizmos de Transformation",
        content:
            "Unreal Engine utilise trois manipulateurs standards accessibles via les raccourcis W (Translation), E (Rotation) et R (Scale). Chaque axe possède une couleur universelle : Rouge (X), Vert (Y) et Bleu (Z).",
        imagePath: 'assets/images/transform_gizmos.jpg',
        caption:
            "Les manipulateurs de transformation et le code couleur des axes",
        layout: ContentLayout.textLeft,
      ),
      ListModule(
        id: '2_p1_shortcuts',
        title: "Raccourcis de Manipulation Rapide",
        intro: "Gagnez en vitesse avec ces commandes essentielles :",
        items: [
          "Espace : Basculer cycliquement entre Translation, Rotation et Scale",
          "Alt + Drag : Dupliquer l'objet sélectionné en le déplaçant sur un axe",
          "Ctrl + ` : Alterner entre coordonnées World (monde) et Local (objet)",
          "V (Maintenu) : Activer le Vertex Snapping pour coller deux sommets entre eux",
        ],
        outro:
            "La duplication par Alt + Drag est la méthode la plus rapide pour peupler un décor répétitif.",
      ),
      InfoModule(
        id: '2_p1_local_tip',
        text:
            "Le mode Local est indispensable lorsque vous voulez déplacer un objet selon son propre axe d'orientation (par exemple, faire glisser un tiroir ouvert de biais).",
        type: InfoType.info,
      ),
      SideBySideModule(
        id: '2_p1_snapping',
        title: "Maîtriser le Snapping",
        content:
            "Pour éviter les \"fentes\" de lumière entre deux murs, utilisez les options de Snapping en haut à droite du Viewport. Réglez la grille (Grid Snap) sur des valeurs fixes (10, 50 ou 100). Un alignement parfait sur la grille facilite grandement le travail du moteur de rendu et la gestion des ombres.",
        imagePath: 'assets/images/snapping_controls.jpg',
        caption: "Configuration de la grille et des incréments d'angles",
        layout: ContentLayout.textRight,
      ),
      InfoModule(
        id: '2_p1_rot_tip',
        text:
            "Travaillez avec un Snap de rotation de 5° ou 10° par défaut. Cela garantit des alignements propres et évite les rotations \"parasites\" de 0.0001° qui compliquent la sélection.",
        type: InfoType.tip,
      ),
      SideBySideModule(
        id: '2_p1_floor',
        title: "Snap to Floor (Touche Fin)",
        content:
            "La touche Fin (End) de votre clavier projette instantanément l'objet sur la surface physique située juste en dessous. C'est l'outil parfait pour poser des rochers, des caisses ou des personnages sur le sol sans avoir à ajuster manuellement l'axe Z.",
        imagePath: 'assets/images/snap_to_floor.jpg',
        caption: "Utilisation de la touche End pour un placage immédiat au sol",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p1_pivot_warn',
        text:
            "Le \"Snap to Floor\" se base sur le Pivot Point de l'objet. Si votre objet s'enfonce dans le sol, c'est que son pivot est mal placé (souvent au centre géométrique au lieu de la base).",
        type: InfoType.warning,
      ),
      TextModule(
        id: '2_p1_pivots',
        title: "Gestion des Pivot Points",
        content:
            "Le pivot est le point d'ancrage de vos transformations. Unreal permet de le déplacer temporairement en maintenant Alt + Clic Milieu sur le Gizmo. Pour un changement permanent (indispensable pour les assets mal exportés), utilisez le mode Modeling (Shift + 5) > onglet XForm > Edit Pivot. Cela évite de devoir corriger le placement à chaque nouvelle instance.",
      ),
      QuizModule(
        id: '2_p1_quiz',
        question:
            "Comment déplacer temporairement le pivot d'un objet pour effectuer une rotation spécifique ?",
        options: [
          "Ctrl + Clic Droit sur l'objet",
          "Alt + Clic Milieu sur le Gizmo",
          "Touche P",
          "Shift + V",
        ],
        correctIndices: [1],
        explanation:
            "Alt + Clic Milieu permet de décaler le pivot pour, par exemple, faire pivoter une porte autour de ses gonds.",
      ),
      TitleModule(id: '2_p2_title', title: "Landscape Tool (Sculpture)"),
      InfoModule(
        id: '2_p2_obj',
        text:
            "Créer et sculpter une topographie naturelle réaliste en utilisant les outils de modelage d'Unreal Engine 5.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '2_p2_foundation',
        title: "Le Terrain comme Fondation",
        content:
            "Le Landscape est un système de terrain hautement optimisé, capable de gérer des surfaces massives sans sacrifier les performances. Contrairement à un Static Mesh classique, il utilise un maillage dynamique qui ajuste sa précision selon la distance (LODs). Dans cette section, nous nous concentrons exclusivement sur la création de la forme et du volume de votre monde.",
      ),
      SideBySideModule(
        id: '2_p2_creation',
        title: "Création et Résolution",
        content:
            "Pour débuter, passez en mode Landscape (Maj + 2). Dans l'onglet \"Manage\", vous déterminez la taille de votre terrain. Pour une optimisation idéale, privilégiez les valeurs de \"Section Size\" standards (ex: 63x63 ou 127x127). Une résolution trop élevée sur une surface inutilement grande est la première cause de lourdeur d'un projet.",
        imagePath: 'assets/images/landscape_manage_ui.jpg',
        caption: "Paramétrage technique de la grille du terrain",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p2_layers_info',
        text:
            "Activez systématiquement l'option Enable Edit Layers lors de la création. Cela vous permettra de travailler avec des calques de sculpture, à la manière de Photoshop, pour un flux de travail non-destructif.",
        type: InfoType.info,
      ),
      ListModule(
        id: '2_p2_sculpt_tools',
        title: "Les Outils de Modelage (Sculpt)",
        intro:
            "Une fois le terrain créé, utilisez les brosses pour sculpter votre relief :",
        items: [
          "Sculpt : Élève ou abaisse le terrain (Clic Gauche / Maj + Clic Gauche)",
          "Smooth : Adoucit les zones trop accidentées ou les \"pics\" polygonaux",
          "Flatten : Aligne le terrain sur la hauteur du premier clic (parfait pour des plateaux ou des routes)",
          "Erosion : Simule l'usure naturelle pour donner un aspect géologique crédible",
        ],
        outro:
            "Maintenez la touche B et déplacez la souris pour ajuster la taille de votre brosse dynamiquement.",
      ),
      SideBySideModule(
        id: '2_p2_layers',
        title: "Sculpt Layers : La Sécurité Créative",
        content:
            "Les calques de sculpture permettent d'isoler vos modifications. Vous pouvez créer un calque \"Montagnes\" et un calque \"Chemins\". Si un relief ne vous convient plus, vous pouvez réduire l'intensité du calque ou le masquer totalement sans supprimer le reste de votre travail.",
        imagePath: 'assets/images/landscape_layers_stack.jpg',
        caption: "Gestion de la pile de calques de sculpture",
        layout: ContentLayout.textRight,
      ),
      InfoModule(
        id: '2_p2_erosion_idea',
        text:
            "L'outil Hydro Erosion est votre meilleur allié pour le réalisme : il creuse des sillons naturels simulant le passage de l'eau sur des millénaires, transformant une simple colline en un relief montagneux crédible.",
        type: InfoType.idea,
      ),
      InfoModule(
        id: '2_p2_steep_warn',
        text:
            "Le Landscape supporte mal les pentes verticales à 90°. Cela provoque des étirements disgracieux du maillage. Pour des falaises abruptes, sculptez une pente douce et venez la masquer en plaçant des assets de rochers (Static Meshes) par-dessus.",
        type: InfoType.warning,
      ),
      TextModule(
        id: '2_p2_partition',
        title: "L'Importance du World Partition",
        content:
            "Pour les environnements de très grande envergure, le Landscape s'intègre au système de World Partition. Le moteur découpe alors automatiquement votre terrain en \"grilles\" qui se chargent et se déchargent selon la position de votre caméra, permettant de créer des mondes virtuellement illimités sans saturer la mémoire vive.",
      ),
      QuizModule(
        id: '2_p2_quiz',
        question:
            "Quel outil de sculpture est le plus adapté pour créer une zone plane destinée à accueillir une structure ou un bâtiment ?",
        options: ["Smooth", "Sculpt", "Flatten", "Noise"],
        correctIndices: [2],
        explanation:
            "L'outil Flatten permet de niveler le terrain à une altitude fixe, garantissant une base stable pour vos objets.",
      ),
      TitleModule(id: '2_p3_title', title: "Instances & Clones"),
      InfoModule(
        id: '2_p3_obj',
        text:
            "Comprendre la différence technique entre les Static Meshes et les instances pour optimiser radicalement la fluidité de vos scènes denses.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '2_p3_repetition',
        title: "L'Enjeu de la Répétition",
        content:
            "Dans un décor cinématique, on utilise souvent des centaines, voire des milliers de fois le même objet (pierres, arbres, dalles). Si chaque copie est traitée comme un objet unique, le moteur de rendu s'épuise à envoyer des ordres individuels à la carte graphique. C'est ici qu'intervient la notion d'instanciation.",
      ),
      SideBySideModule(
        id: '2_p3_sm_vs_ism',
        title: "Static Mesh vs Instanced Static Mesh",
        content:
            "Un Static Mesh classique est une copie complète : le moteur recharge toute la géométrie et les textures pour chaque unité. Un Instanced Static Mesh (ISM) est une référence légère : le moteur ne garde en mémoire qu'un seul \"moule\" et se contente de noter la position, la rotation et l'échelle de chaque clone.",
        imagePath: 'assets/images/static_vs_instanced.jpg',
        caption:
            "Comparaison de la consommation mémoire entre copies uniques et instances",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p3_drawcall_info',
        text:
            "Chaque objet unique envoyé à la carte graphique génère ce qu'on appelle un Draw Call. Trop de Draw Calls font chuter vos FPS. L'instanciation permet de regrouper des milliers d'objets en un seul Draw Call.",
        type: InfoType.info,
      ),
      ListModule(
        id: '2_p3_benefits',
        title: "Les Avantages de l'Instanciation",
        intro: "Pourquoi privilégier les instances pour vos décors ?",
        items: [
          "Gain de performance massif : Réduction drastique de la charge CPU/GPU.",
          "Consommation mémoire réduite : On ne stocke qu'une seule fois les données géométriques lourdes.",
          "Fluidité du Viewport : Permet de manipuler des scènes denses sans saccades.",
          "Base du Foliage : C'est la technologie qui permet d'afficher des forêts entières.",
        ],
        outro:
            "Utiliser les instances est le secret des environnements riches qui restent fluides.",
      ),
      InfoModule(
        id: '2_p3_merge_tip',
        text:
            "Pour transformer rapidement plusieurs Static Meshes identiques en instances, vous pouvez utiliser l'outil Merge Actors en mode \"Batch\" ou passer par le système de Foliage que nous verrons au point suivant.",
        type: InfoType.tip,
      ),
      SideBySideModule(
        id: '2_p3_hierarchy',
        title: "Hiérarchie et Organisation",
        content:
            "Dans votre World Outliner, les instances sont souvent regroupées sous un seul acteur parent (l'Instanced Static Mesh Component). Cela nettoie votre hiérarchie et facilite la sélection de groupes d'objets identiques pour des modifications globales.",
        imagePath: 'assets/images/instanced_mesh_component.jpg',
        caption: "Structure d'un composant d'instance dans le panneau Details",
        layout: ContentLayout.textRight,
      ),
      InfoModule(
        id: '2_p3_mat_warn',
        text:
            "Toutes les instances d'un groupe partagent obligatoirement le même Material. Si vous avez besoin qu'un rocher soit rouge et l'autre bleu, ils devront appartenir à deux groupes d'instances différents ou utiliser des \"Per-Instance Custom Data\".",
        type: InfoType.warning,
      ),
      InfoModule(
        id: '2_p3_structure_idea',
        text:
            "L'instanciation est particulièrement efficace pour les éléments de structure (murs, piliers) et les petits débris au sol qui ne nécessitent pas d'interactions complexes.",
        type: InfoType.idea,
      ),
      QuizModule(
        id: '2_p3_quiz',
        question:
            "Quel est le principal bénéfice technique de l'utilisation des Instanced Static Meshes (ISM) par rapport aux Static Meshes classiques ?",
        options: [
          "Ils permettent de changer la forme de l'objet",
          "Ils réduisent le nombre de Draw Calls envoyés au processeur graphique",
          "Ils augmentent la résolution des textures",
          "Ils permettent d'animer les objets plus facilement",
        ],
        correctIndices: [1],
        explanation:
            "En regroupant les objets identiques, le moteur réduit le nombre d'ordres individuels envoyés au GPU, ce qui booste les performances.",
      ),
      TitleModule(id: '2_p4_title', title: "Foliage Tool"),
      InfoModule(
        id: '2_p4_obj',
        text:
            "Utiliser les outils de peinture de végétation pour créer des écosystèmes organiques denses et optimisés.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '2_p4_nature',
        title: "Peindre la Nature",
        content:
            "Le Foliage Tool est l'outil de prédilection pour peupler rapidement de vastes zones avec des milliers d'objets. Techniquement, il s'appuie sur le système d'instanciation (ISM) : il permet de \"peindre\" des forêts ou des prairies entières tout en conservant une fluidité de rendu exceptionnelle.",
      ),
      SideBySideModule(
        id: '2_p4_ui',
        title: "L'Interface et les Assets de Foliage",
        content:
            "Pour accéder à l'outil, passez en mode Foliage (Maj + 3). Lorsque vous glissez un Static Mesh dans la zone de dépôt, Unreal l'enveloppe dans un asset spécifique appelé Static Mesh Foliage. Cet objet devient alors le conteneur de toutes les règles de génération (densité, échelle, rayon) propres à cet élément.",
        imagePath: 'assets/images/foliage_mode_ui.jpg',
        caption:
            "Dépôt d'assets et création automatique des Static Mesh Foliage",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p4_indep_info',
        text:
            "Chaque asset de type Static Mesh Foliage est indépendant. Cela signifie que vous pouvez régler une densité très élevée pour votre herbe tout en gardant un espacement large pour vos arbres au sein du même outil.",
        type: InfoType.info,
      ),
      ListModule(
        id: '2_p4_brush',
        title: "Paramètres du Pinceau (Brush)",
        intro:
            "Avant de peindre, réglez la brosse globale pour contrôler l'application :",
        items: [
          "Brush Size : Diamètre de la zone d'influence du pinceau",
          "Paint Density : Quantité d'objets déposés à chaque passage",
          "Erase Density : Permet de désépaissir une zone sans la vider totalement",
          "Filters : Détermine si le foliage s'aimante au Landscape ou aux autres Static Meshes",
        ],
        outro:
            "Travaillez par touches légères pour éviter les amas d'objets peu naturels.",
      ),
      SideBySideModule(
        id: '2_p4_random',
        title: "Randomisation et Règles de Pose",
        content:
            "Pour briser la répétitivité, ouvrez les détails de votre asset de foliage. Vous y trouverez les paramètres de variation : le Scaling (échelle min/max) et le Random Yaw (rotation aléatoire sur 360°). Ces règles sont mémorisées dans l'asset de foliage et seront appliquées à chaque nouveau coup de pinceau.",
        imagePath: 'assets/images/foliage_settings_random.jpg',
        caption:
            "Configuration des variations organiques dans l'asset de foliage",
        layout: ContentLayout.textRight,
      ),
      InfoModule(
        id: '2_p4_normal_tip',
        text:
            "Activez l'option Align to Normal pour que vos plantes suivent l'inclinaison du terrain, ou désactivez-la pour forcer vos arbres à pousser toujours vers le haut, indépendamment de la pente.",
        type: InfoType.tip,
      ),
      InfoModule(
        id: '2_p4_culling_warn',
        text:
            "La densité excessive est l'ennemi de la performance. Utilisez systématiquement la Cull Distance (Distance d'affichage) dans les réglages de l'asset. Cela permet de faire disparaître progressivement la végétation lointaine pour soulager votre carte graphique.",
        type: InfoType.warning,
      ),
      InfoModule(
        id: '2_p4_reapply_idea',
        text:
            "Si vous changez les règles de génération dans votre asset de foliage, utilisez l'outil Reapply pour mettre à jour instantanément les instances déjà peintes dans votre scène.",
        type: InfoType.idea,
      ),
      SideBySideModule(
        id: '2_p4_geometry',
        title: "Peindre sur des Géométries",
        content:
            "Le Foliage peut être appliqué sur n'importe quel support. En activant le filtre \"Static Mesh\", vous pouvez peindre de la mousse, du lierre ou des débris directement sur des rochers ou des parois rocheuses, créant une fusion parfaite entre le terrain et les objets posés.",
        imagePath: 'assets/images/foliage_on_meshes.jpg',
        caption: "Application de végétation sur des surfaces verticales",
        layout: ContentLayout.textLeft,
      ),
      QuizModule(
        id: '2_p4_quiz',
        question:
            "Où sont stockées les règles spécifiques de densité et d'échelle pour un élément de végétation ?",
        options: [
          "Dans le menu général du Viewport",
          "Dans l'asset de type Static Mesh Foliage",
          "Directement sur le Landscape",
          "Dans les paramètres du projet",
        ],
        correctIndices: [1],
        explanation:
            "L'asset Static Mesh Foliage sert de \"cerveau\" à l'outil pour savoir comment chaque plante doit être distribuée.",
      ),
      TitleModule(
        id: '2_p5_title',
        title: "Spline Meshes & Outils Curvilignes",
      ),
      InfoModule(
        id: '2_p5_obj',
        text:
            "Maîtriser l'utilisation des courbes de spline au sein d'un Blueprint Actor pour placer et déformer des assets le long d'un tracé complexe.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '2_p5_curve',
        title: "La Géométrie de la Courbe",
        content:
            "Dans Unreal Engine, une Spline est une ligne mathématique invisible composée de points de contrôle. Pour l'utiliser, elle doit être intégrée dans un Blueprint Actor (un objet programmable). C'est ce conteneur qui permet d'afficher la courbe dans le Viewport et de lui donner une fonction concrète, comme générer des rails ou des câbles électriques qui suivent un tracé sinueux.",
      ),
      SideBySideModule(
        id: '2_p5_actor',
        title: "Le Blueprint comme Conteneur",
        content:
            "Pour manipuler une spline, on utilise un Blueprint de type Actor contenant un composant Spline. Une fois cet acteur glissé dans votre scène, vous devez sélectionner le composant Spline dans le panneau Details (ou directement dans le Viewport) pour pouvoir éditer ses points et modifier sa trajectoire.",
        imagePath: 'assets/images/spline_blueprint_actor.jpg',
        caption:
            "Sélection du composant Spline à l'intérieur d'un Blueprint Actor",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p5_script_info',
        text:
            "Le \"cerveau\" de cet outil se trouve dans le Construction Script du Blueprint. Sans entrer dans le code, sachez que c'est ici que l'on définit si le mesh doit s'étirer ou se répéter le long de la ligne.",
        type: InfoType.info,
      ),
      SideBySideModule(
        id: '2_p5_anatomy',
        title: "Anatomie et Manipulation",
        content:
            "Chaque point de la spline possède des Tangentes (poignées blanches) pour définir la courbure. En sélectionnant un point et en maintenant la touche Alt lors d'un déplacement, vous \"extrayez\" un nouveau segment. Cela permet de dessiner des tracés complexes très rapidement.",
        imagePath: 'assets/images/spline_tangents.jpg',
        caption:
            "Manipulation des points de contrôle et des tangentes dans le Viewport",
        layout: ContentLayout.textRight,
      ),
      ListModule(
        id: '2_p5_cases',
        title: "Cas d'usage en Production",
        intro:
            "Les splines résolvent des problèmes de placement impossibles à gérer à la main :",
        items: [
          "Éléments répétitifs : Clôtures, bordures de trottoir, haies de jardin",
          "Éléments étirés : Tuyauteries, câbles haute tension, lianes",
          "Éléments de structure : Rails de chemin de fer, ponts suspendus, routes",
        ],
        outro:
            "La spline garantit une continuité parfaite sans \"trous\" entre les segments de géométrie.",
      ),
      SideBySideModule(
        id: '2_p5_stretch',
        title: "Stretch vs Repeat",
        content:
            "Selon la logique du Blueprint, le mesh peut se comporter de deux façons. Le mode Stretch étire un seul mesh entre deux points (pour un câble). Le mode Repeat multiplie le mesh autant de fois que nécessaire le long de la ligne (pour des rails ou des pavés).",
        imagePath: 'assets/images/spline_stretch_repeat.jpg',
        caption:
            "Différence entre un mesh étiré et un mesh répété sur une courbe",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p5_axis_tip',
        text:
            "Si votre mesh semble tordu, vérifiez le paramètre Forward Axis dans les détails de votre acteur. Il définit quel axe de votre objet (X, Y ou Z) doit pointer vers le point suivant de la courbe.",
        type: InfoType.tip,
      ),
      InfoModule(
        id: '2_p5_artifact_warn',
        text:
            "Une spline trop tortueuse sur un mesh très complexe peut créer des artefacts visuels (étirements bizarres). Privilégiez des assets avec un maillage bien réparti pour les courbes serrées.",
        type: InfoType.warning,
      ),
      InfoModule(
        id: '2_p5_camera_idea',
        text:
            "En plus de la géométrie, vous pouvez transformer une spline en chemin de caméra ! C'est une méthode parfaite pour créer des travellings complexes et ultra-fluides.",
        type: InfoType.idea,
      ),
      TextModule(
        id: '2_p5_pcg_intro',
        title: "Ouverture : Splines et Génération Procédurale (PCG)",
        content:
            "Bien que nous utilisions ici les splines manuellement, sachez qu'elles deviennent surpuissantes lorsqu'elles servent de guides au PCG (Procedural Content Generation). Une spline peut définir une \"zone d'influence\" : par exemple, vous dessinez un sentier, et le système PCG se charge de supprimer automatiquement les arbres et de placer des petits cailloux uniquement le long de cette ligne.",
      ),
      QuizModule(
        id: '2_p5_quiz',
        question:
            "Quel est l'élément indispensable pour pouvoir manipuler et éditer une spline dans le Viewport d'Unreal ?",
        options: [
          "Un simple clic droit dans le vide",
          "Un Blueprint Actor contenant un composant Spline",
          "Un fichier texte externe",
          "Une texture de masque",
        ],
        correctIndices: [1],
        explanation:
            "La spline est un composant qui nécessite un acteur parent pour exister et interagir avec le monde.",
      ),
      TitleModule(id: '2_p6_title', title: "Nanite (Théorie & Optimisation)"),
      InfoModule(
        id: '2_p6_obj',
        text:
            "Comprendre la technologie de virtualisation de géométrie pour lever les limites de polygones et optimiser vos scènes cinématiques.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '2_p6_rev',
        title: "La Révolution de la Géométrie Virtualisée",
        content:
            "Avant Unreal Engine 5, chaque polygone affiché à l'écran coûtait de la performance. Les artistes devaient passer des heures à créer des versions simplifiées de leurs modèles (LODs). Nanite change la donne en traitant la géométrie comme une texture : il n'affiche que le nombre de détails nécessaires pour chaque pixel de votre écran, permettant d'utiliser des assets de plusieurs millions de polygones sans ralentissement.",
      ),
      SideBySideModule(
        id: '2_p6_clusters',
        title: "Comment fonctionne Nanite ?",
        content:
            "Nanite découpe intelligemment vos objets en \"clusters\" de triangles. En temps réel, il décide quels clusters doivent être affichés avec une précision chirurgicale et lesquels peuvent être simplifiés car ils sont loin ou petits à l'écran. C'est un système de LOD automatique et continu.",
        imagePath: 'assets/images/nanite_clusters_view.jpg',
        caption: "Visualisation des clusters Nanite s'adaptant à la distance",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p6_limit_info',
        text:
            "Avec Nanite, la limite n'est plus le nombre de polygones affichés à l'écran, mais souvent la vitesse de votre disque dur (pour charger les données) et la mémoire vidéo (VRAM).",
        type: InfoType.info,
      ),
      ListModule(
        id: '2_p6_when',
        title: "Quand activer Nanite ?",
        intro:
            "Pour optimiser votre scène, n'activez Nanite que là où il est utile :",
        items: [
          "OUI (Recommandé) : Rochers massifs, falaises, statues détaillées, architecture complexe, troncs d'arbres.",
          "NON (Inutile) : Objets très simples (un cube, une vitre plate), objets transparents complexes, ou très petits débris invisibles.",
        ],
        outro:
            "Activer Nanite sur un simple cube de 6 faces peut paradoxalement consommer plus de ressources qu'un Static Mesh classique.",
      ),
      SideBySideModule(
        id: '2_p6_enable',
        title: "Activation et Conversion",
        content:
            "Vous pouvez activer Nanite de deux manières : soit lors de l'importation de l'asset, soit après coup en faisant un clic droit sur le Static Mesh dans le Content Browser > Nanite > Enable. Une fois activé, l'objet est \"virtualisé\" et prêt pour un rendu ultra-détaillé.",
        imagePath: 'assets/images/enable_nanite_menu.jpg',
        caption: "Menu contextuel pour activer Nanite sur un asset existant",
        layout: ContentLayout.textRight,
      ),
      InfoModule(
        id: '2_p6_viz_tip',
        text:
            "Utilisez le mode de visualisation Nanite > Visualization > Triangles dans le Viewport pour vérifier si vos objets sont bien pris en charge. Si vous voyez des triangles colorés, Nanite est actif.",
        type: InfoType.tip,
      ),
      InfoModule(
        id: '2_p6_size_warn',
        text:
            "Un asset Nanite pèse plus lourd sur votre disque dur qu'un asset classique. C'est le prix à payer pour ne plus avoir à gérer les LODs manuellement. Surveillez l'espace disque de votre projet lors de l'utilisation massive de Megascans 8K.",
        type: InfoType.warning,
      ),
      SideBySideModule(
        id: '2_p6_foliage',
        title: "Nanite et le Foliage",
        content:
            "Longtemps limité aux objets opaques, Nanite supporte désormais la végétation (Programmable Rasterizer). Cela permet d'afficher des forêts denses où chaque feuille est modélisée en 3D, à condition d'activer l'option \"Preserve Area\" dans les réglages de l'asset pour éviter que les feuilles ne disparaissent au loin.",
        imagePath: 'assets/images/nanite_foliage_detail.jpg',
        caption: "Rendu de végétation haute densité grâce à Nanite",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p6_macro_idea',
        text:
            "Si vous travaillez sur une cinématique de très près (Macro), Nanite est indispensable pour éviter de voir les \"facettes\" des polygones sur vos objets, garantissant une silhouette parfaitement lisse.",
        type: InfoType.idea,
      ),
      QuizModule(
        id: '2_p6_quiz',
        question:
            "Quel est le principal avantage de Nanite pour un artiste 3D ?",
        options: [
          "Il permet de peindre des textures plus vite",
          "Il supprime le besoin de créer manuellement des niveaux de détails (LODs) simplifiés",
          "Il rend les objets invisibles",
          "Il remplace le système de lumière",
        ],
        correctIndices: [1],
        explanation:
            "Nanite gère dynamiquement la complexité géométrique, permettant d'utiliser des modèles haute résolution directement en production.",
      ),
      TitleModule(id: '2_p7_title', title: "Introduction au PCG"),
      InfoModule(
        id: '2_p7_obj',
        text:
            "Apprendre à utiliser les outils de génération procédurale pour peupler vos environnements et comprendre pourquoi le PCG représente l'avenir du World Building.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '2_p7_evol',
        title: "L'Évolution du World Building",
        content:
            "Le PCG (Procedural Content Generation) marque une rupture technologique majeure. Jusqu'ici, nous placions des objets à la main ou le long de tracés (Splines). Avec le PCG, nous passons à une \"architecture de règles\". Au lieu de manipuler des objets, vous manipulez une logique qui décide où, comment et en quelle quantité les éléments doivent apparaître.",
      ),
      SideBySideModule(
        id: '2_p7_graph',
        title: "Le PCG Graph : Le Cerveau du Système",
        content:
            "Le cœur du système est le PCG Graph. Dans cette interface nodale, vous créez une recette visuelle. Un nœud récupère les données du sol, un autre filtre les zones trop pentues, et le dernier distribue les assets. Cette approche est totalement non-destructive : changez la forme de votre terrain, et le décor se régénère instantanément.",
        imagePath: 'assets/images/pcg_graph_nodes.jpg',
        caption:
            "Interface de programmation visuelle pour la génération de contenu",
        layout: ContentLayout.textLeft,
      ),
      SideBySideModule(
        id: '2_p7_perf',
        title: "Spline Mesh vs PCG : Le Saut de Performance",
        content:
            "Bien que les Spline Meshes soient utiles, ils deviennent lourds car ils \"déforment\" souvent la géométrie pour suivre la courbe, ce qui pèse sur le GPU. Le PCG, lui, utilise exclusivement des Instances parfaites. Il ne déforme rien : il place des milliers d'objets à une vitesse fulgurante avec un coût de calcul quasi nul, ce qui en fait l'outil standard pour les productions \"Next-Gen\".",
        imagePath: 'assets/images/spline_vs_pcg.jpg',
        caption:
            "Comparaison entre le placement linéaire par spline et la distribution intelligente PCG",
        layout: ContentLayout.textRight,
      ),
      ListModule(
        id: '2_p7_future',
        title: "Pourquoi le PCG est l'Avenir ?",
        intro:
            "Le PCG offre des possibilités impossibles avec les anciennes méthodes :",
        items: [
          "Intelligence spatiale : Le PCG \"sait\" s'il est sur de l'herbe ou du rocher et adapte les assets en conséquence.",
          "Gestion de collisions : Les objets générés peuvent s'éviter entre eux automatiquement.",
          "Complexité infinie : Vous pouvez peupler des kilomètres carrés avec la même facilité qu'un petit jardin.",
          "Scalabilité : C'est la technologie utilisée par les plus grands studios pour créer des mondes massifs et vivants.",
        ],
        outro:
            "Là où la Spline est un outil de tracé, le PCG est un écosystème complet.",
      ),
      InfoModule(
        id: '2_p7_spline_info',
        text:
            "La Spline ne disparaît pas pour autant ! Dans un workflow moderne, on utilise souvent une Spline comme entrée pour un graphe PCG. Elle peut tracer un chemin linéaire, mais aussi définir des aires de génération précises.",
        type: InfoType.info,
      ),
      SideBySideModule(
        id: '2_p7_volume',
        title: "Le PCG Volume et le Sampling",
        content:
            "Pour activer la génération, on place un PCG Volume. Le moteur effectue alors un \"Sampling\" (échantillonnage) : il projette une grille de points sur votre décor. Chaque point récolte des informations (inclinaison, altitude) pour savoir s'il doit accueillir un arbre, un buisson ou rester vide.",
        imagePath: 'assets/images/pcg_sampling_points.jpg',
        caption: "Visualisation des points de calcul du PCG sur le Landscape",
        layout: ContentLayout.textLeft,
      ),
      InfoModule(
        id: '2_p7_noise_tip',
        text:
            "Pour un rendu naturel, utilisez toujours un nœud de Density Noise dans votre graphe. Cela permet de créer des clairières et des zones denses de manière aléatoire, évitant l'aspect \"grille\" trop parfait.",
        type: InfoType.tip,
      ),
      InfoModule(
        id: '2_p7_debug_warn',
        text:
            "Le PCG est puissant mais demande de la rigueur. Un graphe mal optimisé qui génère trop de points peut ralentir l'éditeur. Utilisez le mode Debug pour voir vos points de génération avant de charger des meshes lourds.",
        type: InfoType.warning,
      ),
      InfoModule(
        id: '2_p7_brush_idea',
        text:
            "Imaginez le PCG comme un pinceau intelligent : au lieu de peindre chaque brin d'herbe, vous définissez les règles de croissance de toute une forêt.",
        type: InfoType.idea,
      ),
      QuizModule(
        id: '2_p7_quiz',
        question:
            "Pourquoi l'utilisation du PCG est-elle généralement plus performante que celle des Spline Meshes pour peupler de grandes zones ?",
        options: [
          "Parce que le PCG utilise des textures plus petites",
          "Parce que le PCG utilise des instances non-déformées au lieu de géométries étirées",
          "Parce qu'il fonctionne sans carte graphique",
          "Parce qu'il supprime les lumières",
        ],
        correctIndices: [1],
        explanation:
            "L'instanciation pure du PCG est beaucoup plus légère pour le GPU que la déformation de maillage requise par les Spline Meshes.",
      ),
      TitleModule(id: '2_ex_title', title: "Création d'un Micro-Biome"),
      InfoModule(
        id: '2_ex_obj',
        text:
            "Valider les acquis sur le World Building en créant une scène optimisée combinant sculpture, outils curvilignes et génération procédurale.",
        type: InfoType.objective,
      ),
      InfoModule(
        id: '2_ex_duration',
        text: "Durée estimée : 40 minutes",
        type: InfoType.info,
      ),
      TextModule(
        id: '2_ex_consigne',
        title: "Consigne Générale",
        content:
            "Vous devez créer une petite scène d'environ 50 mètres carrés représentant un \"sentier sauvage\". L'enjeu est de démontrer votre capacité à utiliser les outils automatiques (PCG, Foliage) pour habiller un relief sculpté manuellement, tout en garantissant des performances optimales via Nanite.",
      ),
      ListModule(
        id: '2_ex_step1',
        title: "Étape 1 : Fondation et Sculpture (10 min)",
        intro: "Commencez par poser la base de votre monde :",
        items: [
          "Création : Créez un nouveau Landscape de petite taille (63x63 sections suffisent).",
          "Sculpt : Activez les Edit Layers et sculpez un léger vallon avec un chemin creux au centre.",
          "Finition : Utilisez l'outil Smooth pour rendre les bords du chemin naturels.",
        ],
        outro: "Objectif : Maîtriser le relief sans aborder les matériaux.",
      ),
      ListModule(
        id: '2_ex_step2',
        title: "Étape 2 : Structure et Précision (5 min)",
        intro: "Placez les éléments \"héros\" de votre scène :",
        items: [
          "Placement : Importez un asset de structure (ex: une arche ou une ruine) via Fab.",
          "Snapping : Utilisez le Vertex Snapping (touche V) pour aligner parfaitement deux éléments de décor.",
          "Snap to Floor : Utilisez la touche Fin pour poser vos premiers rochers sur le relief sculpté.",
        ],
        outro: "Objectif : Précision du blocage.",
      ),
      ListModule(
        id: '2_ex_step3',
        title: "Étape 3 : Optimisation Nanite (5 min)",
        intro: "Assurez-vous que votre scène est \"Next-Gen ready\" :",
        items: [
          "Activation : Sélectionnez tous vos Static Meshes de rochers et activez Nanite (clic droit > Nanite > Enable).",
          "Vérification : Basculez le Viewport en mode Nanite Visualization > Triangles pour confirmer que la virtualisation est active.",
          "Instances : Vérifiez dans votre Outliner que vos objets dupliqués sont bien gérés comme des instances.",
        ],
        outro: "Objectif : Compréhension de la performance.",
      ),
      ListModule(
        id: '2_ex_step4',
        title: "Étape 4 : Éléments Curvilignes (5 min)",
        intro: "Tracez la direction de votre scène :",
        items: [
          "Spline : Glissez un Blueprint de type Spline (ex: une barrière ou un garde-corps) dans la scène.",
          "Tracé : Dessinez une courbe qui suit le bord de votre chemin sculpté en ajoutant des points avec Alt + Drag.",
        ],
        outro: "Objectif : Utilisation des outils de tracé.",
      ),
      ListModule(
        id: '2_ex_step5',
        title: "Étape 5 : Le Système PCG (10 min)",
        intro: "Automatisez le remplissage de votre zone :",
        items: [
          "Volume : Placez un PCG Volume englobant votre chemin.",
          "Graphe Simple : Créez un PCG Graph basique qui récupère les données du Landscape (Surface Sampler).",
          "Distribution : Utilisez un nœud Static Mesh Spawner pour distribuer de petits cailloux ou des débris uniquement à l'intérieur du volume.",
          "Random : Appliquez une variation d'échelle et de rotation dans le graphe.",
        ],
        outro: "Objectif : Mise en pratique simple de la logique procédurale.",
      ),
      ListModule(
        id: '2_ex_step6',
        title: "Étape 6 : Finition au Foliage (5 min)",
        intro: "Apportez la touche finale organique :",
        items: [
          "Peinture : Utilisez le Foliage Tool pour ajouter des touffes d'herbe de manière hétérogène.",
          "Culling : Réglez une Cull Distance sur vos assets de végétation pour optimiser le rendu.",
        ],
        outro: "Objectif : Complémentarité entre manuel et automatique.",
      ),
      InfoModule(
        id: '2_ex_pcg_tip',
        text:
            "Pour le PCG, ne cherchez pas la complexité. Un simple \"Surface Sampler\" connecté à un \"Transform Points\" (pour la rotation) puis à un \"Static Mesh Spawner\" suffit pour valider l'exercice.",
        type: InfoType.info,
      ),
      QuizModule(
        id: '2_ex_quiz',
        question:
            "Quel outil devriez-vous utiliser pour peupler instantanément 1 km² de forêt avec des règles de collision ?",
        options: [
          "Le Placement Manuel",
          "Le Foliage Tool",
          "Le PCG (Procedural Content Generation)",
          "La Touche End",
        ],
        correctIndices: [2],
        explanation:
            "Le PCG est l'outil le plus puissant et le plus optimisé pour les générations massives basées sur des règles logiques.",
      ),
    ],
  ),
  SessionModel(
    id: 3,
    title: 'Shading & Maîtrise des Matériaux',
    objective:
        "Comprendre l'architecture des surfaces dans Unreal Engine 5 pour donner une intention artistique précise, optimisée et interactive à vos scènes.",
    icon: Icons.texture_rounded,
    technicalPoints: [
      "L'Écosystème des Matériaux (Master vs Instance)",
      "Anatomie d'un Matériau (Le nœud de résultat)",
      "Le Système Nodal & l'Éditeur de Matériaux",
      "Propreté et Lisibilité du Graphe (Commentaires & Reroutes)",
      "Intégration et Gestion des Textures",
      "Gestion des Normal Maps (DirectX vs OpenGL)",
      "Logique et Mathématiques Visuelles (Lerp & Masques)",
      "Effets Avancés de Surface (Fresnel & Émissif)",
      "Coordonnées de Texture (UVs, Tiling et Rotation)",
      "Projection Triplanaire (World Aligned)",
      "Animation de Matériaux (Panner)",
      "Displacement de Surface avec Nanite",
      "Modularité et Fonctions de Matériaux (Material Functions)",
      "Exposition et Organisation des Paramètres (Groupes)",
      "Application Pratique sur le Terrain",
    ],
    filRouge:
        "Concevoir le matériau maître d'exploration de notre scène, optimiser et intégrer ses textures ORM et ses Normal Maps, implémenter une projection triplanaire animée, et organiser l'interface d'instance pour habiller dynamiquement nos décors (roche, métal et feuillage).",
    modules: [
      TitleModule(
        id: '3_ecosystem',
        title: "1. L'Écosystème des Matériaux (Master vs Instance)",
      ),
      InfoModule(
        id: '3_ecosystem_obj',
        text:
            "Adopter une philosophie de travail non-destructive et optimisée grâce au couple Master / Instance.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_ecosystem_text',
        title: "La philosophie du workflow non-destructif",
        content:
            "Dans Unreal Engine, la création d'un matériau nécessite une phase de compilation lourde : le moteur traduit vos nœuds graphiques en code HLSL (High-Level Shader Language) lisible par la carte graphique. Compiler un matériau à chaque modification ralentit considérablement la production et surcharge la mémoire.\nPour contourner cette limite, les professionnels utilisent une architecture parent-enfant : un Master Material (Matériau Maître) unique pilote la logique mathématique, tandis que ses Material Instances (Instances) adaptent les propriétés visuelles en temps réel sans aucune phase de recompilation.",
      ),
      SideBySideModule(
        id: '3_ecosystem_sbs',
        title: "Architecture Parent-Enfant",
        content:
            "Le Master Material (M_) concentre toute la complexité technique (calculs de coordonnées, masques, logique de rendu) et expose des variables sous forme de paramètres. Le Material Instance (MI_) hérite de cette logique et permet à l'artiste de modifier instantanément les textures, couleurs ou valeurs numériques depuis une interface simplifiée.",
        imagePath: 'assets/images/master_instance_architecture.png',
        layout: ContentLayout.textLeft,
        caption:
            "Schéma fonctionnel du transfert de logique du Master (M_) vers l'Instance (MI_)",
      ),
      ListModule(
        id: '3_ecosystem_list',
        title: "Les Règles d'Or de l'Écosystème",
        intro:
            "Mettre en place de bonnes habitudes de nommage et de structure dès le début du projet :",
        items: [
          "Préfixe M_ : Identifie vos matériaux maîtres (ex : M_Surface_Master)",
          "Préfixe MI_ : Identifie vos instances (ex : MI_Rock_Cliff)",
          "Exposition systématique : Convertissez toute valeur sujette à modification en paramètre modifiable (couleur, rugosité, échelle)",
          "Principe de spécialisation : Ne créez pas un seul matériau maître universel géant. Séparez vos maîtres par grandes catégories physiques (ex : Opaque, Translucide/Verre, Feuillage, Eau)",
        ],
        outro:
            "Ce fonctionnement garantit un taux de rafraîchissement élevé (FPS) lors du développement de votre jeu.",
      ),
      InfoModule(
        id: '3_ecosystem_tip',
        text:
            "Pour transformer instantanément une valeur fixe en paramètre modifiable, faites un clic droit sur le nœud concerné dans le graphe (ex: un nœud Constant ou Constant3Vector) et cliquez sur Convert to Parameter.",
        type: InfoType.tip,
      ),
      TitleModule(
        id: '3_anatomy',
        title: "2. Anatomie d'un Matériau (Le Nœud de Résultat)",
      ),
      InfoModule(
        id: '3_anatomy_obj',
        text:
            "Décoder les canaux d'entrée du nœud principal et configurer la carte d'identité globale d'une surface.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_anatomy_text',
        title: "Configurer la carte d'identité de votre shader",
        content:
            "Lorsque vous créez un nouveau matériau, un nœud imposant trône au centre de votre graphe. C'est le Nœud de Résultat Final. Avant d'y connecter la moindre texture, vous devez configurer le comportement de votre shader dans le panneau Details à gauche.",
      ),
      ListModule(
        id: '3_anatomy_list',
        title: "Paramètres globaux du panneau Details",
        intro:
            "Ces réglages modifient directement les canaux d'entrée actifs sur votre nœud de résultat :",
        items: [
          "Material Domain : Détermine la destination finale du matériau. \"Surface\" est réservé aux objets 3D du monde, \"User Interface\" sert au HUD et aux menus, et \"Post Process\" s'applique aux effets de caméra globaux",
          "Blend Mode : Gère la transparence. Utilisez \"Opaque\" pour les éléments pleins (pierre, bois), \"Masked\" pour le tout-ou-rien (grillage, feuillage via un masque binaire), et \"Translucent\" pour la transparence graduelle (verre, eau)",
          "Shading Model : Définit la réaction physique à la lumière. \"Default Lit\" est le modèle physique standard (PBR). \"Unlit\" annule l'ombrage (idéal pour les interfaces ou les effets de néons). \"Subsurface\" simule la pénétration lumineuse à l'intérieur de l'objet (peau, cire, feuilles d'arbres)",
          "Two-Sided : Permet de rendre le matériau visible sur les deux côtés d'un polygone. Indispensable pour éviter que l'arrière des plantes ou des tissus ne disparaisse à l'écran",
          "Refraction Method : Détermine la technique de déviation optique pour les surfaces translucides afin de simuler l'indice de réfraction réel (IOR)",
        ],
        outro:
            "Modifier ces caractéristiques structurelles change dynamiquement la liste des pins actifs sur votre nœud de résultat.",
      ),
      TitleModule(
        id: '3_editor',
        title: "3. Le Système Nodal & l'Éditeur de Matériaux",
      ),
      InfoModule(
        id: '3_editor_obj',
        text:
            "Prendre en main l'interface graphique de l'éditeur et connecter logiquement vos premières données.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_editor_text',
        title: "L'interface visuelle du Material Editor",
        content:
            "L'éditeur de matériaux d'Unreal Engine 5 est un environnement nodal. Au lieu d'écrire du code textuel complexe, vous interconnectez des nœuds graphiques qui représentent des données physiques ou des formules mathématiques.",
      ),
      ListModule(
        id: '3_editor_list',
        title: "Les types de données fondamentaux",
        intro:
            "Pour piloter vos matériaux, vous manipulerez principalement trois formats de données :",
        items: [
          "Scalar (Float) : Une valeur numérique simple (ex : 0.5 pour définir une rugosité moyenne). Raccourci clavier : Maintenez 1 + clic gauche",
          "Vector 2 : Deux valeurs liées (ex : coordonnées U et V pour étirer une texture). Raccourci : Maintenez 2 + clic gauche",
          "Vector 3 (RGB) : Trois valeurs liées (ex : coordonnées spatiales X,Y,Z ou couleur Rouge, Vert, Bleu). Raccourci : Maintenez 3 + clic gauche",
        ],
        outro:
            "Vous ne pouvez connecter que des types de données compatibles entre eux pour éviter les erreurs de compilation.",
      ),
      TitleModule(
        id: '3_cleanliness',
        title: "4. Propreté et Lisibilité du Graphe (Commentaires & Reroutes)",
      ),
      InfoModule(
        id: '3_cleanliness_obj',
        text:
            "Adopter des méthodes de travail professionnelles pour éliminer les \"nœuds spaghettis\".",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_cleanliness_text',
        title: "L'importance d'un graphe propre",
        content:
            "En production, un matériau maître peut rapidement compter des dizaines, voire des centaines de nœuds. Sans discipline de rangement, votre code visuel devient illisible pour vous-même et pour vos collaborateurs. Unreal Engine intègre des outils dédiés à la clarté visuelle.",
      ),
      SideBySideModule(
        id: '3_cleanliness_sbs',
        title: "Structure et Lisibilité",
        content:
            "La structuration logique de vos connexions est aussi importante que la justesse de vos calculs. Alignez vos alignements de nœuds et commentez vos blocs logiques pour accélérer le débogage.",
        imagePath: 'assets/images/organized_material_graph.png',
        layout: ContentLayout.textRight,
        caption: "Aperçu d'un graphe de production aéré, rangé et sectorisé",
      ),
      ListModule(
        id: '3_cleanliness_list',
        title: "Les trois outils d'hygiène du graphe",
        intro:
            "Prenez le réflexe d'organiser votre travail en utilisant ces fonctionnalités au quotidien :",
        items: [
          "Les boîtes de commentaires (C) : Sélectionnez un groupe de nœuds logiquement liés, appuyez sur la touche C, et donnez un nom clair à la boîte (ex : \"Normal Map Offset\"). Vous pouvez également ajuster sa couleur de fond",
          "Les Reroute Nodes : Double-cliquez sur n'importe quel fil de connexion actif pour créer un point d'ancrage mobile. Cela vous permet de contourner proprement les blocs de nœuds sans couper le flux",
          "Les Named Reroute Nodes : Créez un nœud de sortie nommé (ex : \"AO_Value\") puis rappelez-le à n'importe quel autre endroit du graphe. Cela permet de téléporter l'information sans tirer de longs câbles croisés visibles à l'écran.",
        ],
        outro:
            "Un graphe lisible est le signe distinctif d'un artiste technique professionnel.",
      ),
      TitleModule(
        id: '3_textures',
        title: "5. Intégration et Gestion des Textures",
      ),
      InfoModule(
        id: '3_textures_obj',
        text:
            "Importer efficacement vos fichiers et exploiter la puissance des textures composites ORM.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_textures_text',
        title: "Comprendre les textures PBR et le packing ORM",
        content:
            "Unreal Engine accepte la majorité des formats d'image courants (.PNG, .TGA, .EXR). Lors de l'import, le moteur encapsule la texture dans un nœud Texture Sample. Pour optimiser les ressources matérielles de la carte graphique, les studios modernes condensent plusieurs informations monochromes dans une seule texture couleur. C'est la technique du packing ORM.",
      ),
      SideBySideModule(
        id: '3_textures_sbs',
        title: "Le fonctionnement de la texture ORM",
        content:
            "Plutôt que d'importer trois textures d'ajustement distinctes, nous combinons les données d'Occlusion, de Roughness et de Metallic dans les canaux de couleur Rouge, Vert et Bleu d'un fichier unique.",
        imagePath: 'assets/images/orm_packing_channels.png',
        layout: ContentLayout.textLeft,
        caption:
            "Découpage des masques d'une texture ORM selon ses canaux R, G et B",
      ),
      ListModule(
        id: '3_textures_list',
        title: "L'anatomie d'une texture ORM",
        intro:
            "L'ordre des données au sein des canaux physiques respecte une nomenclature stricte :",
        items: [
          "Canal Rouge (R) : Contient l'Ambient Occlusion (AO) qui définit l'ombrage passif dans les micro-creux",
          "Canal Vert (G) : Contient la Roughness (Rugosité) qui contrôle la netteté et la diffusion des reflets",
          "Canal Bleu (B) : Contient la Metallic (Métallicité) qui détermine si la surface se comporte comme un métal (1) ou un non-métal (0)",
        ],
        outro:
            "L'utilisation de cette méthode réduit de deux tiers les requêtes mémoire d'échantillonnage de textures.",
      ),
      InfoModule(
        id: '3_textures_warn',
        text:
            "Pour toute texture composite (comme l'ORM) ou masque mathématique ne représentant pas une couleur visible, vous devez impérativement décocher la case sRGB dans son panneau d'importation sous Unreal Engine, et vous assurer que son \"Sampler Type\" est bien réglé sur Data ou Linear Color dans votre matériau. Si vous oubliez cette étape, le moteur appliquera une correction de gamma erronée qui faussera vos calculs physiques !",
        type: InfoType.warning,
      ),
      TitleModule(
        id: '3_normals',
        title: "6. Gestion des Normal Maps (DirectX vs OpenGL)",
      ),
      InfoModule(
        id: '3_normals_obj',
        text:
            "Identifier et corriger instantanément un problème de relief inversé à l'écran.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_normals_text',
        title: "Le conflit de standards des cartes de normales",
        content:
            "Les Normal Maps utilisent des vecteurs de couleur pour modifier virtuellement l'orientation de la lumière à la surface d'un maillage, donnant l'illusion d'un relief 3D complexe. Cependant, deux standards industriels concurrents s'affrontent sur l'orientation du relief vertical (canal Vert) : DirectX et OpenGL.",
      ),
      ListModule(
        id: '3_normals_list',
        title: "Différences et diagnostic",
        intro: "Apprenez à identifier le standard utilisé par votre texture :",
        items: [
          "DirectX : Le standard natif d'Unreal Engine. Le canal Vert (axe Y) simule une lumière orientée vers le bas",
          "OpenGL : Le standard utilisé par des logiciels comme Blender ou Unity. Le canal Vert pointe vers le haut",
          "Le symptôme : Si une texture de briques ou de roche affiche des creux qui semblent ressortir sous forme de bosses absurdes, votre texture est au format OpenGL.",
        ],
        outro:
            "Heureusement, vous n'avez pas besoin de réexporter votre texture depuis votre outil d'édition d'origine.",
      ),
      InfoModule(
        id: '3_normals_info',
        text:
            "Pour corriger une Normal Map inversée, ouvrez le fichier de texture directement dans Unreal Engine, localisez l'option Flip Green Channel dans la section \"Texture\" du panneau Details, et cochez-la. Le moteur inversera mathématiquement l'axe Y pour le rendre compatible avec l'UE5.",
        type: InfoType.info,
      ),
      TitleModule(
        id: '3_logic',
        title: "7. Logique et Mathématiques Visuelles (Lerp & Masques)",
      ),
      InfoModule(
        id: '3_logic_obj',
        text:
            "Assembler des variations de textures avancées en maîtrisant l'interpolation linéaire et le traitement des contrastes.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_logic_text',
        title: "Le nœud Lerp (Linear Interpolate)",
        content:
            "Le nœud Lerp (raccourci : touche L + clic) est l'un des outils mathématiques les plus puissants du Material Editor. Il permet de mélanger deux textures ou deux couleurs distinctes en se basant sur un masque en niveaux de gris branché dans son entrée Alpha.",
      ),
      ListModule(
        id: '3_logic_list',
        title: "Fonctionnement mathématique et logique",
        intro:
            "Voici comment le moteur interprète les données connectées au Lerp :",
        items: [
          "Entrée A : La couleur ou la texture qui apparaît là où le masque Alpha est totalement noir (valeur 0)",
          "Entrée B : La couleur ou la texture qui s'affiche là où le masque Alpha est totalement blanc (valeur 1)",
          "Entrée Alpha : Le masque d'interpolation (les gris intermédiaires créent un mélange progressif)",
          "Ajustement de contraste : Utilisez le nœud CheapContrast connecté en amont de votre masque pour durcir ou adoucir la transition de votre mélange.",
        ],
        outro:
            "La formule de calcul exécutée en arrière-plan par la carte graphique est la suivante : A * (1 - Alpha) + B * Alpha",
      ),
      TitleModule(
        id: '3_effects',
        title: "8. Effets Avancés de Surface (Fresnel & Émissif)",
      ),
      InfoModule(
        id: '3_effects_obj',
        text:
            "Donner de la profondeur à vos surfaces grâce aux effets d'angle de caméra et à l'auto-illumination dynamique.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_effects_text',
        title: "Le Fresnel et l'Émissif au service de Lumen",
        content:
            "Pour briser l'aspect artificiel des matériaux numériques plats, vous pouvez utiliser des techniques de rendu dynamique basées sur la physique optique et la projection lumineuse.",
      ),
      ListModule(
        id: '3_effects_list',
        title: "Les deux effets indispensables de dynamisme",
        intro:
            "Intégrez ces concepts pour donner un aspect vivant et crédible à vos décors :",
        items: [
          "L'effet Fresnel : Simule l'augmentation de la réflectivité d'une surface lorsque l'angle d'observation se rapproche de l'angle tangentiel (effet de bordure). Indispensable pour recréer le comportement de surfaces comme l'eau, le verre, ou des matières organiques comme le velours ou le duvet de la peau",
          "La propriété Émissive : Permet à un matériau d'émettre sa propre lumière. En branchant une couleur multipliée par une forte valeur (nœud Multiply) dans le canal Emissive Color, votre objet s'illuminera physiquement et projettera de la lumière indirecte en temps réel dans votre niveau grâce au système d'illumination globale Lumen.",
        ],
        outro:
            "Ces nœuds apportent instantanément un aspect haut de gamme et dynamique à vos créations.",
      ),
      TitleModule(
        id: '3_coordinates',
        title: "9. Coordonnées de Texture (UVs, Tiling et Rotation)",
      ),
      InfoModule(
        id: '3_coordinates_obj',
        text:
            "Prendre le contrôle absolu sur l'échelle, le décalage et l'orientation de vos matières.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_coordinates_text',
        title: "Manipuler l'espace UV",
        content:
            "Par défaut, une texture s'applique sur un modèle 3D en suivant les coordonnées de dépliage UV créées par le modeleur 3D. Vous pouvez intercepter et modifier ces données de coordonnées de manière dynamique au sein du shader.",
      ),
      SideBySideModule(
        id: '3_coordinates_sbs',
        title: "Contrôle du Tiling",
        content:
            "Pour modifier la répétition d'une texture (Tiling), nous appelons le nœud TextureCoordinate (touche U + clic). En le multipliant par un paramètre numérique simple, vous augmentez sa fréquence de répétition.",
        imagePath: 'assets/images/uv_tiling_logic.png',
        layout: ContentLayout.textLeft,
        caption:
            "Réseau de nœuds multipliant les coordonnées de texture pour augmenter le Tiling",
      ),
      ListModule(
        id: '3_coordinates_list',
        title: "Opérations de coordonnées avancées",
        intro:
            "Voici comment manipuler les coordonnées UV au-delà de la simple répétition :",
        items: [
          "Le Tiling : Multiplier les coordonnées UV par une valeur supérieure à 1 augmente le nombre de répétitions de la texture sur la surface",
          "L'Offset : Ajouter une valeur (nœud Add) aux coordonnées UV décale la position de la texture sur l'axe horizontal (U) ou vertical (V)",
          "La Rotation : Utilisez le nœud CustomRotator. Ce nœud prend vos coordonnées UV, un point pivot (généralement 0.5, 0.5), et une valeur d'angle pour faire pivoter proprement vos textures sur votre modèle.",
        ],
        outro:
            "Ces manipulations s'effectuent sans altérer le maillage 3D original.",
      ),
      TitleModule(
        id: '3_triplanar',
        title: "10. Projection Triplanaire (World Aligned)",
      ),
      InfoModule(
        id: '3_triplanar_obj',
        text:
            "Créer des matériaux automatiques et homogènes, totalement indépendants du dépliage UV de vos objets.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_triplanar_text',
        title: "La technique du World Alignement",
        content:
            "Sur d'immenses structures architecturales ou des éléments de décors naturels (falaises de roches, parois de grottes), l'application de textures standards via coordonnées UV montre ses limites : étirements disgracieux aux jointures, discontinuité des motifs. La projection triplanaire résout ce problème en projetant les textures directement depuis les axes mondiaux (World Space) de la scène.",
      ),
      ListModule(
        id: '3_triplanar_list',
        title: "Les outils de projection globale",
        intro:
            "Unreal Engine intègre deux nœuds spécialisés pour réaliser cette tâche complexe :",
        items: [
          "World Aligned Texture : Remplace l'échantillonnage de votre texture de couleur ou ORM standard. Il projette l'image de manière équivalente depuis le haut, le côté gauche et le côté droit",
          "World Aligned Normal : Effectue la même opération de projection géométrique tridimensionnelle sur vos Normal Maps pour assurer la cohérence des calculs d'ombrage",
          "L'avantage clé : Les textures s'alignent parfaitement d'un objet à l'autre sans couture, même si les objets sont pivotés ou redimensionnés dans l'espace",
          "L'inconvénient : Cette opération requiert trois fois plus d'appels d'échantillonnage de texture (Texture Samples) qu'un affichage classique. Utilisez-la avec parcimonie sur les objets volumineux.",
        ],
        outro:
            "C'est l'outil indispensable pour l'intégration d'assets de type mégastructures ou décors modulaires.",
      ),
      TitleModule(id: '3_panner', title: "11. Animation de Matériaux (Panner)"),
      InfoModule(
        id: '3_panner_obj',
        text:
            "Insuffler de la vie et du mouvement continu à vos textures de fluides ou d'écrans.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_panner_text',
        title: "Animer les surfaces dans le temps",
        content:
            "Pour simuler le mouvement de l'eau qui coule, de la lave en fusion, d'écrans technologiques ou du vent dans la végétation, vous devez déplacer vos coordonnées UV de manière fluide et constante.",
      ),
      ListModule(
        id: '3_panner_list',
        title: "Exploiter le nœud Panner",
        intro:
            "Le nœud Panner (touche P + clic) décale continuellement les coordonnées UV d'une texture en fonction du temps de jeu :",
        items: [
          "Connectez un nœud TextureCoordinate dans l'entrée Coordinate du Panner",
          "Renseignez les vitesses de défilement souhaitées sur les axes horizontal (Speed X) et vertical (Speed Y) dans les propriétés du nœud",
          "Pour rendre ces vitesses modifiables dynamiquement depuis vos Material Instances, utilisez le nœud Append Vector pour fusionner deux paramètres scalaires distincts et connectez le résultat dans le pin Speed de votre Panner.",
        ],
        outro:
            "Cette méthode permet d'économiser d'importantes ressources par rapport à l'utilisation de vidéos ou de séquences d'images lourdes.",
      ),
      TitleModule(
        id: '3_displacement',
        title: "12. Displacement de Surface avec Nanite",
      ),
      InfoModule(
        id: '3_displacement_obj',
        text:
            "Générer un relief géométrique réel à l'aide de vos textures de hauteur en tirant parti du système Nanite.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_displacement_text',
        title: "La révolution géométrique d'Unreal Engine 5",
        content:
            "Les anciennes méthodes lourdes de tessellation en temps réel issues de l'UE4 ont laissé place à une intégration directe avec Nanite, le moteur géométrique virtualisé de l'UE5. Vous pouvez désormais déformer physiquement la géométrie de vos objets à l'aide d'une texture de hauteur (Heightmap / Displacement map) directement au sein du shader.",
      ),
      ListModule(
        id: '3_displacement_list',
        title: "Étapes d'activation de la déformation Nanite",
        intro:
            "Pour obtenir des détails géométriques réels sans détruire vos performances de rendu :",
        items: [
          "Activez le support Nanite sur votre Static Mesh dans le Content Browser",
          "Dans les paramètres de votre matériau maître, cochez l'option d'activation du déplacement Nanite (Displacement)",
          "Reliez votre texture de hauteur monochrome à l'entrée Displacement de votre nœud de résultat final",
          "Connectez un paramètre d'amplitude pour contrôler précisément la hauteur de la déformation physique depuis votre Material Instance.",
        ],
        outro:
            "Cette technologie permet d'afficher des millions de polygones de détails géométriques réels pour un coût de performance minimal.",
      ),
      TitleModule(
        id: '3_functions',
        title: "13. Modularité et Fonctions de Matériaux (Material Functions)",
      ),
      InfoModule(
        id: '3_functions_obj',
        text:
            "Créer des bibliothèques de fonctions réutilisables pour simplifier l'organisation de vos projets.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_functions_text',
        title: "Créer ses propres nœuds réutilisables",
        content:
            "Si vous vous apercevez que vous recréez constamment la même suite de nœuds dans plusieurs matériaux différents (par exemple, un réseau calculant un tiling spécifique pour vos textures ORM), vous devez créer une Material Function (MF_).",
      ),
      SideBySideModule(
        id: '3_functions_sbs',
        title: "Modularité technique",
        content:
            "Une Material Function est un sous-graphe indépendant. En utilisant des nœuds d'entrée (Function Input) et de sortie (Function Output), vous pouvez encapsuler des calculs complexes sous la forme d'un seul et unique nœud réutilisable à l'infini par glisser-déposer dans n'importe quel autre matériau.",
        imagePath: 'assets/images/material_function_graph.png',
        layout: ContentLayout.textRight,
        caption:
            "À gauche, un calcul complexe condensé; à droite, l'unique nœud résultant réutilisable",
      ),
      InfoModule(
        id: '3_functions_tip',
        text:
            "Pour créer une fonction, faites un clic droit dans votre Content Browser et choisissez Materials > Material Function. Nommez-la toujours avec le préfixe MF_ (ex : MF_TilingAndOffset).",
        type: InfoType.tip,
      ),
      TitleModule(
        id: '3_parameters',
        title: "14. Exposition et Organisation des Paramètres (Groupes)",
      ),
      InfoModule(
        id: '3_parameters_obj',
        text:
            "Rendre vos interfaces de Material Instances ergonomiques et intuitives pour vos équipes de production.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_parameters_text',
        title: "L'ergonomie de l'interface d'instance",
        content:
            "Lorsque vous convertissez un nœud en paramètre dans votre Master Material, celui-ci s'affiche dans l'interface utilisateur de votre Material Instance. Si vous exposez de nombreux paramètres sans les organiser, l'artiste se retrouvera face à une liste désordonnée et inexploitable. Vous devez structurer votre interface de manière rigoureuse.",
      ),
      ListModule(
        id: '3_parameters_list',
        title: "Les bonnes pratiques de structuration",
        intro: "Les bonnes pratiques de structuration :",
        items: [
          "La catégorisation par Groupes : Dans les propriétés de chaque paramètre du Master Material, remplissez le champ Group. Utilisez des noms de catégories structurés avec un préfixe numérique (ex : \"01 - Base Color\", \"02 - Normal Map\", \"03 - Displacement\")",
          "La définition des priorités (Sort Priority) : Utilisez le champ \"Sort Priority\" pour ordonner précisément vos curseurs à l'intérieur d'un même groupe (les valeurs les plus petites apparaissent en haut de la liste).",
        ],
        outro:
            "Un Material Instance bien ordonné réduit les erreurs artistiques et fluidifie le travail d'intégration.",
      ),
      TitleModule(
        id: '3_application',
        title: "15. Application Pratique sur le Terrain",
      ),
      InfoModule(
        id: '3_application_obj',
        text:
            "Assigner vos créations sur vos objets 3D au sein de la bibliothèque et directement dans vos scènes.",
        type: InfoType.objective,
      ),
      TextModule(
        id: '3_application_text',
        title: "Affecter et tester vos matériaux",
        content:
            "Une fois votre Material Instance créée et configurée de manière ergonomique, il ne vous reste plus qu'à l'affecter aux éléments de votre scène 3D. Deux méthodes s'offrent à vous selon la portée souhaitée de votre modification.",
      ),
      ListModule(
        id: '3_application_list',
        title: "Les deux méthodes d'assignation",
        intro: "Choisissez la technique adaptée à votre situation de travail :",
        items: [
          "Méthode Globale (Asset Level) : Ouvrez votre Static Mesh directement dans son éditeur dédié à partir du Content Browser. Glissez votre Material Instance dans le slot de matériau par défaut de l'objet. Ce maillage utilisera désormais ce matériau à chaque fois qu'il sera glissé dans n'importe quel niveau de votre projet",
          "Méthode Locale (Actor Level) : Glissez-déposez votre Material Instance directement sur l'un des objets placés dans votre scène (Viewport). Cette modification locale remplace temporairement le matériau par défaut uniquement pour cet acteur précis de votre niveau, sans modifier l'asset de base dans votre bibliothèque.",
        ],
        outro:
            "Vous pouvez tester instantanément la réaction de vos surfaces aux variations de lumière de votre environnement.",
      ),
      ResourceModule(
        id: '3_application_res',
        title: "Pack complet de textures de production",
        description: "pack_textures_pbr_shading_ue5.zip",
        fileName: "pack_textures_pbr_shading_ue5.zip",
        downloadUrl:
            "https://drive.google.com/file/d/10yP38sR1nKS19caqNT-qtHSn8wQ-e4hf/view?usp=sharing",
      ),
      TitleModule(
        id: '3_quiz_validation',
        title: "Validation des Connaissances",
      ),
      QuizModule(
        id: '3_quiz_1',
        question:
            "Pourquoi utilise-t-on des Material Instances (MI_) plutôt que de multiplier les Master Materials (M_) ?",
        options: [
          "Parce que les instances permettent de modifier la structure géométrique d'un objet en temps réel",
          "Parce que les instances n'exécutent pas de nouvelle compilation de shader et s'appliquent instantanément",
          "Parce que les instances permettent d'écrire directement du code C++",
        ],
        correctIndices: [1],
        explanation:
            "Les instances se contentent de modifier des variables pré-compilées par leur parent, éliminant les temps d'attente de compilation.",
      ),
      QuizModule(
        id: '3_quiz_2',
        question:
            "Que signifie l'acronyme ORM et comment sont réparties ses données de masques monochromes ?",
        options: [
          "Occlusion (Rouge), Roughness (Vert), Metallic (Bleu)",
          "Orientation (Rouge), Refraction (Vert), Multiplier (Bleu)",
          "Opaque (Rouge), Roughness (Vert), Masked (Bleu)",
        ],
        correctIndices: [0],
        explanation:
            "L'ORM structure ses informations de manière standardisée : Occlusion sur le canal Rouge, Rugosité sur le Vert, et Métallicité sur le Bleu.",
      ),
      QuizModule(
        id: '3_quiz_3',
        question:
            "Quel est le standard de Normal Map natif d'Unreal Engine et comment corriger une texture importée du standard opposé ?",
        options: [
          "Standard OpenGL; cocher l'option \"Invert Channels\" dans le shader",
          "Standard DirectX; cocher l'option \"Flip Green Channel\" dans les propriétés d'Unreal Engine",
          "Standard DirectX; inverser la texture de gauche à droite",
        ],
        correctIndices: [1],
        explanation:
            "L'UE5 utilise DirectX. Si une texture utilise le standard OpenGL, cocher \"Flip Green Channel\" inverse l'axe Y pour corriger instantanément le relief.",
      ),
      QuizModule(
        id: '3_quiz_4',
        question:
            "Quel nœud permet de faire défiler en continu une texture sur une surface pour simuler un fluide ou du vent ?",
        options: ["CustomRotator", "World Aligned Texture", "Panner"],
        correctIndices: [2],
        explanation:
            "Le nœud Panner applique un décalage continu des coordonnées de texture (UVs) en fonction du temps.",
      ),
    ],
  ),
  SessionModel(
    id: 4,
    title: 'Lighting & Atmosphère',
    objective: "Sculpter la lumière et l'espace.",
    icon: Icons.wb_sunny_rounded,
    technicalPoints: [
      "Sun & Sky",
      "HDR Backdrop",
      "Lumen GI",
      "Volumetric Effects",
    ],
    filRouge: "Créer deux 'Lighting Scenarios'.",
    modules: [
      InfoModule(
        id: 'unreal_4_info',
        text:
            "Cette partie de la formation est actuellement en cours de développement. Elle sera disponible très prochainement dans une future mise à jour de l'application !",
        type: InfoType.info,
      ),
    ],
  ),
  SessionModel(
    id: 5,
    title: 'Sequencer I - Animation & Contraintes',
    objective: "Mettre les objets en mouvement.",
    icon: Icons.movie_filter_rounded,
    technicalPoints: [
      "Sequencer Intro",
      "Sockets",
      "Follow Path",
      "Interpolation",
    ],
    filRouge: "Animer un véhicule sur une Spline.",
    modules: [
      InfoModule(
        id: 'unreal_5_info',
        text:
            "Cette partie de la formation est actuellement en cours de développement. Elle sera disponible très prochainement dans une future mise à jour de l'application !",
        type: InfoType.info,
      ),
    ],
  ),
  SessionModel(
    id: 6,
    title: 'Sequencer II - Cinématographie & Caméras',
    objective: "Maîtriser le langage de la caméra.",
    icon: Icons.camera_rounded,
    technicalPoints: [
      "Cine Camera",
      "Focus & DOF",
      "Rig Rail & Crane",
      "Versioning",
    ],
    filRouge: "Poser les 5 plans caméras principaux.",
    modules: [
      InfoModule(
        id: 'unreal_6_info',
        text:
            "Cette partie de la formation est actuellement en cours de développement. Elle sera disponible très prochainement dans une future mise à jour de l'application !",
        type: InfoType.info,
      ),
    ],
  ),
  SessionModel(
    id: 7,
    title: 'Post-Process & Montage Interne',
    objective: "Le 'Final Look' et la structure narrative.",
    icon: Icons.auto_awesome_rounded,
    technicalPoints: ["PP Volume", "Camera Cuts", "Transitions"],
    filRouge: "Appliquer un étalonnage distinct par plan.",
    modules: [
      InfoModule(
        id: 'unreal_7_info',
        text:
            "Cette partie de la formation est actuellement en cours de développement. Elle sera disponible très prochainement dans une future mise à jour de l'application !",
        type: InfoType.info,
      ),
    ],
  ),
  SessionModel(
    id: 8,
    title: 'Rendu Technique & Export',
    objective: "Sortir les images pour la post-production.",
    icon: Icons.ios_share_rounded,
    technicalPoints: [
      "Movie Render Queue",
      "Render Settings",
      "Passes de rendu",
    ],
    filRouge: "Réaliser l'export final.",
    modules: [
      InfoModule(
        id: 'unreal_8_info',
        text:
            "Cette partie de la formation est actuellement en cours de développement. Elle sera disponible très prochainement dans une future mise à jour de l'application !",
        type: InfoType.info,
      ),
    ],
  ),
];
