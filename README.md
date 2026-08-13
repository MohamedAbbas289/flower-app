# 🌸 Flower Store App

A collaborative Flutter e-commerce application developed as part of a team project for an online flower-shopping platform.

The application provides product discovery, categories, search and sorting, orders, authentication, profile functionality, caching, and other e-commerce features while following a layered and testable architecture.

> **Team Project:** This application was developed collaboratively using feature branches, pull requests, code reviews, CI workflows, and a Clean Architecture approach. My personal contributions are documented below.

## 👨‍💻 My Contributions

### 🔐 Authentication & Login

Contributed to the authentication flow and login experience.

* Implemented login-related functionality.
* Integrated authentication logic with application state management.
* Improved login loading behavior using **BLoC**.
* Displayed a loading indicator while authentication requests are in progress.
* Disabled repeated login submissions while a request is running.

### 🚪 Logout

Implemented the logout feature across multiple architectural layers.

* Added `LogoutApiClient`.
* Implemented the logout Remote Data Source.
* Implemented Repository and ViewModel logic.
* Created a logout confirmation dialog.
* Integrated logout functionality with the Profile screen.

### 💾 API Caching & Refresh

Improved application data loading and network efficiency.

* Enhanced the application's custom **SmartCacheInterceptor**.
* Added cache behavior for:

  * Home
  * Best Sellers
  * Occasions
* Used **Dio Cache Interceptor** with persistent cache storage.
* Added pull-to-refresh functionality to multiple application sections.
* Updated relevant ViewModels and Cubits to support explicit data refreshing.
* Reduced unnecessary network requests while still allowing users to request fresh data.

### 📦 Orders

Implemented the Orders feature end-to-end using Clean Architecture.

* Added Orders API integration using **Retrofit**.
* Implemented:

  * Remote Data Source
  * Repository
  * Use Case
  * Domain entities
  * Data models and mappers
* Developed an `OrdersViewModel` using **Cubit**.
* Implemented filtering between:

  * Active orders
  * Completed orders
* Built reusable UI components for different order states.
* Added navigation from the Profile section.
* Added Arabic and English localization.
* Added comprehensive **unit tests** for:

  * Data Source
  * Repository
  * Use Case
  * ViewModel

### 🔎 Product Sorting & Filtering

Implemented sorting functionality for product categories.

* Added sorting support throughout:

  * Request models
  * Repository
  * Remote Data Source
  * API Client
  * Use Case
  * ViewModel
* Added sorting by product properties such as:

  * Price
  * Date
  * Discount
* Implemented client-side result reversal when required.
* Integrated the sorting flow with the Categories filter bottom sheet.
* Persisted the selected sorting state in the feature state.
* Updated unit tests to cover the new sorting behavior.

### 🔍 Product Search

Implemented a complete product-search flow.

* Created a Retrofit-based Search API client.
* Implemented Remote Data Source and Repository layers.
* Added a dedicated Search Use Case.
* Implemented a Cubit-based Search ViewModel.
* Added **debounced search** behavior to avoid excessive API calls.
* Implemented clearing and refreshing search results.
* Created the Search screen with:

  * Search input
  * Loading states
  * Product results grid
* Added navigation from Home and Categories.
* Added Arabic and English localization.
* Added unit tests across the feature layers.

> The search contribution was submitted through a pull request in the original team repository; the PR was closed without a direct merge.

### 🔥 Firebase Crash Reporting & Analytics

Added production-oriented monitoring infrastructure.

* Integrated **Firebase Core**.
* Added **Firebase Crashlytics**.
* Added **Firebase Analytics**.
* Configured FlutterFire for Android.
* Implemented global error reporting for:

  * Flutter framework errors
  * Platform-level errors
* Added the required Firebase configuration and Gradle integration.

### ⚙️ CI/CD – Pull Request Validation

Implemented GitHub Actions automation for the team's development workflow.

* Added a **GitHub Actions** workflow for validating pull-request titles.
* Enforced a structured PR title convention based on:

  * Change type
  * Project/ticket number
  * Task description
* Added validation for allowed development types such as:

  * `feat`
  * `fix`
  * `build`
  * `test`
  * `release`
  * `hotfix`

This helped keep the team's Git and Jira workflow consistent.

## 🔄 Team Workflow

Development was organized around dedicated feature branches and pull requests.

Some of my contribution branches include:

```text
feature-login
ci/validate-pr-title-action
feature/logout-and-caching
feature/firebase_setup
feature/orders
feature/sort
feature/search
feature/categories
```

Several of my contributions were reviewed and merged into the team's `develop` branch, including authentication, CI automation, caching/logout, Firebase monitoring, orders, and product sorting.

This project provided practical experience with:

* Feature ownership
* Pull requests and code reviews
* Collaborative Git workflows
* Jira-style ticket-based development
* CI automation
* Clean Architecture
* Automated testing
* Production monitoring
* Refactoring shared application code

## 🛠️ Tech Stack

* **Flutter & Dart**
* **BLoC / Cubit**
* **Clean Architecture**
* **Dio**
* **Retrofit**
* **Dio Cache Interceptor**
* **Hive Cache Store**
* **GetIt**
* **Injectable**
* **Equatable**
* **Firebase Core**
* **Firebase Crashlytics**
* **Firebase Analytics**
* **Firebase Messaging**
* **Flutter Secure Storage**
* **Hive**
* **Easy Localization**
* **Google Maps**
* **Geolocator**
* **Image Picker**
* **JSON Serialization**
* **Mockito**
* **bloc_test**
* **GitHub Actions**
* **Git & GitHub**

## 🏗️ Architecture

The application follows a feature-oriented Clean Architecture structure:

```text
Presentation
    ↓
Domain
    ↓
Data
    ↓
Remote / Local Data Sources
```

Typical feature flow:

```text
UI / Screen
    ↓
BLoC / Cubit / ViewModel
    ↓
Use Case
    ↓
Repository
    ↓
Remote / Local Data Source
    ↓
Dio / Retrofit API
```

This approach improves separation of concerns, maintainability, scalability, and testability.

## ✨ Application Features

The overall team application includes functionality such as:

* Authentication
* Product discovery
* Product categories
* Best sellers
* Occasions
* Product search
* Product sorting and filtering
* Orders
* User profiles
* Logout
* API caching
* Pull-to-refresh
* Notifications
* Location and maps functionality
* Arabic & English localization
* Firebase analytics
* Crash reporting

## 🧪 Testing

The project uses automated testing with tools including:

* `flutter_test`
* `bloc_test`
* `mockito`

My contributions included tests across multiple architectural layers, including:

* Remote Data Sources
* Repositories
* Use Cases
* BLoC / Cubit / ViewModels
* API behavior
* Sorting logic
* Search behavior
* Orders

## 🚀 Getting Started

```bash
git clone https://github.com/MohamedAbbas289/flower-app.git
cd flower-app
flutter pub get
flutter run
```

## 🧪 Run Tests

```bash
flutter test
```

## 🤝 Collaboration

This repository is a fork of the original team project and is included in my GitHub portfolio to showcase my personal contributions.

The original application was developed collaboratively. The **My Contributions** section documents the features and technical areas that I personally implemented or contributed to.

Merged contributions are distinguished from pull requests that were submitted but not directly merged.
