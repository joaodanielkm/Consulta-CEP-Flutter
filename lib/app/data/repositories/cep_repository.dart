import 'dart:convert';
import 'package:consulta_cep/app/data/http/http_client.dart';
import 'package:consulta_cep/app/data/models/cep_model.dart';

abstract class ICepRepository {
  Future<Cep> getCep(String cepInformado);
}

class CepRepository implements ICepRepository {
  final IHttpClient client;

  CepRepository({required this.client});

  @override
  Future<Cep> getCep(String cepInformado) async {
    final response =
        await client.get(url: "https://viacep.com.br/ws/$cepInformado/json");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      Cep cep = Cep.fromJson(body);
      return cep;
    } else if (response.statusCode == 404) {
      throw Exception('Url não é válida');
    } else {
      throw Exception('Não foi possivel carregar o CEP.');
    }
  }
}
