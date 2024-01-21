import 'package:bloc/bloc.dart';
import 'package:consulta_cep/app/data/models/cep_model.dart';
import 'package:consulta_cep/app/data/repositories/cep_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FetchCep extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class CepState extends Equatable {
  @override
  List<Object> get props => [];
}

class CepInitial extends CepState {}

class CepLoading extends CepState {}

class CepLoaded extends CepState {
  final Cep cep;
  CepLoaded(this.cep);

  @override
  List<Object> get props => [cep];
}

class CepError extends CepState {
  final String message;
  CepError(this.message);

  @override
  List<Object> get props => [message];
}

class CepCubit extends Cubit<CepState> {
  final ICepRepository cepRepository;

  CepCubit({required this.cepRepository}) : super(CepInitial());

  Future<void> obtenhaCep(String cepInformado, BuildContext context) async {
    if (cepInformado.isEmpty || cepInformado.length < 9) {
      _mostrarAlerta(context, 'Informe um CEP válido!');
      return emit(CepError(''));
    }
    try {
      emit(CepLoading());
      final Cep cep = await cepRepository.getCep(cepInformado);
      emit(CepLoaded(cep));
    } catch (e) {
      _mostrarAlerta(context, 'CEP não encontrado!');
      emit(CepError(''));
    }
  }

  void _mostrarAlerta(BuildContext context, String mensagem) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Ops!')),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Color.fromARGB(255, 255, 46, 46),
                  size: 40.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  mensagem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 23),
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Colors.grey.shade300,
              width: 2.0,
            ),
          ),
        );
      },
    );
  }
}
