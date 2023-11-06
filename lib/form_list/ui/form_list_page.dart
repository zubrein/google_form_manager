import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/form_list/ui/cubit/form_list_cubit.dart';
import 'package:googleapis/drive/v2.dart';

class FormListPage extends StatefulWidget {
  const FormListPage({super.key});

  @override
  State<FormListPage> createState() => _FormListPageState();
}

class _FormListPageState extends State<FormListPage> {
  late FormListCubit _formListCubit;

  @override
  void initState() {
    super.initState();
    _formListCubit = sl<FormListCubit>();
    _formListCubit.fetchFormList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form list'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder(
            bloc: _formListCubit,
            builder: (context, state) {
              if (state is FormListFetchSuccessState) {
                return ListView.builder(
                    itemCount: state.formList.length,
                    itemBuilder: (context, position) {
                      return _buildFormListItem(state.formList[position]);
                    });
              } else {
                return const Text('Fetching');
              }
            }),
      ),
    );
  }

  Widget _buildFormListItem(File item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            height: 100,
            width: 70,
            child: Image.network(
              item.thumbnailLink!,
              headers: <String, String>{
                'Authorization': 'Bearer ${_formListCubit.token}',
                'Custom-Header': 'Custom-Value',
              },
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              children: [
                Text(item.title.toString()),
                Text(item.createdDate.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _formListCubit.close();
    super.dispose();
  }
}
