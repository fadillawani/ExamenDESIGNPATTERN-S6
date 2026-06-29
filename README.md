# Examen Design Pattern S6 — BadWallet

## Description

Ce dépôt contient la réalisation de l’examen de Design Pattern S6.

Le projet est composé de trois parties :

* `badwallet-api` : API principale de gestion des portefeuilles électroniques.
* `payment-service` : service externe de gestion des factures.
* `badwallet-dashboard` : application Angular SPA consommant les endpoints backend.

## Technologies utilisées

### Backend

* Java
* Spring Boot
* Spring Web
* Spring Data JPA
* H2 Database
* Maven

### Frontend

* Angular 16+
* Standalone Components
* HttpClient
* RxJS
* Reactive Forms
* Signals
* Chart.js

## Fonctionnalités backend

* Seeder des wallets
* Création de portefeuille
* Listing paginé
* Recherche par téléphone
* Consultation du solde
* Dépôt
* Retrait
* Transfert
* Paiement de facture
* Paiement de factures spécifiques
* Historique des transactions
* Proxy vers payment-service

## Fonctionnalités frontend

### Espace Agent

* Listing paginé des portefeuilles
* Création d’un portefeuille
* Recherche par numéro de téléphone
* Dépôt
* Retrait

### Espace Client

* Dashboard avec solde
* Graphiques simples revenus/dépenses
* Transfert d’argent
* Consultation des factures
* Paiement de factures
* Historique des transactions

## Design Patterns utilisés

* Service Layer
* Repository Pattern
* Strategy Pattern
* Factory Pattern
* Proxy Pattern
* DTO Pattern

## Lancement du projet

### 1. Lancer payment-service

```bash
cd payment-service
mvn spring-boot:run
```

Port utilisé :

```txt
http://localhost:8081
```

### 2. Lancer badwallet-api

```bash
cd badwallet-api
mvn spring-boot:run
```

Port utilisé :

```txt
http://localhost:8080
```

### 3. Lancer Angular

```bash
cd badwallet-dashboard
npm install
ng serve
```

Application disponible sur :

```txt
http://localhost:4200
```

## Auteur

Fadil Lawani
GLRS L3
