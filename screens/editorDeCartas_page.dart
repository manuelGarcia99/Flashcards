import 'package:flutter/material.dart';
import '../dados.dart';
import 'adicionadorDeCartas_page.dart';
import 'editorPergunta_page.dart';
import 'editorResposta_page.dart';
import 'editorDefinicao1_page.dart';
import 'editorDefinicao2_page.dart';

class EditorDeCartasPage extends StatefulWidget {
  final String nomeBaralho;
  var  cartaId;

  EditorDeCartasPage({required this.nomeBaralho,this.cartaId});

  @override
  _EditorDeCartasPageState createState() => _EditorDeCartasPageState();
}

class _EditorDeCartasPageState extends State<EditorDeCartasPage> {
  int _idCarta = 0;
  String _pergunta = "Pergunta Inicial";
  final List<String> _editOptions = ["Pergunta", "Resposta", "Definição 1", "Definição 2"];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    int id = await Dados.idMaisBaixoDoBaralho(widget.nomeBaralho);
    String pergunta = await Dados.encheAreaDoTextoDePergunta(id);
    setState(() {
      _idCarta = id;
      _pergunta = pergunta;
    });
  }

  void _loadData(int id) async {
    String pergunta = await Dados.encheAreaDoTextoDePergunta(id);
    setState(() {
      _idCarta = id;
      _pergunta = pergunta;
    });
  }

  void _navigateToEditor(String option) {
    Widget page;
    switch (option) {
      case "Pergunta":
        page = EditorPerguntaPage(idCarta: _idCarta, nomeBaralho: widget.nomeBaralho);
        break;
      case "Resposta":
        page = EditorRespostaPage(idCarta: _idCarta, nomeBaralho: widget.nomeBaralho);
        break;
      case "Definição 1":
        page = EditorDefinicao1Page(idCarta: _idCarta, nomeBaralho: widget.nomeBaralho);
        break;
      case "Definição 2":
        page = EditorDefinicao2Page(idCarta: _idCarta, nomeBaralho: widget.nomeBaralho);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) => _loadData(_idCarta));
  }

  void _removeCarta() async {
    await Dados.removerCarta(_idCarta);
    int nextId = await Dados.encontraIdProximaCarta(_idCarta, widget.nomeBaralho);
    _loadData(nextId);
  }

  void _goToNextCarta() async {
    int nextId = await Dados.encontraIdProximaCarta(_idCarta, widget.nomeBaralho);
    _loadData(nextId);
  }

  void _goToPreviousCarta() async {
    int prevId = await Dados.encontraIdCartaAnterior(_idCarta, widget.nomeBaralho);
    _loadData(prevId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor de Cartas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Id: $_idCarta'),
            SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: _pergunta),
              readOnly: true,
              decoration: InputDecoration(labelText: 'Pergunta'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdicionadorDeCartasPage(
                      idUltimaCarta: _idCarta,
                      nomeDoBaralho: widget.nomeBaralho,
                      definicao1: '',
                      termo1: '',
                      definicao2: '',
                      termo2: '',
                    ),
                  ),
                ).then((_) => _loadData(_idCarta));
              },
              child: Text('Adicionar Nova Carta'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _removeCarta,
              child: Text('Remover Carta'),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              items: _editOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _navigateToEditor(newValue);
                }
              },
              hint: Text('Editar/Ver'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _goToPreviousCarta,
                  child: Text('Anterior'),
                ),
                ElevatedButton(
                  onPressed: _goToNextCarta,
                  child: Text('Próxima'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
