import 'package:flutter/material.dart';
import '../dados.dart';
import 'adicionadorDeCartas_page.dart';

class AdicionarDefinicao1Page extends StatefulWidget {
  final int idUltimaCarta;
  final String nomeDoBaralho;
  final String definicao1;
  final String termo1;
  final String definicao2;
  final String termo2;

  AdicionarDefinicao1Page({
    required this.idUltimaCarta,
    required this.nomeDoBaralho,
    required this.definicao1,
    required this.termo1,
    required this.definicao2,
    required this.termo2,
  });

  @override
  _AdicionarDefinicao1PageState createState() => _AdicionarDefinicao1PageState();
}

class _AdicionarDefinicao1PageState extends State<AdicionarDefinicao1Page> {
  final TextEditingController _termoController = TextEditingController();
  final TextEditingController _definicaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _termoController.text = widget.termo1;
    _definicaoController.text = widget.definicao1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Definição 1'),
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
                'termo1': _termoController.text,
                'definicao1': _definicaoController.text,
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
