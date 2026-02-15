# LeetCode Reminder - App Preview

## 📱 What Your Menu Bar Will Look Like

### Status Indicators

#### ✅ When Daily Challenge is COMPLETED (Green)
```
Menu Bar: [🟢 Your Avatar] 3
           ↑              ↑
      Green border    Problems 
      (completed)  solved today
```

#### ⏳ When Daily Challenge is PENDING (Red)
```
Menu Bar: [🔴 Your Avatar] 1
           ↑              ↑
       Red border    Problems 
       (pending)   solved today
```

## 🎨 Popover Menu Design

```
┌─────────────────────────────────────┐
│  👤 YourUsername          🏆 Rank    │
│                                      │
├─────────────────────────────────────┤
│  🟢 Daily Challenge Completed ✓     │
│                                      │
│  ┌──────┐  ┌──────┐  ┌──────┐      │
│  │ 📅 3 │  │ 🔢456│  │ 🔥 7 │      │
│  │Today │  │Total │  │Streak│      │
│  └──────┘  └──────┘  └──────┘      │
│                                      │
├─────────────────────────────────────┤
│  Daily Challenge            [Medium]│
│                                      │
│  Two Sum Problem                    │
│                                      │
│  [→ Solve Problem]                  │
│                                      │
├─────────────────────────────────────┤
│  Refresh  |  Change User  |  Quit   │
└─────────────────────────────────────┘
```

## 🎯 Key Visual Features

### 1. **Smart Status Colors**
   - 🟢 Green = Motivation boost! You did it!
   - 🔴 Red = Friendly reminder to solve today's challenge

### 2. **Your Profile Picture**
   - Shows YOUR actual LeetCode avatar
   - Circular design in menu bar
   - Bordered with status color

### 3. **At-a-Glance Metrics**
   - **Daily Counter**: See today's progress instantly
   - **Total Count**: Your lifetime achievement
   - **Streak**: Keep the momentum going!

### 4. **Clean Design**
   - Native macOS look and feel
   - Automatically adapts to Light/Dark mode
   - Smooth animations and transitions

## 📊 Data Flow

```
LeetCode API → Service Layer → SwiftUI Views → Menu Bar
      ↓              ↓              ↓              ↓
   GraphQL      Fetches:       Updates:      Shows:
    Query      - Profile      - Colors      - Icon
              - Daily Q      - Counters    - Badge
              - Stats        - Status      - Number
```

## 🔄 Auto-Refresh

Every 5 minutes, the app automatically:
1. Fetches latest submission data
2. Checks if daily challenge completed
3. Updates counters
4. Refreshes profile picture if needed
5. Updates menu bar display

## 🎨 Color Scheme

| State | Border Color | Meaning |
|-------|--------------|---------|
| Completed | 🟢 Green (#00FF00) | Daily challenge done! |
| Pending | 🔴 Red (#FF0000) | Daily challenge waiting |
| Loading | ⚪ Gray | Fetching data... |

## 💡 Interactive Elements

- **Click Menu Bar Icon** → Opens popover
- **Click "Solve Problem"** → Opens LeetCode in browser
- **Click "Refresh"** → Manually updates data
- **Click "Change User"** → Switch accounts
- **Click outside** → Closes popover

## 🌟 Design Philosophy

**Minimalist + Informative**
- Shows exactly what you need
- No clutter, no distractions
- One glance = full status

**Native + Beautiful**
- Uses system fonts and colors
- Respects macOS design guidelines
- Feels like a built-in feature

**Smart + Helpful**
- Red/green feedback is instant
- Counters motivate daily practice
- Streak tracker builds habits

---

**You'll love seeing that green indicator every day! 🟢✨**
