import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'baralho.dart';
import 'carta.dart';






class Dados {
  static String url = '83.212.82.184';
  static String user = 'phone';
  static String password = 'RKFTEGB4uZ';
  static String dbName = 'projetolicenciatura';

  static Future<MySqlConnection> _getConnection() async {
    final settings = ConnectionSettings(
      host: url,
      port: 3306,
      user: user,
      password: password,
      db: dbName,
      characterSet: CharacterSet.UTF8MB4
    );

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      print('Database connection established');
      return conn;
    } catch (e) {
      print('Error establishing database connection: $e');
      rethrow;
    }
  }


  static Future<Results> _executeQuery(String query, [List<dynamic> params = const []]) async {
    MySqlConnection? conn;
    try {
      conn = await _getConnection();
      print('Executing query: $query with params: $params');

      print('Final query: $query');
      final results = await conn.query(query, params);
      print('Number of rows returned: ${results.length}');
      return results;
    } catch (e) {
      print('SQL Error: $e');
      rethrow;
    } finally {
      if (conn != null) {
        await conn.close();
        print('Database connection closed');
      }
    }
  }





  static Future<List<Baralho>> encheALista() async {
    List<Baralho> lista = [];

    // Use raw query directly for testing
    String query = "SELECT DISTINCT B.NomeBaralho, (SELECT COUNT(*) FROM Cartas C WHERE C.NomeBaralho = B.NomeBaralho) AS Cartas FROM Baralhos B";

    try {
      MySqlConnection conn = await _getConnection();
      print('Connected to the database');

      Results results = await conn.query(query);
      print('Number of rows returned: ${results.length}');

      for (var row in results) {
        print('Row data: $row');
        String nome = row[0];
        int quantidade = row[1];
        print('Adding baralho: $nome with $quantidade cartas');
        lista.add(Baralho(nome, quantidade));
      }

      await conn.close();
      print('Database connection closed');
    } catch (e) {
      print('SQL Error: $e');
    }

    return lista;
  }






  static Future<List<Baralho>> encheAListaDoRever() async {
    List<Baralho> lista = [];
    String query = "SELECT DISTINCT B.NomeBaralho, (SELECT COUNT(*) FROM Cartas C WHERE ((DATEDIFF(CURDATE(),DataUltimoUso) >= C.Intervalo) OR Intervalo IS NULL) AND C.NomeBaralho = B.NomeBaralho) AS Cartas FROM Baralhos B";

    try {
      Results results = await _executeQuery(query);
      for (var row in results) {
        String nome = row[0];
        int quantidade = row[1];
        lista.add(Baralho(nome, quantidade));
      }
    } catch (e) {
      print('SQL Error: $e');
    }
    return lista;
  }

  static Future<void> apagaBaralho(String nomeDoBaralho) async {
    try {
      String query = "DELETE FROM Cartas WHERE NomeBaralho = ?";
      await _executeQuery(query, [nomeDoBaralho]);
      query = "DELETE FROM Baralhos WHERE NomeBaralho = ?";
      await _executeQuery(query, [nomeDoBaralho]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> criaBaralho(String nomeDoBaralho) async {
    try {
      String query = "INSERT INTO Baralhos(NomeBaralho) VALUES(?)";
      await _executeQuery(query, [nomeDoBaralho]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<bool> baralhoInexistente(String nomeDoBaralho) async {
    try {
      String query = "SELECT NomeBaralho FROM Baralhos WHERE NomeBaralho = ?";
      Results results = await _executeQuery(query, [nomeDoBaralho]);
      if (results.isNotEmpty) {
        return false;
      }
    } catch (e) {
      print('SQL Error: $e');
    }
    return true;
  }

  static idMaisBaixoDoBaralho(String nomeDoBaralho) async {
    var idMaisBaixo = 0;
    try {
      String query = "SELECT MIN(ID) FROM Cartas WHERE NomeBaralho = ?";
      Results results = await _executeQuery(query, [nomeDoBaralho]);
      print("Chego aqui");
      if(results.first[0] != null) {
        idMaisBaixo = results.first[0];
      } else {
        print("Está a devolver 0");
        return 0;
      }
      print("Mas aqui já não!");

    } catch (e) {
      print('SQL Error: $e');

    }
    return idMaisBaixo;
  }

  static Future<String> encheAreaDoTextoDePergunta(int idCarta) async {
    String texto = "Texto Inicial";
    try {
      String query = "SELECT Pergunta FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [idCarta]);
      texto = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return texto;
  }

  static Future<String> encheAreaDoTextoDeResposta(int idCarta) async {
    String texto = "Texto Inicial";
    try {
      String query = "SELECT Resposta FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [idCarta]);
      texto = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return texto;
  }

  static Future<void> criaCarta(Carta carta) async {
    try {
      String query = "INSERT INTO Cartas(NomeBaralho, Pergunta, Resposta, EF, Def1, Def2, PrimeiroTermo, SegundoTermo, OrdemDaRepeticao) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
      await _executeQuery(query, [
        carta.nomeDoBaralho,
        carta.pergunta,
        carta.resposta,
        carta.easinessFactor,
        carta.definicao1,
        carta.definicao2,
        carta.termo1,
        carta.termo2,
        carta.ordemDaRepeticao
      ]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<int> encontraIdProximaCarta(int ID, String nomeBaralho) async {
    int valor = -1;
    try {
      String query = "SELECT MIN(ID) AS next FROM Cartas WHERE ID > ? AND NomeBaralho = ?";
      Results results = await _executeQuery(query, [ID, nomeBaralho]);
      valor = results.first[0];
      if (valor == 0) {
        valor = await idMaisBaixoDoBaralho(nomeBaralho);
      }
    } catch (e) {
      print('SQL Error: $e');
    }
    return valor;
  }

  static Future<int> idMaisAltoDoBaralho(String nomeDoBaralho) async {
    int idMaisAlto = 0;
    try {
      String query = "SELECT MAX(ID) FROM Cartas WHERE NomeBaralho = ?";
      Results results = await _executeQuery(query, [nomeDoBaralho]);
      idMaisAlto = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return idMaisAlto;
  }

  static Future<int> encontraIdCartaAnterior(int ID, String nomeBaralho) async {
    int valor = -1;
    try {
      String query = "SELECT MAX(ID) AS preceeding FROM Cartas WHERE ID < ? AND NomeBaralho = ?";
      Results results = await _executeQuery(query, [ID, nomeBaralho]);
      valor = results.first[0];
      if (valor == 0) {
        valor = await idMaisAltoDoBaralho(nomeBaralho);
      }
    } catch (e) {
      print('SQL Error: $e');
    }
    return valor;
  }

  static Future<void> removerCarta(int ID) async {
    try {
      String query = "DELETE FROM Cartas WHERE ID = ?";
      await _executeQuery(query, [ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> alteraPergunta(String novaPergunta, int ID) async {
    try {
      String query = "UPDATE Cartas SET Pergunta = ? WHERE ID = ?";
      await _executeQuery(query, [novaPergunta, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> alteraResposta(String novaResposta, int ID) async {
    try {
      String query = "UPDATE Cartas SET Resposta = ? WHERE ID = ?";
      await _executeQuery(query, [novaResposta, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> novaDefinicao1(String novoTermo1, String novaDefinicao1, int ID) async {
    try {
      String query = "UPDATE Cartas SET PrimeiroTermo = ?, Def1 = ? WHERE ID = ?";
      await _executeQuery(query, [novoTermo1, novaDefinicao1, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> novaDefinicao2(String novoTermo2, String novaDefinicao2, int ID) async {
    try {
      String query = "UPDATE Cartas SET SegundoTermo = ?, Def2 = ? WHERE ID = ?";
      await _executeQuery(query, [novoTermo2, novaDefinicao2, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<String> encontraTermo1(int ID) async {
    String texto = "Texto Inicial";
    try {
      String query = "SELECT PrimeiroTermo FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [ID]);
      texto = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return texto;
  }

  static Future<String> encontraTermo2(int ID) async {
    String texto = "Texto Inicial";
    try {
      String query = "SELECT SegundoTermo FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [ID]);
      texto = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return texto;
  }

  static Future<String> encontraDefinicao1(int ID) async {
    String texto = "Texto Inicial";
    try {
      String query = "SELECT Def1 FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [ID]);
      texto = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return texto;
  }

  static Future<String> encontraDefinicao2(int ID) async {
    String texto = "Texto Inicial";
    try {
      String query = "SELECT Def2 FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [ID]);
      texto = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return texto;
  }

  static Future<int> encontraOrdemDeRepeticao(int ID) async {
    int ordem = -1;
    try {
      String query = "SELECT OrdemDaRepeticao FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [ID]);
      ordem = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return ordem;
  }

  static Future<double> encontraEF(int ID) async {
    double EF = -1.0;
    try {
      String query = "SELECT EF FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [ID]);
      EF = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return EF;
  }

  static Future<int> encontraIntervaloAtual(int ID) async {
    int intervalo = -1;
    try {
      String query = "SELECT Intervalo FROM Cartas WHERE ID = ?";
      Results results = await _executeQuery(query, [ID]);
      intervalo = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return intervalo;
  }

  static Future<void> carregaIntervaloAtual(int intervaloAtual, int ID) async {
    try {
      String query = "UPDATE Cartas SET Intervalo = ? WHERE ID = ?";
      await _executeQuery(query, [intervaloAtual, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> carregaOrdemDeRepeticao(int OR, int ID) async {
    try {
      String query = "UPDATE Cartas SET OrdemDaRepeticao = ? WHERE ID = ?";
      await _executeQuery(query, [OR, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> carregaDataAtual(DateTime localDate, int ID) async {
    try {
      String query = "UPDATE Cartas SET DataUltimoUso = ? WHERE ID = ?";
      await _executeQuery(query, [localDate, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> carregaEF(double EF, int ID) async {
    try {
      String query = "UPDATE Cartas SET EF = ? WHERE ID = ?";
      await _executeQuery(query, [EF, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> carregaIntervaloAnterior(int intervaloAnterior, int ID) async {
    try {
      String query = "UPDATE Cartas SET IntervaloAnterior = ? WHERE ID = ?";
      await _executeQuery(query, [intervaloAnterior, ID]);
    } catch (e) {
      print('SQL Error: $e');
    }
  }

  static Future<void> algoritmoQueReve(int ID, int qualidadeDaResposta) async {
    double EF = await encontraEF(ID);
    if (qualidadeDaResposta >= 3) {
      int OR = await encontraOrdemDeRepeticao(ID);
      int intervaloAtual, intervaloAnterior;
      DateTime agora = DateTime.now();

      if (OR == 1) {
        intervaloAtual = 1;
        OR++;
        EF = EF + (0.1 - (5 - qualidadeDaResposta) * (0.08 + (5 - qualidadeDaResposta) * 0.02));
        await carregaIntervaloAtual(intervaloAtual, ID);
        await carregaOrdemDeRepeticao(OR, ID);
        await carregaDataAtual(agora, ID);
        if (EF < 1.3) EF = 1.3;
        await carregaEF(EF, ID);
      } else if (OR == 2) {
        intervaloAtual = await encontraIntervaloAtual(ID);
        intervaloAnterior = intervaloAtual;
        EF = EF + (0.1 - (5 - qualidadeDaResposta) * (0.08 + (5 - qualidadeDaResposta) * 0.02));
        intervaloAtual = 6;
        OR++;
        await carregaIntervaloAtual(intervaloAtual, ID);
        await carregaIntervaloAnterior(intervaloAnterior, ID);
        await carregaOrdemDeRepeticao(OR, ID);
        await carregaDataAtual(agora, ID);
        if (EF < 1.3) EF = 1.3;
        await carregaEF(EF, ID);
      } else {
        intervaloAtual = await encontraIntervaloAtual(ID);
        intervaloAnterior = intervaloAtual;
        EF = EF + (0.1 - (5 - qualidadeDaResposta) * (0.08 + (5 - qualidadeDaResposta) * 0.02));
        intervaloAtual = (intervaloAnterior * EF).toInt();
        OR++;
        await carregaIntervaloAtual(intervaloAtual, ID);
        await carregaIntervaloAnterior(intervaloAnterior, ID);
        if (EF < 1.3) EF = 1.3;
        await carregaEF(EF, ID);
        await carregaOrdemDeRepeticao(OR, ID);
        await carregaDataAtual(agora, ID);
      }
    } else {
      EF = EF + (0.1 - (5 - qualidadeDaResposta) * (0.08 + (5 - qualidadeDaResposta) * 0.02));
      if (EF < 1.3) EF = 1.3;
      await carregaEF(EF, ID);
    }
  }

  static Future<int> encontraIDAleatorioDosRevisiveis(String nomeDoBaralho) async {
    int id = 0;
    try {
      String query = "SELECT ID FROM Cartas WHERE (NomeBaralho = ?) AND ((DATEDIFF(CURDATE(),DataUltimoUso) >= Intervalo) OR Intervalo IS NULL) ORDER BY RAND() LIMIT 1";
      Results results = await _executeQuery(query, [nomeDoBaralho]);
      id = results.first[0];
    } catch (e) {
      print('SQL Error: $e');
    }
    return id;
  }
}
