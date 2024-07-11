import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../dados.dart';
import '../baralho.dart';
import 'revisorFrontEnd_page.dart';

class ReverBaralhoPage extends StatefulWidget {
  @override
  _ReverBaralhoPageState createState() => _ReverBaralhoPageState();
}

class _ReverBaralhoPageState extends State<ReverBaralhoPage> {
  List<Baralho> lista = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Baralho> tempList = await Dados.encheAListaDoRever();
    setState(() {
      lista = tempList;
    });
  }

  void _navigateToRevisorFrontEnd(String nomeBaralho) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RevisorFrontEndPage(nomeDoBaralho: nomeBaralho),
      ),
    );
  }

  void _showConfirmationDialog(Baralho baralho) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Deseja realmente rever ${baralho.nome}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToRevisorFrontEnd(baralho.nome);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rever Baralho'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Retornar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final baralho = lista[index];
                return ListTile(
                  title: Text(baralho.nome),
                  subtitle: Text('Cartas: ${baralho.numeroDeCartas}'),
                  onTap: () => _showConfirmationDialog(baralho),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
