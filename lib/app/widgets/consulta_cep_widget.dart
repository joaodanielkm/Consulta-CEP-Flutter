import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulta_cep/app/pages/cubits/cep_cubit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ConsultaCep extends StatelessWidget {
  const ConsultaCep({super.key});

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

    TextEditingController nameController = TextEditingController();
    return Center(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.2),
                                offset: const Offset(5, 8),
                                blurRadius: 10)
                          ]),
                      child: SizedBox(
                        width: 600,
                        child: TextFormField(
                          controller: nameController,
                          inputFormatters: [maskFormatter],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Digite o CEP para pesquisa",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              FloatingActionButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context
                      .read<CepCubit>()
                      .obtenhaCep(nameController.text, context);
                },
                elevation: 10.0,
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.black,
                shape: const CircleBorder(),
                child: const Icon(Icons.search),
              ),
              const SizedBox(height: 60),
              BlocBuilder<CepCubit, CepState>(
                builder: (context, state) {
                  if (state is CepLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is CepLoaded) {
                    return Center(
                        child: Container(
                      width: 600,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 242, 245, 255),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color.fromARGB(255, 186, 205, 255)
                                    .withOpacity(.9),
                                offset: const Offset(0, 0),
                                blurRadius: 30)
                          ]),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Estado: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: state.cep.uf,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Cidade: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: state.cep.localidade,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Setor/Bairro: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: state.cep.bairro,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Logradouro: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: state.cep.logradouro,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Código IBGE: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: state.cep.ibge,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'DDD: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: state.cep.ddd,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'CEP: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: state.cep.cep,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
                  } else if (state is CepError) {
                    return const Center(
                      child: Text(
                        "Digite um cep para pesquisar!",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Digite um cep para pesquisar!",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
