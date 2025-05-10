# Flutter Article App

A Flutter mobile app that displays a list of articles from a public API with search and detail view features.

## Features
- Home screen with list of articles showing title and preview
- Search functionality to filter articles by title or body content
- Detail view with full article content
- Pull-to-refresh capability to update article list
- Favorite articles functionality with persistence using SharedPreferences
- Tab-based navigation between all articles and favorites
- Responsive UI with proper loading and error states

## Setup Instructions
1. Clone the repo:
   ```
   git clone https://github.com/Utsav8020/flutter_article_app.git
   cd flutter_article_app
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the app:
   ```
   flutter run
   ```

## Tech Stack
- Flutter SDK: 3.22.0
- State Management: Provider (6.1.5)
- HTTP Client: http (1.4.0)
- Persistence: shared_preferences (2.3.3)

## State Management Explanation
The app uses the Provider package for state management, which offers a simple and efficient way to manage application state. The ArticleProvider class serves as a central store for articles data and manages API calls, search functionality, and favorite status persistence. This approach creates a clean separation between the UI and data layers while allowing widgets to efficiently rebuild only when necessary.

## Known Issues / Limitations
- The app relies on a third-party API (jsonplaceholder.typicode.com) which has limited data variety
- Search is performed client-side rather than server-side for simplicity
- No offline caching of article content beyond favorites
- No image content in articles as the API doesn't provide images
   