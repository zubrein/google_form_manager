import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/entities/base_item_entity.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/edit_form_top_panel.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';

import '../../shared/widgets/alert_dialog_widget.dart';
import 'cubit/edit_form_cubit.dart';
import 'item_type_list_page.dart';
import 'widgets/helper/create_question_item_helper.dart';
import 'widgets/shared/base_item_with_widget_selector.dart';

class EditFormPage extends StatefulWidget {
  final String formId;

  const EditFormPage({super.key, required this.formId});

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  late EditFormCubit _editFormCubit;
  late LoadingHudCubit _loadingHudCubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _editFormCubit = sl<EditFormCubit>();
    _loadingHudCubit = sl<LoadingHudCubit>();
    _loadingHudCubit.show();
    _editFormCubit.fetchForm(widget.formId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _showSaveDialog('exit');
        pop();
        return false;
      },
      child: Base(
        loadingHudCubit: _loadingHudCubit,
        child: Scaffold(
          appBar: AppBar(title: const Text('Edit form')),
          body: Column(
            children: [
              _buildTopPanel(),
              _buildFormListView(),
            ],
          ),
          bottomSheet: _buildBottomPanel(),
        ),
      ),
    );
  }

  Widget _buildFormListView() {
    return Expanded(
      child: BlocConsumer<EditFormCubit, EditFormState>(
        bloc: _editFormCubit,
        listener: (context, state) async {
          if (state is FormListUpdateState) {
            _loadingHudCubit.cancel();
          } else if (state is FormSubmitFailedState) {
            if (state.fromShare && state.error == Constants.noChangesText) {
              await shareForm(_editFormCubit.responderUrl);
              pop();
            } else {
              _loadingHudCubit.showError(message: state.error);
            }
          } else if (state is FormSubmitSuccessState) {
            await shareForm(_editFormCubit.responderUrl);
            pop();
          }
        },
        buildWhen: (oldState, newState) {
          return newState is FormListUpdateState;
        },
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 50),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _editFormCubit.baseItemList.length,
                itemBuilder: (context, position) {
                  final formItem = _editFormCubit.baseItemList[position];
                  return _buildFormItem(formItem, position);
                }),
          );
        },
      ),
    );
  }

  bool _checkIfQuestionTypeIsUnknown(Item item) {
    final type = _editFormCubit.checkQuestionType(item);
    return type != QuestionType.unknown ? true : false;
  }

  Widget _buildFormItem(BaseItemEntity formItem, int position) {
    return _checkIfQuestionTypeIsUnknown(formItem.item!)
        ? BaseItemWithWidgetSelector(
            key: formItem.key,
            editFormCubit: _editFormCubit,
            questionType: _editFormCubit.checkQuestionType(formItem.item),
            formItem: formItem,
            index: position,
          )
        : const SizedBox.shrink();
  }

  Widget _buildTopPanel() {
    return EditFormTopPanel(
      onSaveButtonTap: () async {
        _loadingHudCubit.show();
        _editFormCubit.submitRequest(widget.formId);
      },
      onShareButtonTap: () async {
        _showSaveDialog('cancel');
      },
    );
  }

  Future<void> _showSaveDialog(String cancelText) async {
    await showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) {
          return confirmationDialog(
            context: context,
            message:
                'Your progress is not saved yet. Do you want to save your progress?',
            onTapContinueButton: () {
              Navigator.of(context).pop();
              _loadingHudCubit.show();
              _editFormCubit.submitRequest(widget.formId, fromShare: true);
            },
            onTapCancelButton: () {
              Navigator.pop(context);
            },
            cancelText: cancelText,
          );
        });
  }

  void pop() {
    _loadingHudCubit.cancel();
    Navigator.of(context).pop();
  }

  Widget _buildBottomPanel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: SizedBox(
        height: 50,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black45, width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNewItemAddButton(),
                _buildImageItemAddButton(),
                _buildTextItemAddButton(),
                _buildPageBreakAddButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextItemAddButton() {
    return GestureDetector(
      onTap: () async {
        _editFormCubit.addItem(
          CreateQuestionItemHelper.getItem(
            QuestionType.text,
          ),
          QuestionType.text,
        );
        scrollToBottom();
      },
      child: const SizedBox(
          height: 50, width: 50, child: Icon(Icons.text_fields_outlined)),
    );
  }

  Widget _buildPageBreakAddButton() {
    return GestureDetector(
      onTap: () async {
        _editFormCubit.addItem(
          CreateQuestionItemHelper.getItem(
            QuestionType.pageBreak,
          ),
          QuestionType.pageBreak,
        );
        scrollToBottom();
      },
      child: const SizedBox(
          height: 50, width: 50, child: Icon(Icons.insert_page_break)),
    );
  }

  Widget _buildImageItemAddButton() {
    return GestureDetector(
      onTap: () async {
        _editFormCubit.addItem(
          CreateQuestionItemHelper.getItem(
            QuestionType.image,
          ),
          QuestionType.image,
        );
        scrollToBottom();
      },
      child: const SizedBox(height: 50, width: 50, child: Icon(Icons.image)),
    );
  }

  Widget _buildNewItemAddButton() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ItemTypeListPage()));

        if (result != null) {
          _editFormCubit.addItem(
            CreateQuestionItemHelper.getItem(result[0]),
            result[0],
          );
        }

        scrollToBottom();
      },
      child: const SizedBox(
          height: 50, width: 50, child: Icon(Icons.add_circle_outline)),
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

  @override
  void dispose() {
    _editFormCubit.deleteImagesFromDrive();
    super.dispose();
  }
}
