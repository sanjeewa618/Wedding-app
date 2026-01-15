# Wedding Planner App - Implementation Plan

## 1. Project Overview
A Flutter-based mobile application to help couples estimate wedding costs, compare packages, and select venues in Sri Lanka.

## 2. Architecture
**Pattern**: MVVM (Model-View-ViewModel) or Clean Architecture-lite.
**State Management**: Provider (Simple & Effective for this scope).

### Folder Structure
```
lib/
 ├── main.dart                      # Entry point (Theme, Routes)
 ├── models/                        # Data Structures
 │    ├── wedding_input_model.dart  # User preferences 
 │    ├── package_model.dart        # Bronze, Silver, Gold, Platinum
 │    └── hotel_model.dart          # Venue details
 ├── screens/                       # UI Pages
 │    ├── home_screen.dart          # Dashboard
 │    ├── wedding_form_screen.dart  # Inputs (Guests, Season, etc.)
 │    ├── venue_selection_screen.dart # List of Hotels
 │    ├── cost_result_screen.dart   # Final Calculations
 │    └── package_details_screen.dart # Comparison
 ├── widgets/                       # Reusable UI
 │    ├── custom_slider.dart
 │    ├── package_card.dart
 │    └── cost_breakdown_chart.dart
 ├── services/                      # Logic
 │    ├── cost_calculator.dart      # The math engine
 │    └── recommendation_engine.dart # Logic for "Best Package"
 └── utils/
      ├── constants.dart            # Colors, Strings
      └── demo_data.dart            # Sri Lankan Hotel Data
```

## 3. Data Models

### Hotel Model
```dart
class Hotel {
  final String id;
  final String name;
  final String location;
  final double venueCost;
  final double plateCost;
  final List<String> supportedPackages; // ['Gold', 'Platinum']
  // ...
}
```

### Package Model
```dart
class Package {
  final String name; // Bronze, Silver, Gold, Platinum
  final double basePrice;
  final List<String> features;
  // ...
}
```

## 4. Immediate Next Steps (After Installing Flutter)
1.  **Initialize Project**: `flutter create wedding_planner_app`
2.  **Add Dependencies**: `flutter pub add provider google_fonts fl_chart intl`
3.  **Create Models**: Define the Dart classes for Hotels and Packages.
4.  **Build Input Form**: Create the screen to accept Guest Count and Budget.
