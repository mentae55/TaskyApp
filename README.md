# 📱 TaskyApp

> **TaskyApp** is a modern task management app (To-Do App) designed to help you stay organized and boost your productivity.

---

## 📸 Screenshots  

Add your screenshots inside the `assets/screenshots/` folder, then reference them here:

- Screenshots 
  ![Home Screen](./assets/screenshots/home.png)  

---

## 📋 Table of Contents

- [Features](#-features)  
- [Tech Stack](#-tech-stack)  
- [Installation](#-installation)  
- [Usage](#-usage)  
- [Project Structure](#-project-structure)  
- [Contributing](#-contributing)  
- [License](#-license)  
- [Support](#-support)  

---

## 🔑 Features

- 📝 Create, edit, and delete tasks  
- ⏰ Add due dates and reminders  
- 📊 Set task priority (Low / Medium / High)  
- 📂 Categorize tasks into projects or groups  
- 💾 Persistent local storage with **AsyncStorage**  
- 🎨 Clean, responsive UI for both Android and iOS  

---

## 🛠 Tech Stack

- **React Native**  
- **Redux Toolkit** for state management  
- **React Navigation** for screen navigation  
- **AsyncStorage** for local storage  
- **Vector Icons** for icons  

---

## 🚀 Installation

### Prerequisites
- Node.js ≥ 14  
- npm or yarn  
- Android Studio (or Xcode for iOS)  
- React Native CLI  

### Steps
```bash
git clone https://github.com/mentae55/TaskyApp.git
cd TaskyApp
npm install   # or yarn install
Start Metro bundler:

bash
Copy code
npx react-native start
Run on Android:

bash
Copy code
npx react-native run-android
Run on iOS (macOS only):

bash
Copy code
npx react-native run-ios
⚙️ Usage
➕ Add Task: Tap the add button and fill in task details

👀 View Tasks: Tasks are listed on the home screen

✏️ Edit Task: Tap on a task to modify details

✅ Complete or Delete: Mark tasks as done or remove them

📂 Project Structure
bash
Copy code
TaskyApp/
├── android/
├── ios/
├── assets/
│   └── screenshots/   # App screenshots
├── src/
│   ├── components/    # Reusable components
│   ├── screens/       # App screens
│   ├── store/         # Redux slices & configuration
│   ├── navigation/    # React Navigation setup
│   └── utils/         # Helpers & constants
├── package.json
└── README.md
