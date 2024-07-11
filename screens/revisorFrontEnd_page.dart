import 'package:flutter/material.dart';
import '../dados.dart';

class RevisorFrontEndPage extends StatefulWidget {
  final String nomeDoBaralho;

  RevisorFrontEndPage({required this.nomeDoBaralho});

  @override
  _RevisorFrontEndPageState createState() => _RevisorFrontEndPageState();
}

class _RevisorFrontEndPageState extends State<RevisorFrontEndPage> {
  int id = 0;
  String pergunta = "";
  String resposta = "";
  String definicao1 = "";
  String definicao2 = "";
  int qualidade = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    id = await Dados.encontraIDAleatorioDosRevisiveis(widget.nomeDoBaralho);
    pergunta = await Dados.encheAreaDoTextoDePergunta(id);
    setState(() {});
  }

  void _showResposta() async {
    resposta = await Dados.encheAreaDoTextoDeResposta(id);
    definicao1 = await Dados.encontraDefinicao1(id);
    definicao2 = await Dados.encontraDefinicao2(id);
    setState(() {});
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _setQualidade(int value) {
    qualidade = value;
    setState(() {});
  }

  void _nextCard() async {
    await Dados.algoritmoQueReve(id, qualidade);
    _fetchData();
    _resetView();
  }

  void _resetView() {
    resposta = "";
    definicao1 = "";
    definicao2 = "";
    qualidade = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revisor Front End'),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        children: <Widget>[
          TextField(
            controller: TextEditingController(text: pergunta),
            readOnly: true,
            maxLines: 5,
          ),
          TextField(
            controller: TextEditingController(text: resposta),
            readOnly: true,
            maxLines: 5,
            decoration: InputDecoration(hintText: 'Resposta'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: _showResposta,
                child: Text('Mostrar Resposta'),
              ),
              ElevatedButton(
                onPressed: () => _showAlert(definicao1),
                child: Text('Mostrar D1'),
              ),
              ElevatedButton(
                onPressed: () => _showAlert(definicao2),
                child: Text('Mostrar D2'),
              ),
            ],
          ),
          DropdownButton<int>(
            value: qualidade,
            items: [
              DropdownMenuItem(value: 0, child: Text("0: Branca completa")),
              DropdownMenuItem(value: 1, child: Text("1: Resposta incorreta, memorizei a correta")),
              DropdownMenuItem(value: 2, child: Text("2: Resposta incorreta, mas parece ser fácil")),
              DropdownMenuItem(value: 3, child: Text("3: Resposta correta, lembrada com grande dificuldade")),
              DropdownMenuItem(value: 4, child: Text("4: Resposta correta, depois de hesitação")),
              DropdownMenuItem(value: 5, child: Text("5: Resposta excelente!")),
            ],
            onChanged: (value) {
              if (value != null) {
                _setQualidade(value);
              }
            },
            hint: Text("Entendimento"),
          ),
          ElevatedButton(
            onPressed: _nextCard,
            child: Text('Próxima'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Retorna'),
          ),
        ],
      ),
    );
  }
}
