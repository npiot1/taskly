# 📝 Taskly

**Taskly** is a modern mobile task management application built with **Flutter**. It provides a clean and efficient interface to help users organize their daily activities, manage tasks, and personalize their account settings.

---

## ✨ Key Features

### 🔐 Authentication (via Firebase)
- Sign up / Login / Logout
- Email & password authentication

### 📋 Task Management
- Create / edit / delete tasks
- Mark tasks as completed
- Set due dates for tasks

### 👤 User Account
- Update email, display name, password
- Account deletion
- Add a profile picture (from a URL or gallery)

### ⚙️ Custom Settings
- Toggle between dark and light theme
- Show or hide completed tasks

---

## 🛠️ Tech Stack

| Category               | Tools & Libraries                             |
|------------------------|-----------------------------------------------|
| **Language**           | Flutter & Dart                                |
| **State Management**   | [Riverpod](https://riverpod.dev)              |
| **Backend Services**   | [Firebase Auth](https://firebase.google.com/docs/auth), [Cloud Firestore](https://firebase.google.com/docs/firestore) |
| **Code Generation**    | [Freezed](https://pub.dev/packages/freezed)   |
| **Local Storage**      | [Hive](https://pub.dev/packages/hive)         |
| **Routing**            | [Go Router](https://pub.dev/packages/go_router) |
| **Media Picker**       | [Image Picker](https://pub.dev/packages/image_picker) |

---

## 📆 TODO (In Progress)

- ⏰ Local notifications for task due dates  
- ⚠️ Warn users about unsaved changes  
- 🎨 UI improvements and refinements, especially on the task list in the home screen
- 🛠️ Organize tasks by theme and be able to create themes (personal, professional, home tasks)

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/votre-utilisateur/taskly.git
cd taskly
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Required Files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the app

```bash
flutter run
```

---

## 📸 Screenshots

Here are some previews of the Taskly app interface:


| Login | Sign Up |
|-------|---------|
| ![Login](https://github.com/npiot1/taskly/blob/be5cd1613d50d6bf9aed969b06fda5dd776433d7/assets/readme/login.png?raw=true) | ![Signup](https://github.com/npiot1/taskly/blob/be5cd1613d50d6bf9aed969b06fda5dd776433d7/assets/readme/signup.png?raw=true) |

| Home | Drawer |
|------|--------|
| ![Home](https://github.com/npiot1/taskly/blob/be5cd1613d50d6bf9aed969b06fda5dd776433d7/assets/readme/home.png?raw=true) | ![Drawer](https://github.com/npiot1/taskly/blob/be5cd1613d50d6bf9aed969b06fda5dd776433d7/assets/readme/drawer.png?raw=true) |

| Create Task | Edit Task |
|-------------|-----------|
| ![Create](https://github.com/npiot1/taskly/blob/be5cd1613d50d6bf9aed969b06fda5dd776433d7/assets/readme/create.png?raw=true) | ![Edit](https://github.com/npiot1/taskly/blob/be5cd1613d50d6bf9aed969b06fda5dd776433d7/assets/readme/edit.png?raw=true) |

| Account | Settings |
|---------|----------|
| ![Account](https://github.com/npiot1/taskly/blob/be5cd1613d50d6bf9aed969b06fda5dd776433d7/assets/readme/account.png?raw=true) | ![Settings](https://github.com/npiot1/taskly/blob/be5cd1613d50d6bf9aed969b06fda5dd776433d7/assets/readme/settings.png?raw=true) |

---

## 📄 Licence

This project is released under the MIT License.
Feel free to use, modify, and share it as needed.

