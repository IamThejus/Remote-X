import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

const String deviceType = 'ac_remote';
const String modelName = 'lg_window';

void vibrate({bool heavy = false}) {
  heavy ? HapticFeedback.heavyImpact() : HapticFeedback.lightImpact();
}

Future<void> sendpostrequest(String type, String model, String command) async {
  var url = Uri.parse('https://universal-remote-umber.vercel.app/sendcmd');
  await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "type": type,
      "model": model,
      "command": command,
    }),
  );
}

class AcRemotePage extends StatefulWidget {
  const AcRemotePage({super.key});

  @override
  State<AcRemotePage> createState() => _AcRemotePageState();
}

class _AcRemotePageState extends State<AcRemotePage> {
  int temperature = 24;

  void increaseTemp() {
    if (temperature < 30) {
      setState(() => temperature++);
      vibrate();
      sendpostrequest(deviceType, modelName, '$temperature');
    }
  }

  void decreaseTemp() {
    if (temperature > 16) {
      setState(() => temperature--);
      vibrate();
      sendpostrequest(deviceType, modelName, '$temperature');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: screenHeight * 0.7,
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
              Text(
                "AC Controller",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                ),
              ),

              // Temperature Display
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '$temperature°C',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ),
              ),

              // ON / OFF Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _minimalButton("ON", () {
                    sendpostrequest(deviceType, modelName, 'on');
                    vibrate();
                  }),
                  _minimalButton("OFF", () {
                    sendpostrequest(deviceType, modelName, 'off');
                    vibrate();
                  }),
                ],
              ),

              // TEMP UP
              _arrowButton(Icons.keyboard_arrow_up, increaseTemp),

              // TEMP DOWN
              _arrowButton(Icons.keyboard_arrow_down, decreaseTemp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _minimalButton(String label, VoidCallback onTap) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 70,
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
