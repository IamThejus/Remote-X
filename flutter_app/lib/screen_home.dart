import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Darker black
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A), // Card-like background
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white24, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Turning possibilities into power",
                style: TextStyle(
                  fontFamily: 'Courier', // Replace with custom dot matrix font if available
                  fontSize: 14,
                  color: Colors.white60,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              _nothingButton(context, "AC", 'ac_screen'),
              const SizedBox(height: 20),
              _nothingButton(context, "Fan", 'fan_screen'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nothingButton(BuildContext context, String label, String route) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(route);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white24, width: 1.2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(
            fontFamily: 'Courier', // Replace with Nothing-style font if added
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
