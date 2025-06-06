Regole di Progetto per NoteCraft
Questo documento definisce le linee guida e le specifiche per lo sviluppo dell'applicazione NoteCraft, da utilizzare come riferimento principale per l'agente AI.

1. Dettagli del Progetto
Nome del Progetto: NoteCraft

Descrizione: Un'applicazione nativa per iPad per la gestione di note, quaderni e cartelle, con focus su un'interfaccia utente pulita, l'ottimizzazione per iPadOS e l'interazione con Apple Pencil.

Piattaforma Principale: iPadOS (principalmente iPad Pro 11 pollici)

Stato Attuale: Configurazione degli MCP Server completata. Pronti per la generazione del codice UI, partendo dalla Welcome Screen.

2. Tecnologie e Stack
2.1. Frontend (App iOS/iPadOS)
Linguaggio: Swift

Framework UI: SwiftUI

Architettura: MVVM (Model-View-ViewModel) per la logica di business e la gestione dello stato. Design dell'interfaccia utente basato su componenti riutilizzabili.

Linee Guida UI/UX:

Adattabilità: L'app deve essere pienamente adattiva e responsiva per entrambi gli orientamenti dell'iPad (Portrait e Landscape).

Estetica: Interfaccia utente pulita, moderna e minimalista.

Spazio Schermo: Utilizzo efficiente dello spazio schermo dell'iPad (es. considerare layout a due colonne o sidebar per le pagine principali).

Temi: Supporto per Dark Mode e Light Mode.

Accessibilità: Implementare funzionalità di accessibilità (es. VoiceOver, Dynamic Type).

Apple Pencil: Ottimizzazione per l'interazione con Apple Pencil (se applicabile a specifici componenti o funzioni, come l'area di disegno/scrittura).

Convenzioni di Naming: Utilizzare PascalCase per View e ViewModel (es. WelcomeView, AuthViewModel).

Struttura dei File: Preferire una struttura modulare, organizzata per funzionalità (es. cartelle /Auth, /Notes, /Notebooks).

2.2. Backend (Firebase)
Piattaforma: Firebase

Servizi Utilizzati:

Autenticazione: Firebase Authentication (con supporto per Email/Password, Google Sign-In, Apple Sign-In).

Database: Cloud Firestore (preferito per la memorizzazione di dati strutturati come quaderni, note, cartelle e utenti).

Storage: Firebase Cloud Storage (per la gestione di file allegati alle note o media).

Funzioni Cloud: Firebase Cloud Functions (se in futuro fosse necessaria una logica serverless complessa o integrazioni API).

Regole di Sicurezza: Implementare robuste regole di sicurezza (Firestore Rules, Storage Rules) per proteggere i dati degli utenti e controllare gli accessi.

2.3. Controllo Versione
Sistema: Git

Piattaforma: GitHub

Strategia: Git Flow o Feature Branching.

Messaggi di Commit: Incoraggiare l'uso di Conventional Commits per maggiore chiarezza e automazione.

3. Processo di Sviluppo
Approccio: Sviluppo iterativo e incrementale, partendo dalle schermate UI di base e aggiungendo progressivamente funzionalità e logica.

Ciclo di Feedback: Generare codice tramite l'AI, testarlo nell'ambiente di sviluppo (Xcode), e fornire feedback specifico e costruttivo a Trae per le revisioni.

Documentazione: Mantenere aggiornati i file Markdown nella sezione "Docs" di Trae con le evoluzioni del design e delle specifiche funzionali.

4. Interazione con l'Agente AI
Tono: Interazioni professionali, dettagliate e orientate alla soluzione.

Chiarimenti: L'agente è incoraggiato a chiedere chiarimenti se i requisiti non sono chiari o presentano ambiguità.

Gestione Errori: Implementare una robusta gestione degli errori nel codice generato e suggerire meccanismi di logging appropriati.

Performance: Considerare sempre le implicazioni di performance e suggerire ottimizzazioni quando possibile.

Azione Post-Generazione: Una volta completata la generazione del codice per un compito specifico (es. la Welcome Screen), l'agente deve notificare il completamento e, se possibile, aprire il progetto Xcode nel terminale eseguendo il comando:
open /Users/moro/Desktop/NoteCraft-1/NoteCraft.xcodeproj

Compilazione (Build): L'agente NON deve mai eseguire la compilazione (build) o l'avvio dell'app. Questo compito spetta sempre e solo all'utente tramite Xcode.

5. Priorità Attuali e Future
Focus Immediato: Implementazione della UI/UX per la Welcome Screen, seguita dalla Sign Up Screen e dalla Email Verification Screen.

Focus Futuro Prossimo: Integrazione completa dell'autenticazione con Firebase.

Aspetti Critici:

Sicurezza dell'autenticazione e dei dati.

Eccellente esperienza utente su iPad.

Scalabilità dell'applicazione con Firebase.

6. Integrazioni Esterne (Gestite da Trae)
Figma AI Bridge: Utilizzare le informazioni dal Figma AI Bridge per comprendere i dettagli di design, layout e stile direttamente dai file Figma.

GitHub Sync: Mantenere il codice generato sincronizzato con il repository GitHub del progetto.

Firebase MCP Server: Sfruttare l'accesso al progetto Firebase tramite l'MCP Server per tutte le operazioni di backend (autenticazione, database, storage).