# hipsterassignment

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Hipster Assignment

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## According to Mail

### 1. Login Page
- I have allowed 2 users:
  - **Email:** `test@gmail.com` | **Password:** `Kgs@123`
  - **Email:** `test1@gmail.com` | **Password:** `Abc@123`
- Only these credentials can be used to login.
- If you want more credentials, they can be added later and I will manage through backend API.

---

### 2. Agora Setup
- Working 1-to-1 call API integration.
- Go to [Agora Console](https://console.agora.io/project-management), login with your credentials, and create an Agora project.
- You will get an **AppId**, which needs to be integrated into the Flutter Android project.
- There is an `apidata` file where all the constraint data is shown and can be configured.

---

### 3. User List Page
- The user list is using a **fake API** so we can test data.
- Hive plugin is used — if internet is not available, cached list will still be shown.
- GraphQL is used to fetch API data from the fake API.

---

### 4. Generate Keystore for Play Store (Sign APK)
Use this command:

```bash
keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

Follow the prompts (example values used in this project):

Name: Hipster
Organizational Unit: Hipster
Organization: Hipster
City: Noida
State: UP
Country Code: 91

5. Notification
Backend API URL is attached to send notification.
In notification_service, you can register 2 tokens.
Once 1 person calls, the other device will receive a push notification.
If the app is in background, the notification will still arrive and allow joining the call.

6. Note
Initially I set up AWS Chime Services.
But AWS Chime video is not allowed in India.
Access key and secret key were tested (now removed for security)
AWS Console used earlier: https://476057873255.signin.aws.amazon.com/console

7. Backend API
Push notification handled using NestJS API.
AWS Chime 1-to-1 join meeting API also created.

8. Bonus (Optional, but Valuable)
Runtime permissions handled in SplashScreen.
notification_controller manages push notifications.
State management: GetX and Provider used.
CI/CD setup done (issue with AWS plugin caused CI/CD failure, but Agora flow will work fine if AWS code removed).

9. Deliverables
Source code updated to Git (frontend and backend).
Agora setup: use agora_rtc_engine package.
Register your AppId from Agora console.
Currently 2 Firebase tokens are registered in Flutter code (you can add your own).

Logs print out the tokens for verification.
Build command:
flutter build apk
To add Agora plugin:
flutter pub add agora_rtc_engine

10. Evaluation Criteria
Code quality can be checked from both frontend and backend repositories.
Git Repositories
Flutter Frontend: git@github.com:sunilkrsingh8922/aws-chemi-flutter.git
NestJS Backend API: git@github.com:sunilkrsingh8922/aws-chemi-nestjs.git
