# Traction - Application Trello-like avec Phoenix LiveView

Une application de gestion de tâches inspirée de Trello, développée avec Phoenix LiveView pour apprendre Elixir et Phoenix.

## 🚀 Démarrage Rapide

```bash
# Installation et configuration des dépendances
mix setup

# Démarrage du serveur Phoenix
mix phx.server
```

Visitez [`localhost:4000`](http://localhost:4000) dans votre navigateur.

## 📋 Fonctionnalités

- ✅ **Gestion des Boards** : Visualisation de tableaux de tâches (Création par seed)
- ✅ **Listes Organisées** : Organisation des tâches en colonnes
- ✅ **Cartes Interactives** : Gestion de cartes de tâches (Création par seed)
- ✅ **Drag & Drop** : Déplacement intuitif des cartes entre listes
- ✅ **Interface Moderne** : Design responsive avec Tailwind CSS

## 🔧 Architecture Technique

### Technologies Utilisées
- **Phoenix 1.8** : Framework web pour Elixir
- **Phoenix LiveView** : Interface utilisateur réactive
- **Ecto** : ORM pour la base de données
- **PostgreSQL** : Base de données
- **Tailwind CSS** : Framework CSS
- **ESBuild** : Outil de build JavaScript

### Structure du Projet
```
lib/traction/
├── boards/           # Modèles métier (Board, List, Card)
├── boards.ex         # Context pour les boards
├── repo.ex           # Configuration base de données
└── traction.ex       # Application principale

lib/traction_web/
├── components/       # Composants UI réutilisables
├── controllers/      # Contrôleurs traditionnels
├── live/            # Modules LiveView
└── router.ex        # Configuration des routes
```

## 🎯 Problèmes et Solutions - Drag & Drop

### Contexte du Problème

L'implémentation du drag & drop dans Phoenix LiveView a présenté plusieurs défis techniques liés à l'interaction entre les événements JavaScript natifs du navigateur et le système d'événements de LiveView.

### Problèmes Identifiés

#### 1. **Interférence des Événements Natifs**
- **Problème** : Les événements `dragstart` et `drop` natifs du navigateur ont des comportements par défaut qui entrent en conflit avec les événements LiveView
- **Impact** : Les événements `phx-dragstart` et `phx-drop` n'étaient pas déclenchés côté serveur
- **Cause** : Propagation et comportement par défaut des événements DOM

#### 2. **Configuration JavaScript Incorrecte**
- **Problème** : Import de dépendance inexistante (`phoenix-colocated`)
- **Impact** : Erreurs JavaScript empêchant l'initialisation de LiveSocket
- **Cause** : Configuration incorrecte du fichier `app.js`

#### 3. **Attributs HTML Incompatibles**
- **Problème** : Utilisation simultanée d'attributs `phx-*` et d'event listeners manuels
- **Impact** : Conflits entre les deux systèmes d'événements
- **Cause** : Double gestion des événements drag & drop

### Solutions Implémentées

#### Solution 1 : Hook JavaScript Manuel

**Fichier : `assets/js/app.js`**

```javascript
hooks: {
  DragDrop: {
    mounted() {
      console.log("🎯 DragDrop hook mounted");

      // Gestion manuelle des événements drag & drop
      this.el.addEventListener('dragstart', (e) => {
        const cardId = e.target.dataset.cardId;
        if (cardId) {
          e.dataTransfer.setData('text/plain', cardId);
          e.dataTransfer.effectAllowed = 'move';
          this.pushEvent("dragstart", { card_id: cardId });
        }
      });

      this.el.addEventListener('dragover', (e) => {
        e.preventDefault();
        const listId = e.currentTarget.dataset.listId;
        if (listId) {
          this.pushEvent("dragover", { list_id: listId });
        }
      });

      this.el.addEventListener('drop', (e) => {
        e.preventDefault();
        const cardId = e.dataTransfer.getData('text/plain');
        const listId = e.currentTarget.dataset.listId;

        if (cardId && listId) {
          this.pushEvent("drop", {
            card_id: cardId,
            list_id: listId
          });
        }
      });
    }
  }
}
```

#### Solution 2 : Template HTML Simplifié

**Fichier : `lib/traction_web/live/board_live.ex`**

```html
<!-- Zones de drop (listes) -->
<div
  id={"list-dropzone-#{list.id}"}
  class="space-y-3 min-h-[200px]"
  phx-hook="DragDrop"
  data-list-id={list.id}
>
  <!-- Cartes -->
  <div
    id={"card-#{card.id}"}
    class="bg-white rounded shadow-sm p-3 hover:shadow-md transition-shadow cursor-move"
    draggable="true"
    phx-hook="DragDrop"
    data-card-id={card.id}
  >
```

#### Solution 3 : Gestion des Événements

**Principe :**
- ✅ **Contrôle Total** : `pushEvent` permet un contrôle précis des données envoyées
- ✅ **Prévention des Conflits** : `preventDefault()` et `stopPropagation()` évitent les interférences
- ✅ **Data Transfer** : Utilisation de `dataTransfer` pour transporter l'ID de la carte
- ✅ **Feedback Visuel** : Gestion des états de survol et de drop

### Avantages de la Solution

1. **Fiabilité** : Plus de conflits entre événements natifs et LiveView
2. **Contrôle** : Gestion précise de ce qui est envoyé au serveur
3. **Performance** : Événements optimisés, pas de duplication
4. **Maintenance** : Code plus clair et plus facile à déboguer
5. **Évolutivité** : Facilement extensible pour de nouvelles fonctionnalités

### Tests et Validation

#### Tests Fonctionnels
- ✅ Événements JavaScript déclenchés correctement
- ✅ Événements serveur reçus et traités
- ✅ Mise à jour de la base de données
- ✅ Interface utilisateur mise à jour en temps réel
- ✅ Gestion des erreurs et états d'erreur

#### Logs de Débogage
```javascript
// Console JavaScript
🎯 DragDrop hook mounted
📦 Dragstart: {cardId: "123"}
👆 Dragover list: "456"
🎯 Drop event
📥 Dropping card 123 into list 456

// Console Serveur (Elixir)
🎯 DRAG START DETECTED!
🎯 DROP DETECTED!
✅ Card updated successfully!
```

## 📚 Commandes Utiles

```bash
# Développement
mix phx.server          # Démarrer le serveur
mix test               # Lancer les tests
mix format             # Formatter le code

# Base de données
mix ecto.create        # Créer la base
mix ecto.migrate       # Appliquer les migrations
mix ecto.seed          # Peupler avec des données de test

# Assets
mix assets.build       # Construire les assets
mix assets.deploy      # Optimiser pour la production

# Maintenance
mix deps.get           # Installer les dépendances
mix precommit          # Vérifications avant commit
```

## 🚀 Déploiement

Pour déployer en production, consultez les [guides de déploiement Phoenix](https://hexdocs.pm/phoenix/deployment.html).

## 📖 Apprendre Plus

- **Site Officiel** : https://www.phoenixframework.org/
- **Guides** : https://hexdocs.pm/phoenix/overview.html
- **Documentation** : https://hexdocs.pm/phoenix
- **Forum** : https://elixirforum.com/c/phoenix-forum
- **Source** : https://github.com/phoenixframework/phoenix

---

*Développé avec ❤️ pour apprendre Elixir et Phoenix LiveView*
