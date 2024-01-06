import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/edit_form_page.dart';

class FormTabPage extends StatefulWidget {
  final String formId;

  const FormTabPage({super.key, required this.formId});

  @override
  State<FormTabPage> createState() => _FormTabPageState();
}

class _FormTabPageState extends State<FormTabPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ignore: prefer_const_literals_to_create_immutables
              const TabBar(
                indicator: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 2.0))),
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'Questions'),
                  Tab(text: 'Responses'),
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  EditFormPage(formId: widget.formId),
                  const Center(child: Text('Responses')),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
