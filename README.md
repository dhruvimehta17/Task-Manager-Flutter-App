# crud_module

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Task-Manager-Flutter-App
A responsive and modern Flutter app for managing personal or team tasks, built using the BLoC architecture. It supports full CRUD operations with both offline persistence (Hive) and optional REST API integration.

# Features
- Add, edit, delete tasks
- Status & priority management
- Offline support using Hive
- Optional REST API integration
- BLoC architecture with flutter_bloc
- Responsive and clean UI
- Snackbar & confirmation feedback

# Setup Instructions
1. Prerequisites

Flutter SDK (3.x recommended)

Dart

Code editor (VS Code or Android Studio)

Internet (if using remote API)

2. Install dependencies

flutter pub get

3. Generate Hive adapters

flutter packages pub run build_runner build

4. Run the app

flutter run -d chrome

or

flutter run -d emulator-5554


API Endpoints (Optional)
- If using a remote API like crudcrud.com:
- GET /tasks – fetch all tasks
- POST /tasks – add a new task
- PUT /tasks/:id – update task
- DELETE /tasks/:id – delete task

Update your task_api_service.dart with:

const apiUrl = 'https://crudcrud.com/api/YOUR_API_KEY_HERE';

# Architecture Overview
Layered Structure:

lib/

├── data/

│   ├── models/           

│   ├── datasources/      

│   └── repositories/     

├── logic/

│   └── cubits/           

├── presentation/

│   ├── screens/          

│   └── widgets/          

├── main.dart             

# Testing Instructions
Unit Tests

Create unit tests under /test directory for:
- Task repository
- Cubit logic
- Run:

flutter test

Manual Testing
- Try adding, editing, and deleting tasks
- Toggle between API/local modes (in main.dart)
- Check offline behavior (Hive only mode)

# Usage Instructions
- Tap ➕ to add a task
- Tap a task to edit
- Tap 🗑️ to delete (with confirmation)
- Tasks are sorted by priority (1 is highest)
- Status: Pending / In Progress / Done

