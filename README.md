# calculator_app

This is an application for the Kraepelin test.

## Overview
This Flutter application provides a simple math training platform where users can practice single-digit calculations. The app integrates Firebase Authentication for user registration and login, Firestore for storing user progress, and SharedPreferences for local data storage.

## Enjoy playing this app!

- iOS: 
https://dply.me/zlbb4e

- Android: 
https://dply.me/n6ob9e

## Features
- **User Authentication:** Register and log in using Firebase Authentication.
- **Persistent User Data:** Store email and password locally using SharedPreferences.
- **Math Training:** Users can practice simple arithmetic problems.
- **Real-time Progress Tracking:** Displays the current problem number and correctness.
- **Performance Storage:** Saves user progress and results to Firebase Firestore.

## Technologies Used
- Flutter
- Firebase (Authentication, Firestore, Core)
- SharedPreferences
- RxDart
- Intl (for date formatting)
- Dart async & math libraries

## Setup and Installation
```sh
# Clone the repository
git clone <repository_url>
cd <repository_folder>

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/u).

2. Enable Authentication with Email/Password.

3. Set up Cloud Firestore.

## Code Structure
```sh
main.dart
 ├── Initializes Firebase
 ├── Runs MyApp widget

LoginPage.dart
 ├── Implements user login and registration
 ├── Saves credentials locally using SharedPreferences
 ├── Navigates to the main training screen upon successful authentication

_start.dart
 ├── A transition screen before the main training page

MyHomePage.dart
 ├── Contains the math training logic
 ├── Displays a sequence of single-digit addition problems
 ├── Tracks the user's progress and performance
 ├── Saves results in Firestore
```
## Usage
```sh
1. Sign up using an email and password.
2. Log in with the registered credentials.
3. Start training: Solve math problems displayed on the screen.
4. Results storage: The app tracks correct answers and saves progress.
5. Session completion: After a set number of problems, results are saved in Firestore.
```

## Firebase Firestore Structure
```sh
user2023 (collection)
    ├── user_email (document)
        ├── timestamp (field)
            ├── answer: total answered
            ├── correct: total correct
            ├── 0~1 ans: answers in the first minute
            ├── 0~1 cor: correct answers in the first minute
            ├── ... (similar fields for different time intervals)
```
