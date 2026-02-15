# Quick Start Guide

## 🎯 Getting Your App Running in 3 Minutes

### Prerequisites

✅ **Xcode Installation Required** (One-time setup)

If Xcode is downloading (12GB), grab a coffee ☕ - it'll take 10-20 minutes depending on your internet speed.

**After Xcode finishes installing:**
```bash
# Set the active developer directory (run once)
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# Verify installation
xcodebuild -version
```

---

### Method 1: Terminal Build (Fast & Easy) ⚡

No need to open Xcode GUI! Build directly from terminal:

```bash
cd "/Users/aravindrao/Developer/Projects/Leetcode Reminder"
./build.sh
```

This will:
- Clean previous builds
- Compile the app
- Create Release build
- Show you where the .app is located

**Then install to Applications:**
```bash
cp -r ./build/Build/Products/Release/LeetCodeReminder.app /Applications/
open /Applications/LeetCodeReminder.app
```

### Method 2: Using Xcode GUI (For Development)

If you want to see the code or debug:

```bash
cd "/Users/aravindrao/Developer/Projects/Leetcode Reminder"
open LeetCodeReminder.xcodeproj
```

Wait for Xcode to load (~10-15 seconds), then:
- Click the Play button (▶️) or press `Cmd + R`
- Enter your LeetCode username when prompted
- Look at your menu bar!

## 🎨 What You'll See

### In the Menu Bar:
- Your **LeetCode profile picture** (circular)
- A **colored border** around it:
  - 🟢 **Green** = You completed today's daily challenge!
  - 🔴 **Red** = Daily challenge is waiting for you
- A **number** showing problems solved today

### When You Click It:
- **Your Profile** with avatar and rank
- **Status Badge** showing completion state
- **Three Stats Cards:**
  - 📅 **Today**: Problems solved today
  - 🔢 **Total**: All-time solved count
  - 🔥 **Streak**: Your current streak
- **Daily Challenge Card** with:
  - Problem title
  - Difficulty badge (Easy/Medium/Hard)
  - "Solve Problem" button

## 📋 Features Checklist

- ✅ Red/Green status indicator
- ✅ Daily problem counter
- ✅ Total problems display
- ✅ Profile picture as menu icon
- ✅ Auto-refresh every 5 minutes
- ✅ Streak tracking
- ✅ One-click problem access
- ✅ Light/Dark mode support

## 🐛 Troubleshooting

**App won't build?**
- Make sure you have Xcode 15+ installed
- Run: `xcode-select --install`

**No data loading?**
- Check your internet connection
- Verify your LeetCode username is correct
- Try clicking "Refresh"

**Profile picture not showing?**
- Give it a few seconds to download
- Check your internet connection

## 🎉 You're All Set!

Now you'll always know:
- If you've completed today's challenge (🟢/🔴)
- How many problems you've solved today
- Your total problem count
- Your current streak

Happy coding! 💻
