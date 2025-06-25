import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void vibrate() {
  HapticFeedback.lightImpact();
}

void sendpostrequest(String type, String model, String command) async {
  var url = Uri.parse('https://universal-remote-umber.vercel.app/sendcmd');
  await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "type": type,
      "model": model,
      "command": command,
    }),
  );
}

class FanScreen extends StatelessWidget {
  const FanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: screenHeight * 0.65,
          width: 250,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.05),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.white24,
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Fan Controller",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              // On/Off Circle Button
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(255, 255, 255, 0.08),
                  border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
                ),
                child: IconButton(
                  onPressed: () {
                    sendpostrequest('fan_remote', 'atomberg', 'on/off');
                    vibrate();
                  },
                  icon: const Icon(Icons.power_settings_new, color: Colors.white, size: 32),
                ),
              ),

              // Speed Up & Down Buttons
              Column(
                children: [
                  _arrowButton(Icons.keyboard_arrow_up, () {
                    sendpostrequest('fan_remote', 'atomberg', 'speedup');
                    vibrate();
                  }),
                  const SizedBox(height: 12),
                  _arrowButton(Icons.keyboard_arrow_down, () {
                    sendpostrequest('fan_remote', 'atomberg', 'speedown');
                    vibrate();
                  }),
                ],
              ),

              // Turbo Mode Button
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      sendpostrequest('fan_remote', 'atomberg', 'turbo');
                      vibrate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.15),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "TURBO",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 60,
      height: 45,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onTap,
      ),
    );
  }
}
