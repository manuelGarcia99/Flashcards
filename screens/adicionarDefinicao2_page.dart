import 'package:flutter/material.dart';
import '../dados.dart';
import 'adicionadorDeCartas_page.dart';

class AdicionarDefinicao2Page extends StatefulWidget {
  final int idUltimaCarta;
  final String nomeDoBaralho;
  final String definicao1;
  final String termo1;
  final String definicao2;
  final String termo2;

  AdicionarDefinicao2Page({
    required this.idUltimaCarta,
    required this.nomeDoBaralho,
    required this.definicao1,
    required this.termo1,
    required this.definicao2,
    required this.termo2,
  });

  @override
  _AdicionarDefinicao2PageState createState() => _AdicionarDefinicao2PageState();
}

class _AdicionarDefinicao2PageState extends State<AdicionarDefinicao2Page> {
  final TextEditingController _termoController = TextEditingController();
  final TextEditingController _definicaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _termoController.text = widget.termo2;
    _definicaoController.text = widget.definicao2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Definição 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _termoController,
              decoration: InputDecoration(labelText: 'Termo'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _definicaoController,
              decoration: InputDecoration(labelText: 'Definição'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                'termo2': _termoController.text,
                'definicao2': _definicaoController.text,
              }),
              child: Text('Concluído'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Retornar'),
            ),
          ],
        ),
      ),
    );
  }
}
