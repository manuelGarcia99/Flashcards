import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../dados.dart';
import '../baralho.dart';
import 'editorDeCartas_page.dart';

class EditarBaralhoPage extends StatefulWidget {
  @override
  _EditarBaralhoPageState createState() => _EditarBaralhoPageState();
}

class _EditarBaralhoPageState extends State<EditarBaralhoPage> {
  List<Baralho> _baralhos = [];

  @override
  void initState() {
    super.initState();
    _fetchBaralhos();
  }

  void _fetchBaralhos() async {
    var lista = await Dados.encheALista();
    print("Chego aqui na pagina editar Baralho");
    setState(() {
      _baralhos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Baralho'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _baralhos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_baralhos[index].nome),
                  subtitle: Text('Cartas: ${_baralhos[index].numeroDeCartas}'),
                  onTap: () => _confirmEditBaralho(context, _baralhos[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Retornar'),
          ),
        ],
      ),
    );
  }

  void _confirmEditBaralho(BuildContext context, Baralho baralho) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Edição'),
        content: Text('Deseja realmente editar ${baralho.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Sim'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      int idMaisBaixo = await Dados.idMaisBaixoDoBaralho(baralho.nome);
      if (idMaisBaixo == 0) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Baralho Vazio'),
            content: Text('Esse baralho está vazio.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditorDeCartasPage(
                        nomeBaralho: baralho.nome,
                        cartaId: idMaisBaixo,
                      ),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditorDeCartasPage(nomeBaralho: baralho.nome, cartaId: idMaisBaixo),
          ),
        );
      }
    }
  }
}
