import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'screens/main_page.dart';
import 'screens/editorDefinicao1_page.dart';
import 'screens/editorPergunta_page.dart';
import 'screens/editorResposta_page.dart';
import 'screens/opcoes_page.dart';
import 'screens/reverBaralho_page.dart';
import 'screens/revisorFrontEnd_page.dart';
import 'app_theme.dart';
void main() async {
  final settings = ConnectionSettings(
    host: '83.212.82.184',
    port: 3306,
    user: 'phone',
    password: 'RKFTEGB4uZ',
    db: 'projetolicenciatura',
    characterSet: CharacterSet.UTF8MB4,
  );

  try {
    final conn = await MySqlConnection.connect(settings);
    print('Connected to the database');
    /*var results = await conn.query('SELECT NomeBaralho FROM Baralhos');
    if (results.isEmpty) {
      print('No rows found.');
    } else {
      for (var row in results) {
        print('Row data: ${row[0]}');
      }
    }*/
    await conn.close();
  } catch (e) {
    print('Connection error: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: StudyMasterMainMenu(),

    );
  }
}
