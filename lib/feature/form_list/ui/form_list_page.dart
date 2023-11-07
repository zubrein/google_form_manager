import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/edit_form/ui/edit_form_page.dart';
import 'package:google_form_manager/feature/templates/ui/template_page.dart';
import 'package:googleapis/drive/v2.dart';

import 'cubit/form_list_cubit.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TemplatePage()),
        ).then((value) {
          _formListCubit.fetchFormList();
        });
      }),
    );
  }

  Widget _buildFormListItem(File item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditFormPage(formId: item.id!)));
      },
      child: Padding(
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
                fit: BoxFit.fill,
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
      ),
    );
  }

  @override
  void dispose() {
    _formListCubit.close();
    super.dispose();
  }
}
