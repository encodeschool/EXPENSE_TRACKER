# Expense Tracker App 💰

Expense Tracker is a Flutter-based mobile application that helps you track daily expenses efficiently. Monitor your spending, view weekly summaries, and manage your finances in one simple and intuitive interface.

## 📱 Features
- Add Expenses: Quickly add new expenses with name, amount, and date.
- Edit & Delete: Modify or remove existing expenses with ease.
- Undo Delete: Accidentally deleted an expense? Undo it from the SnackBar.
- Weekly Summary: View total expenses for each day of the current week.
- Animated UI: Smooth animations for adding, editing, deleting expenses, and countdown SnackBar.
- Slidable List Items: Swipe left or right on expenses to quickly delete or edit.
- Dark Mode: Toggle between light and dark themes.
- Persistent Data: All expenses and theme settings are saved locally using Hive.
- Responsive & User-Friendly: Works on all mobile devices with intuitive gestures.

## 🛠 Tech Stack
- Flutter & Dart: For cross-platform mobile development.
- Provider: State management.
- Hive: Local database for persistent storage.
- Flutter Slidable: Swipeable expense list items.
- Confetti & Animations: Animated UI elements for user experience.

## 📥 Installation
1. Clone the repository:
```bash
git clone <your-repo-url>
```

2. Navigate to the project directory:
```bash
cd expense_tracker
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## 🧩 Usage
1. Launch the app.
2. Tap the ➕ Add Expense button to create a new expense.
3. Swipe an expense left or right to edit or delete it.
4. View your weekly summary at the top.
5. Toggle dark mode from settings to switch themes.
6. Deleted expenses can be undone from the SnackBar before it disappears.

## 💾 Data Storage
- All expenses are stored locally using Hive, ensuring your data is persistent across app restarts.
- Theme preference (light/dark) is also saved in Hive for automatic restoration.

## 🎨 Screenshots

## 📌 Future Enhancements
- Monthly and yearly expense summaries
- Export expenses to CSV or PDF
- Graphical charts for better visualization
- Notifications for exceeding budget
- Multi-currency support

## 📄 License

This project is licensed under the MIT License – see the LICENSE
file for details.