# Specifiche Dettagliate dell'Applicazione NoteCraft

## 1. Introduzione al Progetto

**NoteCraft** è un'applicazione mobile nativa progettata per **iPadOS**, con l'obiettivo di rivoluzionare il modo in cui gli utenti prendono appunti, organizzano idee e gestiscono attività. L'app mira a fornire uno "spazio di lavoro all-in-one" che sia intuitivo, potente e specificamente ottimizzato per l'ecosistema iPad, sfruttando al massimo l'interazione con l'**Apple Pencil**.

## 2. Obiettivi e Visione

* Fornire un'esperienza utente fluida e gratificante per la creazione e l'organizzazione di contenuti digitali.
* Massimizzare l'usabilità e l'efficienza per gli utenti iPad, in particolare quelli che utilizzano l'Apple Pencil per la scrittura a mano e il disegno.
* Creare un'applicazione scalabile e sicura, capace di gestire le esigenze di una base utenti crescente.
* Essere una soluzione completa per la gestione di note, liste, brainstorming e documenti.

## 3. Funzionalità Chiave dell'Applicazione

### 3.1. Autenticazione Utente
* **Registrazione e Login:** Supporto per l'autenticazione tramite email e password.
* **Single Sign-On (SSO):** Integrazione con "Continue with Google" e "Continue with Apple" per una registrazione/accesso rapido e sicuro.
* **Verifica Email:** Processo di verifica dell'email dopo la registrazione per confermare l'account.
* **Gestione Account:** Funzionalità base per la modifica delle credenziali (es. reset password).

### 3.2. Gestione Contenuti (Note, Quaderni, Cartelle)
* **Quaderni:** Creazione, organizzazione e visualizzazione di "quaderni" digitali per raggruppare note correlate.
* **Cartelle:** Possibilità di creare cartelle per organizzare sia i quaderni che singole note.
* **Note:**
    * Creazione e modifica di note con formattazione rich-text.
    * Supporto per la scrittura a mano libera e il disegno tramite Apple Pencil.
    * Inserimento di elementi multimediali (immagini, potenzialmente PDF).
    * Ricerca e organizzazione delle note all'interno dei quaderni/cartelle.

### 3.3. Interazione Utente
* **Apple Pencil Optimization:** Interfaccia e funzionalità pensate per un'esperienza ottimale con Apple Pencil (disegno, scrittura, annotazioni).
* **Interfaccia Intuitiva:** Navigazione chiara e design user-friendly.

## 4. Architettura e Stack Tecnologico

### 4.1. Frontend (App Nataiva iOS/iPadOS)
* **Piattaforma Target:** iPadOS (principalmente iPad Pro 11 pollici, ma con adattabilità per altri modelli).
* **Linguaggio di Programmazione:** Swift.
* **Framework UI:** SwiftUI per lo sviluppo dell'interfaccia utente.
* **Pattern Architetturale:** Si predilige l'adozione del pattern **MVVM (Model-View-ViewModel)** per una chiara separazione delle responsabilità, facilitando la testabilità e la manutenibilità del codice.
* **Principi UI/UX:**
    * **Adattabilità:** Design completamente responsivo per gestire correttamente sia l'orientamento verticale (Portrait) che orizzontale (Landscape) dell'iPad.
    * **Layout:** Utilizzo efficiente dello spazio dello schermo dell'iPad; si considereranno layout a due colonne o l'implementazione di una sidebar persistente per la navigazione nelle schermate principali.
    * **Design System:** Pulito, minimalista, con un'attenzione alla tipografia e alla gerarchia visiva.
    * **Temi:** Supporto completo per Dark Mode e Light Mode.
    * **Accessibilità:** Implementazione di funzionalità di accessibilità (es. VoiceOver, Dynamic Type) per garantire l'usabilità a tutti.
    * **Componenti:** Sviluppo di componenti SwiftUI riutilizzabili e ben incapsulati.

