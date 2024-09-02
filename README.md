# MyNotes Flutter Application

Welcome to the MyNotes Flutter Application! This is a simple notes app built with Flutter, featuring state management using Bloc, secure authentication, and database management with SQLite and Firebase.

## Features

- **CRUD Operations**: Create, read, update, and delete notes.
- **Authentication**: Secure login and registration using Firebase.
- **State Management**: Managed using the Bloc pattern.
- **Database**: Local storage with SQLite, optional cloud sync with Firebase.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase Account](https://firebase.google.com/)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/mynotes.git
cd mynotes
```

# Install dependencies
flutter pub get

# Set up Firebase
 1. Create a new project in the Firebase Console: https://console.firebase.google.com/
 2. Add Android/iOS apps to your project.
 3. Download `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS)
 4. Place them in the appropriate directories in your Flutter project.

# Run the application
```bash
flutter run
```
