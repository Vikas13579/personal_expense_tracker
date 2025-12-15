# Personal Expense Tracker (Flutter)

A clean and offline-first personal expense tracking application built using Flutter and Hive.  
This project is actively developed with daily improvements and feature additions.



## ✨ Features

- Add, edit, and delete expenses
- Monthly budget tracking
- Daily / Monthly / Yearly expense summary
- Category-wise expense visualization (Pie Chart)
- Search expenses by title
- Swipe to delete with **UNDO**
- Offline storage using Hive
- Clean and modular project structure



## 🛠 Tech Stack

- Flutter (Material 3)
- Dart
- Hive – local database
- fl_chart – charts & graphs
- Google Fonts



## 📂 Project Structure

lib/
├── data/
│ └── models/
│ └── transaction_model.dart
│
├── services/
│ └── hive_service.dart
│
├── screens/
│ └── home/
│ └── home_screen.dart
│
├── shared/
│ └── widgets/
│ ├── expense_list.dart
│ ├── expense_bottom_sheet.dart
│ ├── header_section.dart
│ ├── month_selector.dart
│ ├── bento_section.dart
│ ├── search_bar.dart
│ └── category_pie.dart
│
└── main.dart





## 🚧 Status

This project is **actively maintained**.  
Planned improvements include:
- Monthly reset logic
- Export to CSV / PDF
- Dark mode
- Bloc state management
- Cloud sync (future)



## 👨‍💻 Author

Developed by Vikas P Shetty  
Flutter Developer