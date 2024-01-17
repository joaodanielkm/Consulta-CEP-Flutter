import 'package:bloc/bloc.dart';
import 'package:consulta_cep/app/data/models/cep_model.dart';
import 'package:consulta_cep/app/data/repositories/cep_repository.dart';

import 'package:equatable/equatable.dart';

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

  Future<void> obtenhaCep(String cepInformado) async {
    if (cepInformado.isEmpty || cepInformado.length < 9) {
      return emit(CepError('CEP inválido!'));
    }
    try {
      emit(CepLoading());
      final Cep cep = await cepRepository.getCep(cepInformado);
      emit(CepLoaded(cep));
    } catch (e) {
      emit(CepError('CEP não encontrado!'));
    }
  }
}
