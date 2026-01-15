# Deep
A high-quality, offline question game designed to provoke thought and conversation.

## Features
- **Offline First**: No internet required. All 4 categories (The Void, The Mirror, The Taboo, The End) are built-in.
- **Fluid Gestures**:
    - **Swipe Left**: Next Question.
    - **Swipe Right**: Previous Question (with History support).
    - **Swipe Up**: Add to Favorites.
    - **Swipe Down**: Ban Question (Never show again).
- **"Squishy" Physics**: Interactive card animations with squash and stretch effects.
- **Favorites**: Save and review your favorite questions.
- **Persistence**: Game state and favorites are saved automatically.

## Tech Stack
- **Framework**: Flutter
- **State Management**: Riverpod
- **Storage**: SharedPreferences
- **Animations**: Flutter Animate + Custom Physics

## Getting Started

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Code Generation** (if you modify providers)
   ```bash
   dart run build_runner build
   ```

## Project Structure
- `lib/data`: Hardcoded question data.
- `lib/models`: Data models.
- `lib/providers`: Riverpod state management.
- `lib/screens`: UI Screens (Start, Game, Favorites).

## Gestures Guide
- **Drag Left/Right**: Navigate questions.
- **Drag Up**: Heart icon appears -> Favorites.
- **Drag Down**: Trash icon appears -> Ban.
