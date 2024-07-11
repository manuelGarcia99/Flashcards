import 'package:flutter/material.dart';
import '../dados.dart';
import 'editorDeCartas_page.dart';

class EditorDefinicao2Page extends StatefulWidget {
  final int idCarta;
  final String nomeBaralho;

  EditorDefinicao2Page({
    required this.idCarta,
    required this.nomeBaralho,
  });

  @override
  _EditorDefinicao2PageState createState() => _EditorDefinicao2PageState();
}

class _EditorDefinicao2PageState extends State<EditorDefinicao2Page> {
  final TextEditingController _termoController = TextEditingController();
  final TextEditingController _definicaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDefinicao2Data();
  }

  Future<void> _loadDefinicao2Data() async {
    String termo = await Dados.encontraTermo2(widget.idCarta);
    String definicao = await Dados.encontraDefinicao2(widget.idCarta);
    setState(() {
      _termoController.text = termo;
      _definicaoController.text = definicao;
    });
  }

  void _aoClicarConcluir() {
    Dados.novaDefinicao2(_termoController.text, _definicaoController.text, widget.idCarta);
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
        title: Text('Editar Definição 2'),
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
