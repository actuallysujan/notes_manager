# 📝 Notes Manager

A clean, minimal note-taking app built with **Flutter** and **Firebase**. Create, edit, and organize your notes with a smooth, modern UI — secure authentication, real-time sync, and a premium feel.

---

## ✨ Features

- 🔐 **Authentication** — Email/password login & signup powered by Firebase Auth, with full form validation (email format, password rules, confirm-password matching) and inline error messages.
- 📋 **Real-time Notes** — Notes are synced live via Firestore (`StreamBuilder`), so changes reflect instantly across sessions.
- 🗂️ **Dashboard** — Responsive grid layout (1–3 columns depending on screen size) with a live note count displayed in the app bar.
- ➕ **Create / Edit / Delete** — Add new notes, update existing ones, and delete with a confirmation dialog to prevent accidental loss.
- 🔔 **Toast Notifications** — Friendly success/error toasts (via `toastification`) for login, signup, and note actions, including a personalized welcome message on login.
- 📱 **Responsive UI** — Layouts adapt across phones, tablets, and desktop screen sizes.
- 🎨 **Custom Design System** — Reusable styled components (`AppTextField`, confirm dialogs, custom text styles) for a consistent, polished look across the app.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | [Flutter](https://flutter.dev) |
| Language | Dart |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Notifications | [toastification](https://pub.dev/packages/toastification) |
| State Management | StatefulWidget + StreamBuilder (ViewModel pattern) |

---

## 📂 Project Structure

```
lib/
├── core/                  # Shared utilities, colors, text styles, dialogs
│   ├── app_colors.dart
│   ├── common_utils.dart
│   ├── custom_textstyles.dart
│   └── dilogs.dart
|   └── app_text_field.dart
|   └── validators.dart
├── models/                # Data models
│   └── notes_model.dart
|   |__ auth_model.dart
├── routes/
|   └── app_routes.dart     ## routing logic for the entire app{used minimal/simple routing)
├── services/               # Firebase/auth service layer
│   └── auth_service.dart
|   |__ notes_service.dart
├── viewmodels/             # Business logic / data streams
│   └── notes_viewmodel.dart
├── views/                  # UI screens
│   ├── auth/
│   │   ├── login_view.dart
│   │   └── signup_view.dart
│   ├── notes/
│   │   ├── dashboard_view.dart
│   │   └── note_form_view.dart
│   
│    
└── main.dart

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- A [Firebase](https://console.firebase.google.com) project set up

### 1. Clone the repo
```bash
git clone https://github.com/YOUR_USERNAME/notes-manager.git
cd notes-manager
```

### 2. Install dependencies[Required]
```bash

  # Utils
  intl: ^0.20.2
 
  # UI
  cupertino_icons: ^1.0.8
  cloud_firestore: ^6.6.0
  firebase_core: ^4.11.0
  firebase_auth: ^6.5.3
  lottie: ^3.3.3
  toastification: ^3.2.0
  
flutter pub get
```

### 3. Set up Firebase

#### a. Create a Firebase project
- Go to [console.firebase.google.com](https://console.firebase.google.com)
- Click **Add project**, give it a name (e.g. `notes-manager`), and follow the setup steps (Google Analytics is optional)

#### b. Install the Firebase CLI
```bash
npm install -g firebase-tools
```
Then log in:
```bash
firebase login
```

#### c. Install the FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```
Make sure your pub-cache bin is on your PATH (e.g. `export PATH="$PATH:$HOME/.pub-cache/bin"` on macOS/Linux).

#### d. Connect Flutter to your Firebase project
From your project root:
```bash
flutterfire configure
```
- Select your Firebase project from the list (or create a new one)
- Choose the platforms you want to support (Android / iOS / Web)
- This auto-generates `lib/firebase_options.dart` and registers your app(s) with Firebase — no manual `google-services.json`/`GoogleService-Info.plist` placement needed, the CLI handles it for you.

#### e. Initialize Firebase in `main.dart`
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

#### f. Enable Authentication
- In the Firebase Console → **Build → Authentication → Get started**
- Under **Sign-in method**, enable **Email/Password**
- That's it — no extra config needed for `firebase_auth` to work in the app once `Firebase.initializeApp()` has run

#### g. Set up Cloud Firestore
- In the Firebase Console → **Build → Firestore Database → Create database**
- Choose **Start in production mode** (recommended) or test mode for quick local development
- Pick a region close to your users

**Firestore structure used in this app:**
```
notes (collection)
 └── {noteId} (document)
      ├── id: string
      ├── userId: string        // owner's Firebase Auth UID
      ├── title: string
      ├── description: string
      ├── createdAt: timestamp
      └── updatedAt: timestamp
```

**Recommended security rules** — restrict notes so users can only read/write their own:
```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, update, delete: if request.auth != null
                                    && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null
                     && request.auth.uid == request.resource.data.userId;
    }
  }
}
```
Paste these into Firebase Console → Firestore Database → **Rules** tab, then click **Publish**.

#### h. Add the required dependencies
Make sure these are in `pubspec.yaml` (the FlutterFire CLI usually adds the core ones automatically):
```yaml
dependencies:
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  toastification: ^latest
```
Then:
```bash
flutter pub get
```

### 4. Run the app
```bash
flutter run
```

---

### 5. Testing credentials
email- Sujan@gmail.com
password- Password@123

OR 
You can easily signup and create a new account and test the app!

---
## 📸 Screenshots

| Login | Signup | Dashboard |
|---|---|---|

<img width="453" height="793" alt="image" src="https://github.com/user-attachments/assets/ce86cde2-1427-45a5-82b0-a8bbef3e1d92" />
<img width="470" height="797" alt="image" src="https://github.com/user-attachments/assets/f5e7bf73-d383-44fd-9048-aa6e2188fa9e" />
<img width="454" height="795" alt="image" src="https://github.com/user-attachments/assets/017e31cc-34f8-45b9-9e77-5b11a2dd7b0a" />

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/YOUR_USERNAME/notes-manager/issues).

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Sujan**
- GitHub: [@actuallysujan](https://github.com/actuallysujan)
