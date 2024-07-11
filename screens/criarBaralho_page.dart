import 'package:flutter/material.dart';
import '../dados.dart'; // Assuming dados.dart is in the same directory

class CriarBaralhoPage extends StatefulWidget {
  @override
  _CriarBaralhoPageState createState() => _CriarBaralhoPageState();
}

class _CriarBaralhoPageState extends State<CriarBaralhoPage> {
  final TextEditingController _nomeController = TextEditingController();
  String? baralhoNome;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Baralho'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Baralho',
                ),
                onChanged: (value) => baralhoNome = value,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('RETORNAR'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (baralhoNome != null && baralhoNome!.isNotEmpty) {
                        // Check baralho existence using Dados.baralhoInexistente
                        bool baralhoExiste = await Dados.baralhoInexistente(baralhoNome!);
                        if (baralhoExiste) {
                          // Show confirmation dialog if baralho doesn't exist
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmação'),
                              content: Text('Deseja criar o baralho "$baralhoNome"?'),
                              actions: [
                                TextButton(
                                  child: Text('SIM'),
                                  onPressed: () async {
                                    // Simulate successful creation (assuming creation logic exists)
                                    // Replace with actual creation logic
                                    await Dados.criaBaralho(baralhoNome!); // Assuming a criaBaralho function
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Baralho "$baralhoNome" criado com sucesso!'),
                                      ),
                                    );
                                    Navigator.pop(context); // Close dialog
                                    Navigator.pop(context); // Navigate back (assuming appropriate)
                                  },
                                ),
                                TextButton(
                                  child: Text('NÃO'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Show error message if baralho already exists
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('O baralho "$baralhoNome" já existe.'),
                            ),
                          );
                        }
                      } else {
                        // Show error message for empty name
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, insira um nome para o baralho.'),
                          ),
                        );
                      }
                    },
                    child: Text('Criar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}