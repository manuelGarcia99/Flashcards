import 'package:flutter/material.dart';
import '../dados.dart';
import 'editorDeCartas_page.dart';

class EditorPerguntaPage extends StatefulWidget {
  final int idCarta;
  final String nomeBaralho;

  EditorPerguntaPage({
    required this.idCarta,
    required this.nomeBaralho,
  });

  @override
  _EditorPerguntaPageState createState() => _EditorPerguntaPageState();
}

class _EditorPerguntaPageState extends State<EditorPerguntaPage> {
  final TextEditingController _perguntaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPerguntaData();
  }

  Future<void> _loadPerguntaData() async {
    String pergunta = await Dados.encheAreaDoTextoDePergunta(widget.idCarta);
    setState(() {
      _perguntaController.text = pergunta;
    });
  }

  void _aoClicarConcluir() {
    Dados.alteraPergunta(_perguntaController.text, widget.idCarta);
    Navigator.pop(context);
  }

  void _aoClicarRegressa() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _perguntaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Pergunta'),
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
              controller: _perguntaController,
              decoration: InputDecoration(labelText: 'Pergunta'),
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
