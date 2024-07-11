import 'package:flutter/material.dart';
import '../dados.dart';
import 'editorDeCartas_page.dart';

class EditorDefinicao1Page extends StatefulWidget {
  final int idCarta;
  final String nomeBaralho;

  EditorDefinicao1Page({
    required this.idCarta,
    required this.nomeBaralho,
  });

  @override
  _EditorDefinicao1PageState createState() => _EditorDefinicao1PageState();
}

class _EditorDefinicao1PageState extends State<EditorDefinicao1Page> {
  final TextEditingController _termoController = TextEditingController();
  final TextEditingController _definicaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDefinicao1Data();
  }

  Future<void> _loadDefinicao1Data() async {
    String termo = await Dados.encontraTermo1(widget.idCarta);
    String definicao = await Dados.encontraDefinicao1(widget.idCarta);
    setState(() {
      _termoController.text = termo;
      _definicaoController.text = definicao;
    });
  }

  void _aoClicarConcluir() {
    Dados.novaDefinicao1(_termoController.text, _definicaoController.text, widget.idCarta);
    Navigator.pop(context);
  }

  void _aoClicarRegressa() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _termoController.dispose();
    _definicaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Definição 1'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _aoClicarRegressa,
        ),
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
              onPressed: _aoClicarConcluir,
              child: Text('Concluído'),
            ),
          ],
        ),
      ),
    );
  }
}
