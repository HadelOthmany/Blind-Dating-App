# 💕 Blind Dating App

A mobile dating application built with **Flutter and Dart** that allows users to create detailed profiles, discover other users, interact through likes and favorites, chat with other users, and report inappropriate behavior.

The project was created to explore mobile application development, user authentication, API communication, profile management, and interactive social features.

---

## 📱 About the Project

**Blind Dating App** is designed to help users discover and connect with other people through their profiles and interests.

Users can register an account, complete their dating profile, browse other profiles, like or favorite users, and communicate through the built-in messaging system.

The application also includes reporting and administration functionality to help manage inappropriate users.

---

## ✨ Features

### 👤 User Registration and Login

- Create a new account
- Email and password login
- Form validation
- Minimum password requirements
- 18+ age confirmation during registration
- Automatic profile completion check after login

### 📝 Detailed User Profiles

Users can create and update a profile containing information such as:

- Name and gender
- Birthdate
- City and country
- Profile heading
- What they are looking for in a partner
- Height and body type
- Profession
- Education
- Languages
- Nationality
- Lifestyle information
- Relationship preference
- Employment status
- Living situation
- Children
- Smoking and drinking preferences
- Willingness to relocate

The application requires users to complete their profile before accessing the main dating features.

### 💞 Discover Users

Users can browse other profiles through the application's discovery/swiping interface.

This makes it easy to explore different profiles and decide who they are interested in connecting with.

### ❤️ Likes

Users can:

- Like another profile
- View likes they have sent
- View likes they have received

### ⭐ Favorites

Interesting profiles can be saved as favorites.

Users can view:

- Favorites they have sent
- Favorites they have received

### 💬 Messaging

The application includes a messaging system where users can:

- View their conversations
- Open a chat with another user
- Send messages
- Retrieve previous messages

### 🚩 Reporting Users

Users can report other users when inappropriate behavior occurs.

Reports can include a reason explaining why the user was reported.

### 🛡️ Admin Functions

The application contains an administration area for handling reported users.

Administrators can:

- View reported users
- Review reports
- Ignore reports when no action is needed
- Block users
- View blocked users
- Unblock users

Blocked accounts are prevented from logging into the application.

---

## 🛠️ Technologies Used

- **Flutter**
- **Dart**
- **Material Design**
- **HTTP**
- **REST-style API communication**
- **PHP backend endpoints**
- **JSON**
- **Intl**
- **Get package**

---

## 🏗️ Project Structure

```text
dating app/
│
├── assets/
│
├── lib/
│   ├── main.dart
│   │
│   ├── screens/
│   │   ├── welcome_page.dart
│   │   ├── register_page.dart
│   │   ├── login_page.dart
│   │   ├── profile_page.dart
│   │   ├── home_page.dart
│   │   ├── swipping_screen.dart
│   │   ├── chatlist_screen.dart
│   │   ├── admin_page.dart
│   │   └── ...
│   │
│   ├── services/
│   │   └── api_service.dart
│   │
│   └── widgets/
│       └── ...
│
├── pubspec.yaml
└── README.md
```

---

## 🔄 Application Flow

```text
Welcome Page
     ↓
Registration / Login
     ↓
Profile Completion
     ↓
Main Application
     ↓
┌───────────────────────────────┐
│ Discover Profiles             │
│ Chats                         │
│ Favorites                     │
│ Likes                         │
│ User Profile                  │
└───────────────────────────────┘
```

Administrators are redirected to the administration area where reports and blocked users can be managed.

---

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have installed:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android Emulator or physical Android device

Check your Flutter installation with:

```bash
flutter doctor
```

---

## 📥 Installation

### 1. Clone the repository

```bash
git clone https://github.com/HadelOthmany/Blind-Dating-App.git
```

### 2. Open the project directory

```bash
cd Blind-Dating-App
cd "dating app"
```

### 3. Install Flutter packages

```bash
flutter pub get
```

### 4. Configure the API

The application communicates with a PHP backend through:

```text
lib/services/api_service.dart
```

Update the `baseUrl` inside `ApiService` so that it points to the server where the dating application backend is hosted.

Example:

```dart
final String baseUrl = "http://YOUR_SERVER/datingpro";
```

> The API address currently configured in the project points to a local/private network address, so it must be changed when running the application on another network or computer.

### 5. Run the application

```bash
flutter run
```

Select an emulator or connected device when prompted.

---

## 📦 Main Dependencies

The application uses several Flutter packages, including:

```yaml
http
intl
get
cupertino_icons
```

Run the following command whenever dependencies are changed:

```bash
flutter pub get
```

---

## 🎯 What I Learned

Through this project I gained practical experience with:

- Flutter application development
- Dart programming
- Creating reusable widgets
- Form validation
- User authentication workflows
- HTTP requests
- JSON data handling
- Connecting a mobile frontend to a backend API
- Managing application navigation
- Building detailed user profiles
- Implementing social features such as likes and favorites
- Creating a messaging system
- User reporting and moderation
- Admin functionality
- Organizing a larger Flutter project into screens, services, and widgets

---

## 🔮 Possible Future Improvements

Some possible improvements for the application include:

- Better matchmaking algorithms
- Profile pictures and image upload
- Push notifications
- Real-time chat
- Location-based matching
- Search and filtering
- More advanced authentication
- Password reset functionality
- Improved privacy and security
- Improved UI and animations
- Backend deployment to a public server
- Automated testing

---

## 👩‍💻 Author

**Hadel Othmany**

Computer Science graduate and software developer interested in mobile development, web development, backend systems, and software engineering.

GitHub: [HadelOthmany](https://github.com/HadelOthmany)

---

## 📌 Project Status

This project is a learning and portfolio project. Some functionality depends on the external backend API and may require additional configuration before the application can run on another machine.

---

⭐ If you find the project interesting, feel free to explore the repository!
