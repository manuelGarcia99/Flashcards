import 'package:flutter/material.dart';
import '../dados.dart';
import 'editorDeCartas_page.dart';

class EditorRespostaPage extends StatefulWidget {
  final int idCarta;
  final String nomeBaralho;

  EditorRespostaPage({
    required this.idCarta,
    required this.nomeBaralho,
  });

  @override
  _EditorRespostaPageState createState() => _EditorRespostaPageState();
}

class _EditorRespostaPageState extends State<EditorRespostaPage> {
  final TextEditingController _respostaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRespostaData();
  }

  Future<void> _loadRespostaData() async {
    String resposta = await Dados.encheAreaDoTextoDeResposta(widget.idCarta);
    setState(() {
      _respostaController.text = resposta;
    });
  }

  void _aoClicarConcluir() {
    Dados.alteraResposta(_respostaController.text, widget.idCarta);
    Navigator.pop(context);
  }

  void _aoClicarRegressa() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _respostaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Resposta'),
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
              controller: _respostaController,
              decoration: InputDecoration(labelText: 'Resposta'),
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
