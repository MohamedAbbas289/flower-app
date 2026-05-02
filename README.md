# 🌸 Flower App

A modern Flutter application built with **Clean Architecture**, **Cubit state management**, and **API integration**.

---

## 🚀 Features

* User Authentication (Register / Login / Reset Password)
* Profile Management (View & Update Profile)
* API Integration using Dio
* State Management using Cubit (Bloc)
* Clean and scalable architecture

---

## 🏗️ Project Structure

```
lib/
│
├── core/
├── config/
├── features/
│   ├── auth/
│   ├── profile/
│   └── home/
```

---

## 🔥 Git Workflow

### 🌿 Branching Strategy

We follow a simple and clean branching strategy:

* `main` → Production-ready code
* `develop` → Ongoing development
* `feature/*` → New features

---

### ✨ Branch Naming

Create a new branch for each task:

```
feature/login-screen
feature/profile-edit
feature/api-integration
```

---

### 🔄 Workflow Steps

1. Checkout develop branch:

```
git checkout develop
git pull
```

2. Create a new feature branch:

```
git checkout -b feature/your-feature-name
```

3. Work on your task and commit:

```
git add .
git commit -m "feat: add login screen"
```

4. Push your branch:

```
git push origin feature/your-feature-name
```

5. Create a Pull Request:

```
feature/your-feature-name → develop
```

6. Wait for review and approval ✅

---

## ⚠️ Rules

* ❌ Do NOT push directly to `main`
* ❌ Do NOT push directly to `develop`
* ✅ Always use feature branches
* ✅ Create a Pull Request before merging
* ✅ At least 1 approval is required

---

## 🧾 Commit Message Convention

Use clear commit messages:

```
feat: add new feature
fix: resolve bug
refactor: improve code structure
```

---

## 🧠 Tech Stack

* Flutter
* Dart
* Dio
* Bloc / Cubit
* Clean Architecture

---

## 📌 Notes

* Follow clean code principles
* Keep your code modular and readable
* Write meaningful commit messages
* Review code before merging

---

## 💙 Team Workflow

This project follows a collaborative workflow:

* Code review is required
* PR approval is mandatory
* Clean and maintainable code is a priority

---

## 📬 Contact

For any questions or collaboration, feel free to reach out.

---
