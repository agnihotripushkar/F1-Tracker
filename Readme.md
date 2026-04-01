# F1 Tracker

An iOS app for Formula 1 fans to follow live race weekends, driver standings, team info, and the latest news — all in one place.

## Features

- **Home** — Countdown to the next session, track info (Albert Park), weather conditions, and the full weekend schedule
- **Racing** — Live race hub with timing and session data
- **Standings** — Current driver and constructor championship standings
- **Teams** — Team and driver profiles
- **News** — Latest F1 headlines

## Tech Stack

- Swift 6 / SwiftUI
- iOS 17.0+
- ActivityKit + WidgetKit (Live Activities / Dynamic Island)
- SwiftData for local caching
- [OpenF1 API](https://openf1.org) — live timing, intervals, weather
- [Jolpica-F1 API](https://api.jolpi.ca/ergast/f1) — championship standings

## Architecture

Repository pattern with a remote data source (OpenF1 / Jolpica) and a local SwiftData cache. A dedicated `F1Service` actor handles networking with retry logic for race-day traffic.

```
/F1Tracker
  ├── /App                  # Entry point, app delegates
  ├── /Domain               # Models, protocols, ActivityAttributes
  ├── /Data                 # SwiftData, API services, repositories
  ├── /Features             # SwiftUI views and view models
  │    ├── /Dashboard
  │    └── /LiveTracking
  ├── /WidgetExtension      # Dynamic Island / Lock Screen UI
  └── /Resources            # Assets, team colors, localization
```

## Requirements

- Xcode 16+
- iOS 17.0+ device or simulator

## Getting Started

1. Clone the repo
2. Open `F1 Tracker.xcodeproj` in Xcode
3. Select your target device and run