### 4.2. Backend e Database
* **Piattaforma:** **Firebase**.
* **Servizi Firebase:**
    * **Firebase Authentication:** Gestione completa dell'autenticazione utente (email/password, Google, Apple).
    * **Cloud Firestore:** Database NoSQL orientato ai documenti, scelto per la sua scalabilità, sincronizzazione in tempo reale e facilità di integrazione con le applicazioni mobili. Sarà utilizzato per memorizzare dati strutturati come informazioni utente, quaderni, cartelle e note.
    * **Firebase Cloud Storage:** Per la memorizzazione di file binari, come immagini allegate alle note o altri media.
    * **Firebase Cloud Functions (Potenziale):** Per logica serverless, validazione complessa o operazioni asincrone, se necessario in fasi successive.
* **Regole di Sicurezza:** Saranno implementate robuste **Firebase Security Rules** (Firestore Rules, Storage Rules) per garantire che solo gli utenti autorizzati possano accedere e modificare i propri dati.

## 5. Fasi di Sviluppo Iniziali (Roadmap)

1.  **Configurazione Iniziale:** (Completata) Progetto Xcode, Progetto Firebase, Integrazione Trae.
2.  **Sviluppo UI (Frontend):**
    * **Schermata di Benvenuto (Welcome/Onboarding):** Implementazione UI completa e adattiva.
    * **Schermata di Registrazione (Sign Up):** Implementazione UI completa e adattiva.
    * **Schermata di Verifica Email:** Implementazione UI completa e adattiva.
    * **Schermata Principale (My Notes/Notebooks/Folders):** Implementazione UI con layout ottimizzato per iPad (es. sidebar).
3.  **Integrazione Autenticazione:**
    * Implementazione della logica di registrazione e login con Firebase Authentication.
    * Integrazione con Google Sign-In e Apple Sign-In.
    * Gestione degli stati di autenticazione e del flusso utente.
4.  **Gestione Dati Base:**
    * Integrazione con Cloud Firestore per la creazione, lettura, aggiornamento ed eliminazione (CRUD) di quaderni e note.
    * Definizione del modello di dati (struttura delle collezioni e documenti in Firestore).

## 6. Strumenti di Sviluppo e Collaborazione

* **Piattaforma AI:** **Trae** (con agenti e MCP Servers configurati).
    * **Sequential Thinking MCP:** Per migliorare la capacità di problem-solving e pianificazione dell'AI.
    * **Firebase MCP Server:** Per l'interazione diretta e l'automazione con i servizi Firebase (autenticazione, database, storage).
    * **GitHub Integration:** Per il controllo versione del codice e la collaborazione.
    * **Figma AI Bridge:** Per l'interpretazione e l'analisi dei design mock-up.
* **IDE:** Xcode.
* **Controllo Versione:** Git / GitHub.
* **Design:** Figma (con mock-up dettagliati e descrizioni in Markdown/PNG caricati in Trae Docs).

## 7. Linee Guida per l'Agente AI

L'agente AI è istruito a:
* Generare codice Swift/SwiftUI pulito, modulare e conforme alle best practice.
* Riferirsi costantemente ai file di design Markdown e alle immagini PNG per i dettagli UI/UX.
* Integrare i servizi Firebase utilizzando le credenziali e le configurazioni MCP fornite.
* Richiedere chiarimenti se i requisiti non sono chiari.
* Implementare una robusta gestione degli errori.
* Mantenere un focus sulla performance e l'efficienza.
* Sincronizzare regolarmente il codice con il repository GitHub.
* **Azione Finale:** Una volta completata la generazione del codice per un compito specifico, l'agente deve notificare il completamento e, se possibile, **aprire il progetto Xcode nel terminale** eseguendo il comando: `open /Users/moro/Desktop/NoteCraft-1/NoteCraft.xcodeproj`.

---

Puoi copiare questo testo e salvarlo come `Progetto.md` (o il nome specifico che usi per il file descrittivo principale del progetto) nella tua cartella "Docs" o nella directory radice che Trae monitora. Questo dovrebbe fornirgli tutto il contesto necessario.