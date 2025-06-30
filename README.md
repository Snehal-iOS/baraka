### Baraka Portfolio - iOS Technical Assignment

This project implements a Portfolio Dashboard for the Baraka app using UIKit, MVVM architecture, and RxSwift. It showcases a user-friendly, modular UI with simulated live market updates.

---

### Features

- Displays portfolio balance, P&L, and positions
- Simulated live price updates
- Theme toggle (Light/Dark mode)
- MVVM + RxSwift architecture
- Clean UIKit-based layout with `UICollectionViewCompositionalLayout`

---

### Architecture

The app follows a clean **MVVM architecture**:

```
Baraka/
├── App/                      # AppDelegate, SceneDelegate
├── Features/
│   └── Portfolio/
│       ├── Model/           # Data models
│       ├── View/            # UI components (ViewController, Cells, Header)
│       ├── ViewModel/       # ViewModel logic & formatting
│       └── Service/         # Networking
└── Resources/              # Shared components like Asssets, LaunchScreen
```

---

### Tech Stack

- **Language:** Swift
- **UI Framework:** UIKit
- **Architecture:** MVVM
- **Reactivity:** RxSwift, RxCocoa
- **Layout:** `UICollectionViewCompositionalLayout`
- **Package Manager:** CocoaPods

---

### Getting Started
### Prerequisites

- Xcode 15+
- CocoaPods installed (`sudo gem install cocoapods`)

### Setup

1. Clone the repo  
   ```bash
   git clone https://github.com/Senhal-iOS/baraka.git
   cd baraka
   ```

2. Install dependencies  
   ```bash
   pod install
   ```

3. Open the `.xcworkspace` file in Xcode  
   ```bash
   open Baraka.xcworkspace
   ```

4. Build and run on iOS Simulator

---

### API Simulation

The portfolio data is fetched from: 


```
GET https://dummyjson.com/c/60b7-70a6-4ee3-bae8
```

Simulated price updates occur every few seconds within the `PortfolioViewModel`.

### Live Price Simulation:

Every second, the app simulates price changes using a timer in PortfolioBloc, recalculating: Last traded price, Market value & PnL & PnL % The UI updates via emitting PortfolioLoaded state again.

---

### Screenshots

| Light theme | Dark theme |
|--------------|--------------|
| ![](Docs/light.png) | ![](Docs/dark.png) |

---

### Author

**Snehal Lokhande**  
Mobile Developer | Fintech Enthusiast  
Dubai, UAE  
isnehal28@gmail.com

---

### License

This project is intended for technical evaluation purposes only. Not for production use.

