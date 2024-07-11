import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';
import '../baralho.dart';
import '../dados.dart';

class ApagarBaralhoPage extends StatefulWidget {
  @override
  _ApagarBaralhoPageState createState() => _ApagarBaralhoPageState();
}

class _ApagarBaralhoPageState extends State<ApagarBaralhoPage> {
  List<Baralho> lista = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Baralho> tempList = await Dados.encheALista();
      print('Fetched ${tempList.length} items');
      setState(() {
        lista = tempList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _showConfirmationDialog(Baralho baralho) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Deseja realmente apagar ${baralho.nome}?'),
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
                _apagarBaralho(baralho);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _apagarBaralho(Baralho baralho) async {
    await Dados.apagaBaralho(baralho.nome);
    setState(() {
      lista.remove(baralho);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apagar Baralho'),
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
            child: lista.isEmpty
                ? Center(child: Text('No items found'))
                : ListView.builder(
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
