class Carta {
  var easinessFactor = 2.5;
  var id;
  var intervaloAnterior;
  var intervaloAtual;
  int ordemDaRepeticao = 1;
  String pergunta;
  String resposta;
  String termo1;
  String definicao1;
  String termo2;
  String definicao2;
  String nomeDoBaralho;

  Carta({
    required this.pergunta,
    required this.resposta,
    required this.termo1,
    required this.definicao1,
    required this.termo2,
    required this.definicao2,
    required this.nomeDoBaralho,
    this.easinessFactor = 2.5,
    this.ordemDaRepeticao = 1,
  });


  double getEasinessFactor() => easinessFactor;

  void setEasinessFactor(double value) => easinessFactor = value;

  int getId() => id;

  void setId(int value) => id = value;

  int getIntervalo() => intervaloAtual;

  void setIntervalo(int value) => intervaloAtual = value;

  int getOrdemDaRepeticao() => ordemDaRepeticao;

  void setOrdemDaRepeticao(int value) => ordemDaRepeticao = value;

  String getPergunta() => pergunta;

  void setPergunta(String value) => pergunta = value;

  String getResposta() => resposta;

  void setResposta(String value) => resposta = value;

  String getTermo1() => termo1;

  void setTermo1(String value) => termo1 = value;

  String getDefinicao1() => definicao1;

  void setDefinicao1(String value) => definicao1 = value;

  String getTermo2() => termo2;

  void setTermo2(String value) => termo2 = value;

  String getDefinicao2() => definicao2;

  void setDefinicao2(String value) => definicao2 = value;

  String getNomeDoBaralho() => nomeDoBaralho;

  void setNomeDoBaralho(String value) => nomeDoBaralho = value;
}