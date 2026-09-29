<div align="center">

# 💸 Expense Tracker

**A simple, clean expense tracker app built with Flutter and Firebase**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

Made for the **CyphLab Flutter Developer Internship** practical task 🚀

</div>

---

## 📖 About

Expense Tracker helps you record what you spend, see your total for the month, and find any expense fast with search and filters. Every user signs in with their own account, and their expenses are saved safely in the cloud.

---

## 📸 Screenshots

| 🔐 Sign in | 🏠 Home | ➕ Add expense |
|:---:|:---:|:---:|
| <img src="screenshots/login.png" width="220"> | <img src="screenshots/home.png" width="220"> | <img src="screenshots/add-expense.png" width="220"> |

| 📊 Monthly chart | 🌙 Dark mode |
|:---:|:---:|
| <img src="screenshots/chart.png" width="220"> | <img src="screenshots/dark-mode.png" width="220"> |

---

## ✨ Features

### ✅ Required features

| | Feature | Status |
|---|---|:---:|
| ➕ | Add new expenses | ✅ |
| ✏️ | Edit existing expenses | ✅ |
| 🗑️ | Delete expenses | ✅ |
| 🏷️ | Select an expense category | ✅ |
| ☁️ | Store expenses in Firebase (Cloud Firestore) | ✅ |
| 📅 | Total expenses for the current month | ✅ |
| 📋 | Expense history list (newest first) | ✅ |
| 🔎 | Filter by category and by date range | ✅ |
| 🛡️ | Form validation | ✅ |
| ⏳ | Loading, empty, and error states | ✅ |

Each expense has: **title**, **amount**, **category**, **date**, and an optional **note**.

### 🎁 Extra features

| | Feature |
|---|---|
| 🔐 | Email and password login: register, sign in, sign out, forgot password |
| 👤 | Every user sees only their own expenses |
| 🔍 | Search by title or note |
| 📊 | Monthly category chart (pie chart) |
| 🌙 | Dark mode |
| 👆 | Swipe to delete, with a confirmation message |
| 🎞️ | Animated list and animated monthly total |
| 🎨 | Custom app icon, app name, and Inter font |

---

## 🛠️ Tech stack

| Technology | Used for |
|---|---|
| 💙 **Flutter** (Material 3) and **Dart** | The app and its design |
| 🔥 **Firebase Authentication** | Register and sign in |
| 🗄️ **Cloud Firestore** | Saving expenses in the cloud |
| 🧩 `provider` | State management |
| 📈 `fl_chart` | The category pie chart |
| 🔤 `google_fonts` | Inter font |
| 🌍 `intl` | Date and currency format |
| 🖼️ `flutter_launcher_icons` | App icon |

---

## 🗂️ Project structure

```
lib/
├── main.dart                     App start, login check, theme
├── firebase_options.dart         Firebase settings (made by flutterfire configure)
├── models/
│   └── expense.dart              Expense data model
├── services/
│   ├── auth_service.dart         Firebase Authentication
│   └── expense_service.dart      Firestore add / edit / delete / read
├── providers/
│   ├── expense_provider.dart     Expense state, filters, totals
│   └── theme_provider.dart       Dark mode
├── screens/
│   ├── auth_screen.dart          Sign in and create account
│   ├── home_screen.dart          Main list, total, filters
│   ├── add_edit_expense_screen.dart
│   └── summary_screen.dart       Category chart
├── widgets/                      Reusable UI parts
└── utils/                        Categories and formatters
```

---

## 🔥 How the data is stored

Firestore path: `users/{userId}/expenses/{expenseId}`

| Field | Type |
|---|---|
| `title` | string |
| `amount` | number |
| `category` | string |
| `date` | timestamp |
| `note` | string |

---

## 🚀 Getting started

### 1️⃣ Install Flutter
Install Flutter (version 3 or newer) and run `flutter doctor`.

### 2️⃣ Get the project
```bash
git clone <https://github.com/ChathuminiAththanayake/expense-tracker>
cd expense_tracker
flutter pub get
```

### 3️⃣ Firebase
`lib/firebase_options.dart` is included, so the app connects to the author's Firebase project.

To use **your own** Firebase project instead:
1. Create a project at https://console.firebase.google.com
2. Turn on **Cloud Firestore**
3. Turn on **Authentication → Sign-in method → Email/Password**
4. Run `flutterfire configure` in the project folder
5. Copy the rules from `firestore.rules` into the Firestore **Rules** tab and click **Publish**

### 4️⃣ Run the app
```bash
flutter run
```


## 🔒 Security

`firestore.rules` makes sure each signed-in user can only read and write **their own** expenses.

---

## 🤖 AI tools used

I used **Claude (Anthropic)** as my AI assistant while building this project. It helped me with:

- 🧱 **Planning:** folder structure and Firestore data design
- ✍️ **Coding:** the first version of the models, services, provider, screens, and widgets
- 🐛 **Debugging:** Gradle, NDK, and Firebase setup problems, and Provider errors
- 🎨 **UI design:** theme colors, Inter font, filter buttons, and animations
- 🔐 **Authentication:** email and password login, register, and sign out

I set up Firebase myself, tested every feature on an Android emulator, checked the saved data in the Firebase console, and reviewed the code so I can explain and modify it.

---

## 🔮 Future improvements

- 📧 Email verification after registration
- 💰 Monthly budget limits with a warning
- 📤 Export expenses to CSV
- 💱 Choose the currency
- 🧪 Unit and widget tests

---

<div align="center">

Made with ❤️ and Flutter by **Chathumini Aththanayake**

</div>
