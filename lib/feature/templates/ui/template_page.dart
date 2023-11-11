import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/templates/ui/cubit/create_form_cubit.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  late CreateFormCubit _createFormCubit;

  @override
  void initState() {
    super.initState();
    _createFormCubit = sl<CreateFormCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create form'),
      ),
      body: BlocConsumer<CreateFormCubit, CreateFormState>(
        bloc: _createFormCubit,
        listener: (context, state) {
          if(state is CreateFormInitiatedState){
            Log.info('Form creation initiated');
          }else if(state is CreateFormSuccessState){
            Navigator.of(context).pop();
          }else if(state is CreateFormFailedState){
            Log.info('Form creation failed');
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildAddButton(),
              const Gap(40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        _createFormCubit.createForm('test form');
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );
  }
}
