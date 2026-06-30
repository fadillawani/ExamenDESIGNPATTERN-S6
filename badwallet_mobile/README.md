# BadWallet Mobile

Application mobile Flutter développée dans le cadre de l’examen de Flutter L3 S2 2026.

## Description

BadWallet Mobile est une application mobile multiplateforme orientée client final.  
Elle permet à un utilisateur de consulter son portefeuille électronique, son solde, ses transactions, d’effectuer des transferts d’argent et de payer ses factures.

L’application consomme la BadWallet API exposée sur le port `8080`.

## Technologies utilisées

- Flutter
- Dart
- Provider
- HTTP
- Intl
- Google Fonts
- Flutter Secure Storage

## Fonctionnalités réalisées

- Authentification simulée par numéro de téléphone
- Tableau de bord client
- Affichage du solde
- Masquage / affichage du solde
- Affichage des 5 dernières transactions
- Transfert d’argent
- Historique complet des transactions
- Filtres sur les transactions
- Consultation des factures impayées
- Filtrage des factures par fournisseur
- Paiement de factures sélectionnées

## Architecture

Le projet suit une organisation feature-first :

```txt
lib/
├── core/
│   └── constants/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── transfers/
│   ├── bills/
│   └── history/
├── models/
├── providers/
└── services/