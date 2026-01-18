# Firebase Setup Guide for Book Store App

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: "book-store-app"
4. Follow the setup wizard

## Step 2: Enable Authentication

1. In Firebase Console, navigate to Authentication
2. Click "Get Started"
3. Enable "Email/Password" sign-in method

## Step 3: Create Firestore Database

1. Navigate to Firestore Database
2. Click "Create Database"
3. Start in test mode (for development)
4. Choose your region

## Step 4: Set Firestore Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /cart/{cartId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    match /books/{bookId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

## Step 5: Add Sri Lankan Books Collection

The app includes 20 curated books featuring:
- Classic Sinhala literature by Martin Wickramasinghe
- Works by Kumaratunga Munidasa and G.B. Senanayake
- Contemporary Sri Lankan authors (Shehan Karunatilaka, Michael Ondaatje, etc.)
- Award-winning novels including Booker Prize winners

### Option 1: Use SampleDataHelper (Recommended)
Add this code to your main.dart temporarily after Firebase initialization:
```dart
import 'utils/sample_data.dart';

// In main() after Firebase.initializeApp():
SampleDataHelper.addSampleBooks();
```

### Option 2: Manual Entry
Add to Firestore Console (Books Collection):

```
Example Document:
{
  "title": "Gamperaliya",
  "author": "Martin Wickramasinghe",
  "description": "A landmark Sinhala novel depicting changing village life",
  "price": 850.00,
  "coverImage": "",
  "category": "Sinhala Classic",
  "rating": 4.9
}
```

Categories available:
- Sinhala Classic
- Sinhala Fiction
- Sinhala Essays
- Sri Lankan Fiction
- Memoir

Prices are in Sri Lankan Rupees (LKR)

## Step 6: Configure Flutter App

### For Android:
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/` directory

### For iOS:
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/` directory

## Step 7: Run the App

```bash
flutter pub get
flutter run
```

## Troubleshooting

- **Firebase not initialized**: Ensure Firebase configuration files are in the correct locations
- **Authentication errors**: Verify Email/Password authentication is enabled
- **Firestore permission errors**: Check Firestore security rules
- **No books showing**: Add sample books to Firestore database
