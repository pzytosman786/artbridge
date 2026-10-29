import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'ARTBRIDGE',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF182019),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is a test.',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF697067),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'No underline should appear here.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF182019),
              ),
            ),
          ],
        ),
      ),
    );
  }
}