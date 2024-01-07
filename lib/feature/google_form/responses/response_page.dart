import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/cubit/form_cubit.dart';

class ResponsePage extends StatefulWidget {
  final FormCubit formCubit;

  const ResponsePage({
    super.key,
    required this.formCubit,
  });

  @override
  State<ResponsePage> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormCubit, EditFormState>(
      bloc: widget.formCubit,
      buildWhen: (oldState, newState) {
        return newState is FetchResponseSuccessState;
      },
      builder: (context, state) {
        if (state is FormListUpdateState) {
          return Center(
              child: Text(widget.formCubit.responseListSize.toString()));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
