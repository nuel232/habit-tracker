# Habit Tracker

A simple and customizable habit tracking app built with Flutter. Track your daily habits, visualize your progress, and stay motivated!

## Features

- Add, edit, and delete daily habits
- Mark habits as completed for each day
- Visualize your habit streaks with a heatmap calendar
- Persistent local storage using Hive
- Light and dark mode support (toggle in the drawer)
- Intuitive and modern UI

## Screenshots
<!-- Add screenshots here if available -->

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart 3.8.1 or higher

### Installation

1. Clone this repository:

   ```bash
   git clone <repo-url>
   cd habit_tracker
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Generate Hive type adapters (if needed):

   ```bash
   flutter pub run build_runner build
   ```

4. Run the app:

   ```bash
   flutter run
   ```

## Project Structure

- `lib/`
  - `components/` – UI widgets (habit tile, heatmap, drawer)
  - `database/` – Hive database logic
  - `models/` – Data models for habits and app settings
  - `pages/` – Main app pages
  - `theme/` – Light/dark mode themes and provider
  - `util/` – Utility functions

## Dependencies

- [provider](https://pub.dev/packages/provider)
- [hive](https://pub.dev/packages/hive)
- [hive_flutter](https://pub.dev/packages/hive_flutter)
- [flutter_slidable](https://pub.dev/packages/flutter_slidable)
- [flutter_heatmap_calendar](https://pub.dev/packages/flutter_heatmap_calendar)
