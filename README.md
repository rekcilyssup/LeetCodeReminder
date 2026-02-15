# LeetCode Reminder - Enhanced Menu Bar App

A beautiful macOS menu bar app that helps you track your LeetCode progress with real-time status indicators.

## ✨ Features

### 🎯 Core Features
- **Red/Green Status Indicator** - Instantly see if you've completed today's daily challenge
  - 🔴 Red = Daily challenge pending
  - 🟢 Green = Daily challenge completed
- **Daily Progress Counter** - Track how many problems you've solved today
- **Total Problems** - Your all-time solved count
- **Your Profile Picture** - Displays your LeetCode avatar as the menu bar icon with status border
- **Streak Tracking** - Never lose your solving streak
- **Difficulty Badges** - Easy/Medium/Hard visual indicators
- **Auto-refresh** - Updates every 5 minutes automatically

### 🎨 UI Highlights
- Clean, modern SwiftUI interface
- Native macOS design
- Light/Dark mode support
- Quick access popover menu
- One-click problem access

## 🚀 Getting Started

### Prerequisites
- macOS 13.0 or later
- Xcode 15.0 or later
- LeetCode account

### Installation

1. **Open in Xcode**
   ```bash
   git clone https://github.com/rekcilyssup/LeetCodeReminder.git
   cd LeetCodeReminder
   open LeetCodeReminder.xcodeproj
   ```

2. **Build & Run**
   - Press `Cmd + R` to build and run
   - Or click the Play button in Xcode

3. **First Launch**
   - Enter your LeetCode username
   - The app will fetch your profile and stats
   - Your username is saved for future launches

### Building for Release

1. Select **Product > Archive** in Xcode
2. Click **Distribute App**
3. Choose **Copy App** to get the .app file
4. Move to `/Applications` folder

## 📱 Usage

### Menu Bar Icon
- **Profile Picture with Colored Border**
  - Green border = Daily challenge completed ✅
  - Red border = Daily challenge pending ⏳
- **Number Badge** - Shows problems solved today

### Popover Menu
Click the menu bar icon to see:
- Your profile with avatar and rank
- Status indicator (completed/pending)
- Three stat cards:
  - **Today** - Problems solved today
  - **Total** - All-time problems solved
  - **Streak** - Current solving streak
- **Daily Challenge Card**
  - Problem title
  - Difficulty badge
  - "Solve Problem" button (opens in browser)

### Actions
- **Refresh** - Manually update data
- **Change User** - Switch LeetCode accounts
- **Quit** - Close the app

## 🛠 Technical Details

### Architecture
```
LeetCodeReminder/
├── LeetCodeReminderApp.swift    # App entry point
├── Models/
│   └── LeetCodeModels.swift     # Data models
├── Services/
│   └── LeetCodeService.swift    # API integration
└── Views/
    ├── StatusBarController.swift # Menu bar controller
    └── MenuBarView.swift         # Main UI
```

### API Integration
- Uses LeetCode's GraphQL API
- Fetches:
  - User profile & avatar
  - Daily challenge
  - Submission history
  - Statistics & streaks

### Data Refresh
- Auto-refresh every 5 minutes
- Manual refresh available
- Persistent username storage using UserDefaults

## 🎨 Customization

### Change Refresh Interval
In [StatusBarController.swift](LeetCodeReminder/Views/StatusBarController.swift):
```swift
// Current: 300 seconds (5 minutes)
Timer.scheduledTimer(withTimeInterval: 300, repeats: true)
```

### Modify Status Colors
In [StatusBarController.swift](LeetCodeReminder/Views/StatusBarController.swift):
```swift
private var statusColor: Color {
    return status.dailyProblemCompleted ? .green : .red
}
```

## 🐛 Troubleshooting

### App doesn't appear in menu bar
- Check System Settings > General > Login Items
- Make sure the app has accessibility permissions

### Data not loading
- Verify your LeetCode username is correct
- Check your internet connection
- LeetCode's API might be rate-limited

### Profile picture not showing
- Ensure network access is allowed
- Check App Sandbox permissions
- Avatar URL might be blocked

## 📝 Improvements Over LeetBar

1. ✅ **Visual Status Indicator** - Red/Green color system
2. ✅ **Daily Counter** - See today's progress at a glance
3. ✅ **Profile Picture Icon** - Personal touch in menu bar
4. ✅ **Enhanced Stats** - More detailed metrics
5. ✅ **Better UI** - Modern SwiftUI design
6. ✅ **Streak Tracking** - Motivation to keep going

## 🔮 Future Enhancements

- [ ] Custom notification times
- [ ] Weekly/monthly statistics
- [ ] Problem difficulty breakdown chart
- [ ] Desktop widget support
- [ ] Multiple account support
- [ ] Custom themes

## 📄 License

MIT License - feel free to modify and distribute!

## 🙏 Credits

Inspired by [LeetBar](https://github.com/marwanhawari/LeetBar) by Marwan Hawari

---

**Made with ❤️ for the LeetCode community**
