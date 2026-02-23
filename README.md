# Smart Task Manager

A Flutter task management app with Firebase Auth, Firestore for user profile, and REST API for tasks. Uses Riverpod for state management and supports offline caching.

## Features

- **Authentication:** Email/password login & registration, logout, persistent session  
- **User Profile:** Stored in Firestore (`users/{userId}`) with `name`, `email`, `themeMode`, supports dark/light mode  
- **Tasks:** CRUD via REST API (`https://taskmanager.uat-lplusltd.com`), client-side filtering & search, infinite scroll, optimistic updates  
- **Offline:** Cache tasks locally (Hive/SQLite optional), sync when online  
- **State Management:** Riverpod with proper loading & error handling  

## Setup

1. Clone the repo:  
```bash
git clone <repo_url>
cd smart_task_manager
flutter pub get


Firebase: Add google-services.json / GoogleService-Info.plist and enable Email/Password Auth

Firestore rules:

service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}

service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}