# Configurazione Autenticazione NoteCraft

Questo documento fornisce le istruzioni dettagliate per configurare l'autenticazione con Google e Apple nel progetto NoteCraft.

## 1. Configurazione Firebase

### 1.1 Aggiungere Firebase SDK

1. Apri il progetto in Xcode
2. Vai su **File > Add Package Dependencies**
3. Aggiungi l'URL: `https://github.com/firebase/firebase-ios-sdk`
4. Seleziona le seguenti librerie:
   - `FirebaseAuth`
   - `FirebaseCore`
   - `FirebaseFirestore` (per future funzionalità)

### 1.2 Configurare GoogleService-Info.plist

1. Scarica il file `GoogleService-Info.plist` dalla console Firebase
2. Trascinalo nel progetto Xcode (assicurati che sia aggiunto al target)
3. Verifica che il file sia presente nel bundle dell'app

## 2. Configurazione Google Sign-In

### 2.1 Aggiungere Google Sign-In SDK

1. Vai su **File > Add Package Dependencies**
2. Aggiungi l'URL: `https://github.com/google/GoogleSignIn-iOS`
3. Seleziona `GoogleSignIn`

### 2.2 Configurare URL Scheme

1. Apri il file `GoogleService-Info.plist`
2. Copia il valore di `REVERSED_CLIENT_ID`
3. Nel progetto Xcode, vai su **Target > Info > URL Types**
4. Aggiungi un nuovo URL Type:
   - **Identifier**: `com.googleusercontent.apps.YOUR_CLIENT_ID`
   - **URL Schemes**: Incolla il valore di `REVERSED_CLIENT_ID`

### 2.3 Configurare Info.plist

Aggiungi le seguenti chiavi al file `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

## 3. Configurazione Sign In with Apple

### 3.1 Abilitare Capability

1. Nel progetto Xcode, vai su **Target > Signing & Capabilities**
2. Clicca su **+ Capability**
3. Aggiungi **Sign In with Apple**

### 3.2 Configurare Apple Developer Account

1. Vai su [Apple Developer Console](https://developer.apple.com)
2. Configura l'App ID con la capability "Sign In with Apple"
3. Crea/aggiorna il Provisioning Profile

## 4. Configurazione Firebase Console

### 4.1 Abilitare Provider di Autenticazione

1. Vai sulla [Firebase Console](https://console.firebase.google.com)
2. Seleziona il tuo progetto
3. Vai su **Authentication > Sign-in method**
4. Abilita:
   - **Google**: Configura con il tuo Client ID
   - **Apple**: Abilita il provider

### 4.2 Configurare Google Sign-In

1. Nel provider Google, inserisci:
   - **Web client ID** (dal GoogleService-Info.plist)
   - **Web client secret** (dalla Google Cloud Console)

### 4.3 Configurare Apple Sign-In

1. Nel provider Apple, inserisci:
   - **Services ID** (dall'Apple Developer Console)
   - **Apple Team ID**
   - **Key ID** e **Private Key** (per l'autenticazione server-to-server)

## 5. Test dell'Implementazione

### 5.1 Verifiche Preliminari

- [ ] Firebase SDK aggiunto e configurato
- [ ] GoogleService-Info.plist presente nel progetto
- [ ] Google Sign-In SDK aggiunto
- [ ] URL Scheme configurato per Google
- [ ] Sign In with Apple capability abilitata
- [ ] Provider abilitati nella Firebase Console

### 5.2 Test Funzionalità

1. **Test Google Sign-In**:
   - Tocca "Continue with Google"
   - Verifica che si apra il browser/app Google
   - Completa l'autenticazione
   - Verifica il reindirizzamento alla MainView

2. **Test Apple Sign-In**:
   - Tocca "Continue with Apple"
   - Verifica che si apra il prompt Apple
   - Completa l'autenticazione (Face ID/Touch ID)
   - Verifica il reindirizzamento alla MainView

## 6. Risoluzione Problemi Comuni

### 6.1 Errori Google Sign-In

- **"Google Client ID non configurato"**: Verifica che GoogleService-Info.plist sia presente
- **"URL Scheme non valido"**: Controlla che REVERSED_CLIENT_ID sia configurato correttamente
- **"Impossibile trovare il view controller"**: Problema con la presentazione del controller

### 6.2 Errori Apple Sign-In

- **"Sign In with Apple non disponibile"**: Verifica che la capability sia abilitata
- **"Nonce non valido"**: Problema con la generazione del nonce di sicurezza
- **"Provider non configurato"**: Verifica la configurazione nella Firebase Console

### 6.3 Errori Firebase

- **"Firebase non inizializzato"**: Verifica che FirebaseApp.configure() sia chiamato
- **"Provider non abilitato"**: Controlla la configurazione nella Firebase Console
- **"Token non valido"**: Problema con la configurazione dei provider

## 7. Sicurezza e Best Practices

### 7.1 Sicurezza

- Non esporre mai le chiavi private nel codice
- Usa sempre HTTPS per le comunicazioni
- Implementa la validazione lato server quando possibile
- Monitora i tentativi di autenticazione sospetti

### 7.2 User Experience

- Fornisci feedback visivo durante l'autenticazione
- Gestisci gracefully gli errori di rete
- Implementa il logout sicuro
- Considera l'autenticazione biometrica per accessi rapidi

## 8. Prossimi Passi

Dopo aver completato questa configurazione:

1. Testa l'autenticazione su dispositivo fisico
2. Implementa la persistenza dello stato di autenticazione
3. Aggiungi l'autenticazione email/password
4. Implementa la verifica email
5. Configura le regole di sicurezza Firestore

---

**Nota**: Questa configurazione richiede account sviluppatore attivi per Apple e Google, oltre a un progetto Firebase configurato. Assicurati di avere tutti i permessi necessari prima di procedere.