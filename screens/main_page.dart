import 'package:flutter/material.dart';
import 'package:projeto_final_movel/screens/editarBaralho_page.dart';
import 'package:projeto_final_movel/screens/reverBaralho_page.dart';
import 'criarBaralho_page.dart';
import 'apagarBaralho_page.dart';
import 'opcoes_page.dart';

class StudyMasterMainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StudyMaster'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OpcoesPage()),
                    );
                  },
                  child: Text('DEFINIÇÕES'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CriarBaralhoPage()),
                    );
                  },
                  child: Text('CRIAR'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditarBaralhoPage()),
                    );
                  },
                  child: Text('EDITAR'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReverBaralhoPage()),
                    );
                  },
                  child: Text('REVER'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApagarBaralhoPage()),
                );
              },
              child: Text('APAGAR'),
            ),
          ],
        ),
      ),
    );
  }
}