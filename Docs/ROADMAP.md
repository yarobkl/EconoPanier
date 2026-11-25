# Matrice des 28 références (V4, pages 14–41)

Aucun écran n'est déclaré conforme à une capture réelle. Le lot 0.1 contient des sous-ensembles fonctionnels non compilés.

| Maquette | État source 0.1 |
|---|---|
| 01 Accueil | Partiel, données locales et navigation |
| 02 Courses | Partiel, liste manuelle |
| 03 Stock | Partiel, quatre zones |
| 04 Analyse | Partiel, budget seul |
| 05 Plus | Partiel, haptique et info |
| 06 Scanner | À faire |
| 07 Produit | À faire |
| 08 Tickets | À faire |
| 09 Rapprochement | À faire |
| 10 Liste | Partiel, ajout/coche/suppression |
| 11 Budget | Partiel, plafond mensuel |
| 12 Habitudes | À faire |
| 13 Comparateur | À faire |
| 14 Assistant | À faire |
| 15 Recettes | À faire |
| 16 À consommer bientôt | À faire |
| 17 Fruits et légumes | À faire |
| 18 Détail stock | Partiel, consommation/perte |
| 19 Courses actives | À faire |
| 20 Inflation | À faire |
| 21 Nutrition | À faire |
| 22 Foyer | À faire |
| 23 Notifications | À faire |
| 24 Contribution | À faire |
| 25 Confidentialité | Partiel, stockage local et haptique |
| 26 Économies | À faire |
| 27 Anti-gaspillage | Partiel, événement de perte non valorisé |
| 28 Premier lancement | Partiel, accueil vierge |

## Ordre technique
1. Build simulateur, revue réelle, logo vectoriel exact et icône, transitions et accessibilité.
2. Modèles Product/PriceObservation/ShoppingSession/Receipt/ReceiptLine et validation transactionnelle idempotente. Quantités normalisées, historique, DLC/DDM distinctes, rapprochement, corrections, budget des achats réels.
3. Scanner, Vision OCR, OFF, prix manquants, Open Prices en lecture ; preuves et provenance. Tests sur tickets réels anonymisés. Modèle fruits à sélectionner, licencier et mesurer.
4. Inflation comparable, économies sans double comptage, consommation et recettes sûres, Nutrition. Foundation Models local avec fallback déterministe et confirmation des écritures.
5. Préférences sensibles isolées hors sauvegarde, CloudKit privé optionnel pour données autorisées, suppression multi-appareils, permissions, notifications, contributions explicites.
6. Captures des 28 écrans, tests réels iPhone, accessibilité, conformité juridique et licences, signature cloud, TestFlight interne autorisé.

## Décisions provisoires
- Bundle ID fr.yaroconsulting.econopanier à contrôler avant enregistrement Apple.
- iOS 17 minimum proposé pour fonctions locales, IA conditionnelle selon SDK/dispositif.
- CI déclenchement manuel pour limiter consommation des minutes. Aucune signature ni diffusion automatique.
- Aucun serveur, aucun compte, aucune télémétrie et aucune API tierce activée dans ce lot.
