# Notes de Mise à Jour - Training Toolkit

Ce document regroupe l'historique des versions et les notes de mise à jour du projet **Training Toolkit** (Unreal Engine Workshop).


## 🚀 Version 0.1.3 (20 mai 2026)
Cette mise à jour apporte le contenu complet du Chapitre 3 ainsi que les ressources et images associées.

### 🌟 Nouveautés & Contenu
* **Chapitre 3 Activé & Complété** : "Shading & Maîtrise des Matériaux" est maintenant entièrement accessible avec ses 15 points de cours détaillés.
* **Intégration des médias** : Ajout des schémas d'architecture et des captures d'illustration pour le chapitre 3.
* **Mise à jour des ressources** : Ajout du lien vers le pack complet de textures PBR pour les exercices pratiques.
* **Quiz interactif** : Validation des connaissances opérationnelles avec 4 questions interactives spécifiques.

### ⚙️ Technique & Build
* Montée de version à `0.1.3` (`pubspec.yaml` et `setup.iss`).
* Préparation du script InnoSetup pour le déploiement.

---

## 🚀 Version 0.1.2 (19 mai 2026)
Cette mise à jour apporte des simplifications majeures à l'expérience utilisateur pour les sessions en cours de création, évitant ainsi le défilement inutile.

### 🌟 Améliorations de l'Interface Utilisateur
* **Simplification visuelle des sessions "En cours de création"** (les 3 rappels des bases et les chapitres 3 à 8) :
  * Suppression du module de titre d'en-tête interne (*"POINT DE FORMATION - Contenu en cours de création"*).
  * Masquage complet de la section et de la carte **Projet Fil Rouge** pour ces sessions.
  * Conservation uniquement de la note d'**Information** claire et épurée indiquant que le contenu arrive prochainement.
* **Navigation préservée** : Les en-têtes globaux de chapitre (titre, objectif) et les boutons de navigation (pied de page) restent actifs pour assurer une navigation fluide.

### ⚙️ Technique & Build
* Montée de version du projet à `0.1.2` (`pubspec.yaml` et `setup.iss`).
* Re-compilation de l'application Flutter pour Windows.
* Régénération du programme d'installation InnoSetup (`Output/TrainingToolkit-Setup.exe`).

---

## 🚀 Version 0.1.1 (19 mai 2026)
Mise en place de la structure globale et des espaces réservés (placeholders) pour le contenu futur.

### 🛠️ Nouveautés & Changements
* **Espaces réservés (Placeholders)** : Intégration d'un module d'information standard sur les chapitres non finalisés pour structurer l'arborescence de formation.
* **Mise à jour d'InnoSetup** : Ajustement du script de déploiement et montée de version vers `0.1.1`.
* **Git** : Retrait du dossier `Output/` du suivi de version et mise à jour du `.gitignore`.

---

## 🚀 Version 0.1.0 (19 mai 2026)
Version initiale du Training Toolkit pour la formation Unreal Engine.

### 📦 Fonctionnalités clés
* **Chapitres actifs intégrés** :
  * **Chapitre 1** : Fondations & Workflow de Production.
  * **Chapitre 2** : World Building & Optimisation.
* **Design System** : Thème premium sombre avec intégration de composants riches (Modules SideBySide, Quiz interactifs, Cartes de ressources, etc.).
* **Premier build de production** : Configuration initiale d'InnoSetup pour générer l'exécutable d'installation Windows.
