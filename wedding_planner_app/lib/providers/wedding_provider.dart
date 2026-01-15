import 'package:flutter/material.dart';
import 'models/wedding_models.dart';

// --- DATA REPOSITORY ---
final List<Package> appPackages = [
  Package(
    name: "Bronze",
    description: "Budget-friendly option for intimate weddings.",
    basePrice: 150000,
    color: Colors.brown[300]!,
    includedServices: ["Basic Venue Setup", "Buffet", "Photos Only"],
  ),
  Package(
    name: "Silver",
    description: "Standard package for average weddings.",
    basePrice: 350000,
    color: Colors.grey[400]!,
    includedServices: ["Decorations", "DJ Music", "Photos + Basic Video"],
  ),
  Package(
    name: "Gold",
    description: "Premium choice with extensive services.",
    basePrice: 600000,
    color: Colors.amber[400]!,
    includedServices: ["Luxury Decor", "Live Band", "Cinematic Video"],
  ),
  Package(
    name: "Platinum",
    description: "The ultimate luxury experience.",
    basePrice: 1000000,
    color: Colors.blueGrey[900]!,
    includedServices: ["5-Star Venue", "Designer Decor", "Full Event Management"],
  ),
];

final List<Hotel> appHotels = [
  Hotel(
    name: "Galadari Hotel",
    location: "Colombo",
    stars: 5,
    venueCost: 850000,
    plateCost: 6500,
    supportedPackages: ["Gold", "Platinum"],
  ),
  Hotel(
    name: "Shangri-La",
    location: "Colombo",
    stars: 5,
    venueCost: 1200000,
    plateCost: 8500,
    supportedPackages: ["Platinum"],
  ),
  Hotel(
    name: "Cinnamon Grand",
    location: "Colombo",
    stars: 5,
    venueCost: 950000,
    plateCost: 7500,
    supportedPackages: ["Gold", "Platinum"],
  ),
  Hotel(
    name: "Earl's Regency",
    location: "Kandy",
    stars: 5,
    venueCost: 650000,
    plateCost: 5000,
    supportedPackages: ["Silver", "Gold"],
  ),
  Hotel(
    name: "Jetwing Blue",
    location: "Negombo",
    stars: 4,
    venueCost: 550000,
    plateCost: 4500,
    supportedPackages: ["Silver", "Gold"],
  ),
  Hotel(
    name: "Amaya Hills",
    location: "Kandy",
    stars: 4,
    venueCost: 400000,
    plateCost: 3500,
    supportedPackages: ["Bronze", "Silver"],
  ),
];

// --- PROVIDER ---
class WeddingProvider extends ChangeNotifier {
  WeddingInput _input = WeddingInput();

  WeddingInput get input => _input;

  void updateGuestCount(int count) {
    _input.guestCount = count;
    notifyListeners();
  }

  void updateSeason(String season) {
    _input.selectedSeason = season;
    notifyListeners();
  }

  void selectPackage(Package pkg) {
    _input.selectedPackage = pkg;
    // Reset hotel if it doesn't support the new package
    if (_input.selectedHotel != null && 
        !_input.selectedHotel!.supportedPackages.contains(pkg.name)) {
      _input.selectedHotel = null;
    }
    notifyListeners();
  }

  void selectHotel(Hotel hotel) {
    _input.selectedHotel = hotel;
    notifyListeners();
  }

  bool get isReadyToCalculate => 
      _input.selectedPackage != null && _input.selectedHotel != null;
}
