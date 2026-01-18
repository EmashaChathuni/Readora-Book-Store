# Book Store E-Commerce App

A Flutter mobile application for browsing, searching, and purchasing books with Firebase backend. Specially curated for Sri Lankan readers with a collection of famous Sinhala literature and Sri Lankan authors.

## Features

- User Authentication (Login/Signup)
- Browse Sri Lankan & Sinhala book catalog
- Search functionality
- Detailed book view with ratings
- Shopping cart management
- Secure checkout process
- Order history tracking

## Book Collection

The app features:
- Classic Sinhala literature (Martin Wickramasinghe, Kumaratunga Munidasa)
- Contemporary Sri Lankan fiction in English
- Award-winning Sri Lankan authors
- Traditional and modern Sinhala books
- Prices in Sri Lankan Rupees (LKR)

## Tech Stack

- Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Storage

## Setup Instructions

### Prerequisites
- Flutter SDK installed
- Firebase account
- Android Studio / VS Code

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a Firebase project
   - Add Android/iOS apps in Firebase console
   - Download configuration files:
     - `google-services.json` for Android (place in `android/app/`)
     - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)

4. Enable Firebase services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Firebase Storage

5. Add sample books to Firestore:
   Collection: `books`
   Fields: title, author, description, price (in LKR), coverImage, category, rating
   
   Use the SampleDataHelper.addSampleBooks() to automatically add 20 curated Sri Lankan books

### Sample Book Categories
- Sinhala Classic
- Sinhala Fiction
- Sinhala Essays
- Sri Lankan Fiction
- Memoir

### Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── models/
│   ├── book.dart
│   ├── cart_item.dart
│   ├── order.dart
│   └── user_model.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── book_detail_screen.dart
│   ├── cart_screen.dart
│   └── orders_screen.dart
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── widgets/
│   ├── book_card.dart
│   ├── custom_button.dart
│   └── custom_text_field.dart
└── utils/
    └── constants.dart
```

## Color Scheme

- Primary Brown: #3E2723
- Secondary Brown: #5D4037
- Light Brown: #8D6E63
- Accent Gold: #D4A574
- Background Dark: #2C1810
- Card Brown: #4E342E
- Text Light: #FFF8E1
