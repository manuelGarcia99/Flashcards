import 'package:flutter/material.dart';
import '../dados.dart';
import 'adicionarDefinicao1_page.dart';
import 'adicionarDefinicao2_page.dart';
import '../carta.dart';

class AdicionadorDeCartasPage extends StatefulWidget {
  final String nomeDoBaralho;
  final int idUltimaCarta;
  var definicao1;
  var definicao2;
  var termo1;
  var termo2;

  AdicionadorDeCartasPage({required this.nomeDoBaralho, required this.idUltimaCarta,this.definicao1,this.definicao2,this.termo1,this.termo2});

  @override
  _AdicionadorDeCartasPageState createState() => _AdicionadorDeCartasPageState();
}

class _AdicionadorDeCartasPageState extends State<AdicionadorDeCartasPage> {
  final TextEditingController _perguntaController = TextEditingController();
  final TextEditingController _respostaController = TextEditingController();
  String termo1 = "";
  String definicao1 = "";
  String termo2 = "";
  String definicao2 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Carta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _perguntaController,
              decoration: const InputDecoration(labelText: 'Pergunta'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _respostaController,
              decoration: const InputDecoration(labelText: 'Resposta'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToAdicionarDefinicao1(context),
              child: Text('Definição 1'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToAdicionarDefinicao2(context),
              child: Text('Definição 2'),
            ),
            ElevatedButton(
              onPressed: () => _concluirAdicao(),
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

  void _navigateToAdicionarDefinicao1(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarDefinicao1Page(
          nomeDoBaralho: widget.nomeDoBaralho,
          idUltimaCarta: widget.idUltimaCarta,
          definicao1: definicao1,
          termo1: termo1,
          definicao2: definicao2,
          termo2: termo2,
        ),
      ),
    ).then((value) {
      if (value != null && value is Map<String, String>) {
        setState(() {
          termo1 = value['termo1']!;
          definicao1 = value['definicao1']!;
        });
      }
    });
  }

  void _navigateToAdicionarDefinicao2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarDefinicao2Page(
          nomeDoBaralho: widget.nomeDoBaralho,
          idUltimaCarta: widget.idUltimaCarta,
          definicao1: definicao1,
          termo1: termo1,
          definicao2: definicao2,
          termo2: termo2,
        ),
      ),
    ).then((value) {
      if (value != null && value is Map<String, String>) {
        setState(() {
          termo2 = value['termo2']!;
          definicao2 = value['definicao2']!;
        });
      }
    });
  }

  void _concluirAdicao() {
    Carta carta = Carta(
      nomeDoBaralho: widget.nomeDoBaralho,
      pergunta: _perguntaController.text,
      resposta: _respostaController.text,
      termo1: termo1,
      definicao1: definicao1,
      termo2: termo2,
      definicao2: definicao2,
      easinessFactor: 2.5,
      ordemDaRepeticao: 1,
    );
    Dados.criaCarta(carta);
    _perguntaController.clear();
    _respostaController.clear();
    setState(() {
      termo1 = "";
      definicao1 = "";
      termo2 = "";
      definicao2 = "";
    });
  }
}
