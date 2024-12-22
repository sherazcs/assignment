# assignment

# README

## App Description
This Flutter application provides a robust system for user authentication, data handling, and offline support. It leverages Firebase services and local caching to ensure seamless functionality, even without an internet connection. The app is built using Clean Architecture principles and features MVVM design, ensuring clarity and maintainability.

### Features
- **Authentication**: User registration, login, and logout using Firebase Authentication.
- **Data Handling**: CRUD operations for items (e.g., notes/tasks) stored in Firestore and cached locally using Drift.
- **Offline Support**: Access data offline with real-time syncing when connectivity is restored.
- **Navigation**: Intuitive screen transitions powered by `go_router`.
- **User Profile**: View user email and logout option.

---

## Setup Instructions

### Prerequisites
1. Install [Flutter](https://flutter.dev/docs/get-started/install).
2. Set up a Firebase project and enable the following:
   - **Firebase Authentication** (Email/Password).
   - **Firestore Database**.
3. Generate `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) from your Firebase project.

### Steps
1. Clone this repository:
   ```bash
   git clone <repository_url>
   cd <repository_folder>
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Add Firebase configuration files:
   - Place `google-services.json` in `android/app/`.
   - Place `GoogleService-Info.plist` in `ios/Runner/`.
4. Run the app:
   ```bash
   flutter run
   ```

---

## Architecture
The app follows **Clean Architecture** principles with three layers:
1. **Domain Layer**:
   - Contains business logic and entities.
2. **Data Layer**:
   - Manages repositories for Firestore and Drift.
   - Handles syncing between Firestore and local storage.
3. **Presentation Layer**:
   - Manages UI and state with `Riverpod`.

---

## State Management
- Uses `Riverpod` for efficient and scalable state management.
- Providers are defined and managed using `riverpod_generator`.

---

## Packages Used

| Package                | Purpose                                           |
|------------------------|---------------------------------------------------|
| **firebase_core**      | Initialize Firebase in the app.                  |
| **firebase_auth**      | User authentication (email/password).            |
| **cloud_firestore**    | Cloud Firestore for real-time data storage.       |
| **path_provider**      | Access device directories for storing files.      |
| **flutter_riverpod**   | State management.                                 |
| **go_router**          | Declarative navigation and deep linking.         |
| **connectivity_plus**  | Monitor network connectivity.                     |
| **drift**              | Local database for offline caching.              |
| **drift_sqflite**      | SQLite engine for Drift.                          |
| **sqflite**            | SQLite plugin for database management.            |
| **sqlite3_flutter_libs** | Native SQLite libraries for platform compatibility. |

---

## Testing
- Basic unit tests are implemented for:
  - Firestore and Drift repositories.
  - ViewModel logic for CRUD operations.
- Use mock data to validate database operations and state management.

---

## Folder Structure
```
lib/
├── src/
│   ├── domain/         # Business logic and entities
│   ├── data/           # Repositories and data sources
│   ├── presentation/   # UI and state management
│   └── app.dart        # App entry point
└── main.dart           # Firebase initialization
```

---
