#<img width="1536" height="1536" alt="Gemini_Generated_Image_qwsjgmqwsjgmqwsj" src="https://github.com/user-attachments/assets/693256b8-88e6-4f6d-b419-be4cdf132706" />

 Deep
A high-quality, offline question game designed to provoke thought and conversation.

## Features
- **Offline First**: No internet required. All 4 categories (The Void, The Mirror, The Taboo, The End) are built-in.
- **Fluid Gestures**:
    - **Swipe Left**: Next Question.
    - **Swipe Right**: Previous Question (with History support).
    - **Swipe Up**: Add to Favorites.
    - **Swipe Down**: Ban Question (Never show again).
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

<img width="2567" height="1209" alt="Gemini_Generated_Image_qz2q0tqz2q0tqz2q" src="https://github.com/user-attachments/assets/25d336b2-a3e4-4c7b-94d7-557bd5f1b917" />

