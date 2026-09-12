# Tennis Counter

Tennis Counter is an iPhone app for recording tennis matches point by point and reviewing detailed match statistics afterward. It is built with SwiftUI and uses Apple’s Charts framework to visualize performance and momentum.

The app is published on the **iOS App Store** in **2024** as **Tennis Track**; **Tennis Counter** is the old repository and project name.

## Features

- Configure a match with:
  - Player names and starting server
  - Match format: super-tiebreak, one set, or full match
  - Set length and ad/no-ad scoring
  - Optional super-tiebreak third set
  - Court surface and match date
- Record each point, including:
  - First-serve result
  - Key shot and shot type
  - Forehand/backhand and shot location
  - Error cause and rally length
  - Comments and custom stat trackers
- Track the live score for points, games, sets, and tiebreaks.
- Review completed matches with:
  - Match information
  - Player statistics and percentages
  - Point and game graphs
  - Point/game momentum charts
  - A chronological point log
- Export a match as a JSON file and share it with the iOS share sheet.
- Import previously exported JSON match files.
- Delete recorded matches from the match details screen.

## Requirements

- macOS with Xcode
- iOS 17.5 or later
- An iPhone simulator or physical iPhone
- Swift 5.0

The project targets iPhone only and supports portrait orientation.

## Getting Started

Note: It's recommended to try out the App through iOS App Store for a quick, easy test.

1. Clone or download this repository.
2. Open `Tennis Counter.xcodeproj` in Xcode.
3. Select the **Tennis Counter** scheme.
4. Select an iPhone simulator or connect a development device.
5. Build and run with **Product > Run** (`⌘R`).

No external package dependencies are required. The project uses the system-provided SwiftUI and Charts frameworks.

## Using the App

### Record a match

1. Select **Record New Match** from the start screen.
2. Enter both player names.
3. Select the starting server and match format.
4. Choose the surface, date, player stat modes, and any additional trackers.
5. Tap **Continue**.
6. For every point, follow the prompts to record the serve and relevant point details.
7. Use the score controls and match actions as the match progresses.

### Review a match

Select **Recorded Matches** from the start screen, then choose a match. The match detail view contains these sections:

- **Info** — match setup, surface, date, and duration
- **Stats** — recorded statistics and percentages for both players
- **Graphs** — visual breakdowns of selected statistics
- **Momentum** — point- and game-level momentum charts
- **Log** — detailed information for each recorded point

### Transfer match data

- From a match detail view, tap the share button to export the match as JSON.
- From the **Recorded Matches** screen, tap the import button and select a compatible JSON file.

## Project Structure

```text
.
├── Info.plist
├── Tennis Counter.xcodeproj/
└── Tennis Counter/
    ├── Tennis_CounterApp.swift     # App entry point
    ├── ContentView.swift            # Start screen, match list, and import flow
    ├── FormView.swift               # New-match setup form
    ├── NewMatchView.swift           # Live scoring and point recording
    ├── PastMatchView.swift          # Saved-match details and export flow
    ├── NewStatisticsView.swift      # Statistics, graphs, momentum, and log views
    ├── ViewModel.swift               # Codable match and point data models
    ├── GraphView.swift               # Reusable chart view
    ├── StatView.swift                # Statistics display components
    ├── ServePercentView.swift        # Serve percentage components
    ├── ButtonView.swift              # Score and button components
    ├── RowOfBoxes.swift              # Legacy UI component
    └── Assets.xcassets/              # App icon and accent color assets
```

## Data Storage

Match data is stored locally on the device using `UserDefaults`. Point arrays are encoded as JSON data before being saved. Exported JSON files use the app’s `FileData` model and can be imported into another installation of the app.

There is no server-side storage or account system, so match data remains on the device unless it is exported manually.

## Development Notes

- The app’s UI is implemented with SwiftUI.
- Charts and momentum visualizations use the Apple Charts framework.
- Match records are represented by the `Point` and `FileData` types in `ViewModel.swift`.
- There are currently no automated tests or third-party dependencies configured in the repository.

## License

MIT License.

> AI note: Only this README was created with AI; no other project files were.
