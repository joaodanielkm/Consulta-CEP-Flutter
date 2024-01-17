import 'package:consulta_cep/app/widgets/consulta_cep_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulta_cep/app/pages/cubits/cep_cubit.dart';
import 'package:consulta_cep/app/data/repositories/cep_repository.dart';

import '../data/http/http_client.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CepRepository cepRepository = CepRepository(
      client: HttpClient(),
    );

    return MaterialApp(
      home: BlocProvider(
        create: (context) => CepCubit(
          cepRepository: cepRepository,
        ),
        child: const ConsultaCep(),
      ),
    );
  }
}
