import 'package:consulta_cep/app/data/repositories/cep_repository.dart';
import 'package:consulta_cep/app/pages/cubits/cep_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/http/http_client.dart';

class ConsultaCep extends StatelessWidget {
  const ConsultaCep({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    final CepRepository cepRepository = CepRepository(
      client: HttpClient(),
    );
    return Center(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Digite o CEP para pesquisa',
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<CepCubit>().obtenhaCep(nameController.text);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => CepCubit(
                          cepRepository: cepRepository,
                        ),
                        child: RetornoCep(cepInformado: nameController.text),
                      ),
                    ),
                  );
                  //nameController.clear();
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RetornoCep extends StatefulWidget {
  final String cepInformado;

  const RetornoCep({Key? key, required this.cepInformado}) : super(key: key);

  @override
  State<RetornoCep> createState() => _RetornoCepState();
}

class _RetornoCepState extends State<RetornoCep> {
  @override
  void initState() {
    super.initState();
    context.read<CepCubit>().obtenhaCep(widget.cepInformado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            BlocBuilder<CepCubit, CepState>(builder: (context, state) {
              if (state is CepLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CepLoaded) {
                return Center(child: Text(state.cep.bairro));
              } else {
                return const Center(
                  child: Text("Erro ao carregar o CEP"),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
