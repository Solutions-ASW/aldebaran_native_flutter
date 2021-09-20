// ignore_for_file: prefer_collection_literals

class ResultModel {
  int? semana;
  double? valorAtual;
  double? deposito;
  double? acumuladoSemanal;
  double? juros;
  double? acumulado;

  ResultModel(
      {this.semana,
      this.valorAtual,
      this.deposito,
      this.acumuladoSemanal,
      this.juros,
      this.acumulado});

  ResultModel.fromJson(Map<String, dynamic> json) {
    semana = json['semana'];
    valorAtual = json['valor_atual'];
    deposito = json['deposito'];
    acumuladoSemanal = json['acumulado_semanal'];
    juros = json['juros'];
    acumulado = json['acumulado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['semana'] = semana;
    data['valor_atual'] = valorAtual;
    data['deposito'] = deposito;
    data['acumulado_semanal'] = acumuladoSemanal;
    data['juros'] = juros;
    data['acumulado'] = acumulado;
    return data;
  }
}
