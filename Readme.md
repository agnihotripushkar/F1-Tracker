🛠 System PRD: Technical Requirements
This document focuses on the how—the infrastructure and frameworks required to make the app functional and performant.

1. Project Overview
Target Platform: iOS 17.0+ (for stable SwiftData and ActivityKit features).

Language/Framework: Swift 6, SwiftUI, ActivityKit, WidgetKit.

Data Source: Ergast Developer API (or OpenF1 API) for race data.

2. Core Functional Requirements
Activity Lifecycle Management: The app must be able to start, update, and end a Live Activity session based on the race schedule.

Frequent Updates: Support for updates more than once per minute using NSSupportsLiveActivitiesFrequentUpdates.

Push-to-Start (Advanced): Integration with Apple Push Notification service (APNs) to trigger the activity remotely when a race begins.

Background Fetching: Use BackgroundTasks to poll for data when the app is not in the foreground.

3. Data Architecture
Persistence: Use SwiftData to cache driver standings, team colors, and race calendars locally.

Networking: A dedicated F1Service actor to handle API calls with custom retry logic for race-day traffic.

Payload Management: APNs payloads for Live Activities must be under 4KB.

4. Constraints & Error Handling
Data Stale Logic: If no update is received for 30 seconds, the UI must show a "Stale" indicator (e.g., dimmed text).

Battery Optimization: Logic to reduce update frequency if the device enters "Low Power Mode."

/F1Tracker
  ├── /App                  (App Delegates, Main Entry)
  ├── /Domain               (Protocols, Models, ActivityAttributes)
  ├── /Data                 (SwiftData Containers, API Services, Repository)
  ├── /Features             (SwiftUI Views, ViewModels)
  │    ├── /Dashboard       (Main App Screen)
  │    └── /LiveTracking    (Live Activity Logic)
  ├── /WidgetExtension      (The actual Widget/Island UI code)
  │    ├── F1WidgetEntry.swift
  │    └── /Views           (Island/LockScreen SwiftUI components)
  └── /Resources            (Assets, Team Colors, Localizable Strings)


  1. For the "Race Hub" (Live Timing)
Use OpenF1. You will specifically want the intervals and position endpoints.

Endpoint: https://api.openf1.org/v1/intervals?session_key=latest

What it gives you: Gap to leader, gap to car ahead, and current lap.

2. For "Championship Standings"
Use Jolpica-F1.

Endpoint: https://api.jolpi.ca/ergast/f1/current/driverStandings

What it gives you: Points, wins, and current rank for all 20 drivers.

3. For the "Grand Prix Dashboard" (Weather & Track)
Use OpenF1 for track-side data.

Endpoint: https://api.openf1.org/v1/weather?session_key=latest

What it gives you: Track temperature, air temperature, and rainfall (crucial for "Wet Race" alerts).

To impress a recruiter in 2026, don't just call these APIs directly from your SwiftUI views. Use a Repository Pattern.

Remote Data Source: Fetches from OpenF1 or Jolpica.

Local Data Source (SwiftData): Since F1 data doesn't change every second (except during a race), cache the standings and calendar locally. This makes your app feel "instant" when opened.

The Repository: Logic that decides: "Do I have fresh data in the database? If not, go to the API."

💡 Pro-Tip for 2026: The "Rate Limit" Trap
Most F1 APIs (especially free ones) have rate limits (e.g., 200 requests/hour).

Junior Approach: Call the API every 2 seconds. (Result: Your API key gets banned).

Senior Approach: Implement a Polling Manager that only increases frequency when a "Race is Live" flag is detected, and uses WebSockets or Background Tasks to save battery.