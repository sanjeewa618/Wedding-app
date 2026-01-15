import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/wedding_models.dart';
import 'providers/wedding_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeddingProvider()),
      ],
      child: const WeddingPlannerApp(),
    ),
  );
}

class WeddingPlannerApp extends StatelessWidget {
  const WeddingPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sri Lanka Wedding Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD4AF37)), // Gold Seed
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wedding Planner LK 🇱🇰"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Plan Your Dream Wedding",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Step 1: Main Details"),
            const SizedBox(height: 20),
            _buildGuestSlider(context),
            const SizedBox(height: 20),
            _buildSeasonSelector(context),
            const SizedBox(height: 30),
            const Text("Step 2: Choose Your Package", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPackageList(context),
            const SizedBox(height: 30),
             const Text("Step 3: Choose Venue", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildHotelList(context),
            const SizedBox(height: 40),
            _buildSummaryButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSlider(BuildContext context) {
    return Consumer<WeddingProvider>(
      builder: (context, provider, child) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Number of Guests", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${provider.input.guestCount}", 
                         style: const TextStyle(fontSize: 18, color: Colors.blue)),
                  ],
                ),
                Slider(
                  value: provider.input.guestCount.toDouble(),
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  label: provider.input.guestCount.toString(),
                  onChanged: (value) {
                    provider.updateGuestCount(value.round());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeasonSelector(BuildContext context) {
    return Consumer<WeddingProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Off-Peak"),
                value: "Off-Peak",
                groupValue: provider.input.selectedSeason,
                onChanged: (value) => provider.updateSeason(value!),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Peak (+10%)"),
                value: "Peak",
                groupValue: provider.input.selectedSeason,
                onChanged: (value) => provider.updateSeason(value!),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPackageList(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: appPackages.length,
        itemBuilder: (context, index) {
          final pkg = appPackages[index];
          return Consumer<WeddingProvider>(
            builder: (context, provider, _) {
              final isSelected = provider.input.selectedPackage?.name == pkg.name;
              return GestureDetector(
                onTap: () => provider.selectPackage(pkg),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: pkg.color.withOpacity(isSelected ? 1.0 : 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(pkg.name, 
                           style: TextStyle(fontWeight: FontWeight.bold, 
                                            color: isSelected ? Colors.white : Colors.black)),
                      const SizedBox(height: 5),
                      Text("LKR ${NumberFormat.compact().format(pkg.basePrice)}",
                           style: TextStyle(fontSize: 12, 
                                            color: isSelected ? Colors.white : Colors.black87)),
                      const SizedBox(height: 5),
                      if(isSelected) const Icon(Icons.check_circle, color: Colors.white, size: 20)
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHotelList(BuildContext context) {
    return Consumer<WeddingProvider>(
      builder: (context, provider, _) {
        if (provider.input.selectedPackage == null) {
          return const Center(child: Text("Please select a package first to see available hotels."));
        }

        // Filter hotels based on supported packages
        final availableHotels = appHotels.where((h) => 
          h.supportedPackages.contains(provider.input.selectedPackage!.name)
        ).toList();

        if (availableHotels.isEmpty) {
          return const Text("No hotels available for this package.");
        }

        return Column(
          children: availableHotels.map((hotel) {
            final isSelected = provider.input.selectedHotel?.name == hotel.name;
            return Card(
              color: isSelected ? Colors.green[50] : null,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(Icons.hotel, color: isSelected ? Colors.green : Colors.grey),
                title: Text(hotel.name),
                subtitle: Text("${hotel.location} • ${hotel.stars} Stars"),
                trailing: Text("LKR ${NumberFormat.compact().format(hotel.venueCost)}"),
                onTap: () => provider.selectHotel(hotel),
                selected: isSelected,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSummaryButton(BuildContext context) {
    return Consumer<WeddingProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: provider.isReadyToCalculate 
              ? () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const ResultScreen())
                  );
                }
              : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("Calculate Final Cost", style: TextStyle(fontSize: 18)),
          ),
        );
      },
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingProvider>(context, listen: false);
    final input = provider.input;
    final totalCost = input.totalCost;
    final formatter = NumberFormat("#,###");

    return Scaffold(
      appBar: AppBar(title: const Text("Estimated Cost")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.monetization_on, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text("Your Estimated Wedding Cost", style: TextStyle(fontSize: 18, color: Colors.grey)),
            Text("LKR ${formatter.format(totalCost)}", 
                 style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
            const Divider(height: 40),
            _buildRow("Guest Count", "${input.guestCount}"),
            _buildRow("Package", input.selectedPackage!.name),
            _buildRow("Venue", input.selectedHotel!.name),
            _buildRow("Catering (per plate)", "LKR ${formatter.format(input.selectedHotel!.plateCost)}"),
            const Divider(),
            _buildRow("Season", input.selectedSeason),
            if (input.selectedSeason == "Peak")
                 const Text("(+10% Season Charge Applied)", style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
