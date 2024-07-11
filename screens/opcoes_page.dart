import 'package:flutter/material.dart';
class OpcoesPage extends StatefulWidget {
  @override
  _OpcoesPageState createState() => _OpcoesPageState();
}

class _OpcoesPageState extends State<OpcoesPage> {
  String selectedLanguage = 'Português'; // Initial language selection
  String selectedTheme = 'Light'; // Initial theme selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Definições'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lingua'),
                DropdownButton<String>(
                  value: selectedLanguage,
                  items: [
                    DropdownMenuItem(child: Text('Português'), value: 'Português'),
                    DropdownMenuItem(child: Text('Inglês'), value: 'Inglês'),
                  ],
                  onChanged: (value) => setState(() => selectedLanguage = value!),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tema'),
                DropdownButton<String>(
                  value: selectedTheme,
                  items: [
                    DropdownMenuItem(child: Text('Light'), value: 'Light'),
                    DropdownMenuItem(child: Text('Dark'), value: 'Dark'),
                  ],
                  onChanged: (value) => setState(() => selectedTheme = value!),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to main menu
              },
              child: Text('Retornar'),
            ),
          ],
        ),
      ),
    );
  }
}