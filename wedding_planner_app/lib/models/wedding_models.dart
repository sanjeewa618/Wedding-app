import 'package:flutter/material.dart';

class Package {
  final String name;
  final String description;
  final double basePrice;
  final List<String> includedServices;
  final Color color;

  Package({
    required this.name,
    required this.description,
    required this.basePrice,
    required this.includedServices,
    required this.color,
  });
}

class Hotel {
  final String name;
  final String location;
  final int stars;
  final double venueCost;
  final double plateCost;
  final List<String> supportedPackages; // e.g., ["Gold", "Platinum"]
  final String imageUrl; // Placeholder for UI

  Hotel({
    required this.name,
    required this.location,
    required this.stars,
    required this.venueCost,
    required this.plateCost,
    required this.supportedPackages,
    this.imageUrl = 'https://via.placeholder.com/150',
  });
}

class WeddingInput {
  int guestCount;
  String budget; // Keeping as string for simple input, parse later if needed
  String selectedSeason; // "Off-Peak", "Peak"
  Package? selectedPackage;
  Hotel? selectedHotel;

  WeddingInput({
    this.guestCount = 100,
    this.budget = '',
    this.selectedSeason = 'Off-Peak',
    this.selectedPackage,
    this.selectedHotel,
  });

  double get totalCost {
    if (selectedPackage == null || selectedHotel == null) return 0.0;

    double seasonMultiplier = selectedSeason == 'Peak' ? 1.10 : 1.0; // 10% extra for peak
    
    double catering = guestCount * selectedHotel!.plateCost;
    double services = selectedPackage!.basePrice; // Simplified service cost logic
    double venue = selectedHotel!.venueCost;

    return (venue + catering + services) * seasonMultiplier;
  }
}
