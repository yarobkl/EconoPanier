# ÉconoPanier — Fondations 0.1.0 (confidentiel)

Premier lot de code source natif, basé sur le dossier de conception V4 du 25 novembre 2026. Ne pas publier. Aucun dépôt INPI effectué à ce stade.

## Inclus
- Navigation SwiftUI à cinq onglets, accueil vierge, identité couleur/feuille provisoire.
- Persistance SwiftData locale explicitement sans CloudKit.
- Liste de courses manuelle (ajout, coche, suppression), stock par zone (ajout manuel, consommation/perte partielle tracée), budget mensuel facultatif, réglage haptique.
- Introduction native expérimentale en phases, deux impulsions Core Haptics, saut possible, alternative Reduce Motion. Le mouvement géométrique exact vers l'en-tête et la fidélité du logo restent à travailler.
- Moteur Decimal avec centimes entiers en stockage, total partiel si prix inconnu, écart rayon/caisse, six tests XCTest écrits.
- Configuration XcodeGen et workflow GitHub Actions macOS 26, déclenchement manuel, test simulateur sans signature, journaux et xcresult.

## Cloud uniquement
1. Dépôt yarobkl/EconoPanier privé.
2. Sources sur branche develop/foundations. Aucun secret ni document confidentiel dans un dépôt public.
3. Vérifier minutes/macOS et permissions avant lancement du workflow manuel iOS — validation cloud.
4. Lire les preuves, corriger, comparer les captures aux pages 14–41 du V4.
5. Après validation, configurer App ID et signature Apple gérée ; préparer Xcode Cloud et TestFlight interne séparément. Pas de publication publique.

Aucun Xcode local, aucun terminal local requis de l'utilisateur. Le projet Xcode est généré dans le runner. Version iOS 17 proposée pour le socle, Bundle ID proposé non vérifié. Le module IA nécessitera un SDK et un appareil compatibles, avec contrôles de disponibilité. Le workflow n'est pas exécuté ; ni compilation ni test iOS ni signature attestés.

## Limites et travaux restants
Les écrans sont des premières vues fonctionnelles partielles, non des reproductions fidèles des 28 références. Aucun scanner, OCR, catalogue externe, achats confirmés, prévision, recette, IA, notification, export/effacement intégral ou synchronisation n'est encore livré. Pas de données sensibles collectées. Les quantités du premier lot sont en unités entières ; unités pondérales, DLC/DDM, migrations et correction de mouvements restent à développer. Mode clair initial, variante sombre et contraste à vérifier. Le dessin de la feuille et les couleurs sont des approximations à valider avec les visuels V4. L'animation n'a pas été exécutée ni testée sur iPhone. Icône App Store de production non créée. Voir Docs/ROADMAP.md.
