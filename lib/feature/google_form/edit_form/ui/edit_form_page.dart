import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';
import 'package:google_form_manager/feature/shared/widgets/alert_dialog_widget.dart';
import 'package:googleapis/forms/v1.dart';

import '../domain/entities/base_item_entity.dart';
import '../domain/entities/youtube_data_entity.dart';
import '../domain/enums.dart';
import 'cubit/form_cubit.dart';
import 'item_type_list_page.dart';
import 'widgets/helper/create_question_item_helper.dart';
import 'widgets/shared/base_item_with_widget_selector.dart';
import 'widgets/shared/edit_text_widget.dart';
import 'widgets/video/video_widget_dialog.dart';

class EditFormPage extends StatefulWidget {
  final String formId;
  final FormCubit formCubit;
  final LoadingHudCubit loadingHudCubit;

  const EditFormPage(
      {super.key,
      required this.formId,
      required this.formCubit,
      required this.loadingHudCubit});

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.loadingHudCubit.show();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (widget.formCubit.checkIfListIsEmpty()) {
          pop();
        } else {
          await _showSaveDialog('exit');
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildFormListView(),
          ],
        ),
        bottomSheet: _buildBottomPanel(),
      ),
    );
  }

  Widget _buildFormListView() {
    return Expanded(
      child: BlocConsumer<FormCubit, EditFormState>(
        bloc: widget.formCubit,
        listener: _onListenFormCubit,
        buildWhen: (oldState, newState) {
          return newState is FormListUpdateState;
        },
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFormTitleDescSection(),
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final BaseItemEntity item =
                            widget.formCubit.baseItemList.removeAt(oldIndex);
                        widget.formCubit.baseItemList.insert(newIndex, item);
                        widget.formCubit.moveItem(
                          newIndex,
                          widget.formCubit.baseItemList[newIndex],
                        );
                      });
                    },
                    children: _buildFormList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildFormList() {
    final List<Widget> formList = [];

    for (int i = 0; i < widget.formCubit.baseItemList.length; i++) {
      formList.add(_buildFormItem(widget.formCubit.baseItemList[i], i));
    }

    return formList;
  }

  Widget _buildFormTitleDescSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff6818B9),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff6818B9).withOpacity(0.15),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildFormTitle(),
                      const Gap(8),
                      _buildFormDescription(),
                      const Gap(8),
                    ],
                  ),
                )),
          )),
    );
  }

  void _onListenFormCubit(context, state) async {
    if (state is ShowTitleState) {
      _titleController.text = state.title;
      _descriptionController.text = state.description;
    } else if (state is FormListUpdateState) {
      widget.loadingHudCubit.cancel();
    } else if (state is FormSubmitFailedState) {
      widget.loadingHudCubit.showError(message: state.error);
    } else if (state is FormSubmitSuccessState) {
      // await _onFormSubmitSuccess(context);
      widget.loadingHudCubit.cancel();
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Form updated successfully',
                textAlign: TextAlign.center,
              ),
            );
          });

    }
  }

  // Future<void> _onFormSubmitSuccess(BuildContext context) async {
  //   await showDialog(
  //       useRootNavigator: false,
  //       context: context,
  //       builder: (_) {
  //         return confirmationDialog(
  //           context: context,
  //           message:
  //               'Your progress has been submitted successfully. Do you want to share?',
  //           onTapContinueButton: () async {
  //             await shareForm(widget.formCubit.responderUrl)
  //                 .then((value) => Navigator.of(context).pop());
  //           },
  //           onTapCancelButton: () {
  //             Navigator.pop(context);
  //           },
  //           cancelText: 'exit',
  //         );
  //       }).then((value) => pop());
  // }

  bool _checkIfQuestionTypeIsUnknown(Item item) {
    final type = widget.formCubit.checkQuestionType(item);
    return type != QuestionType.unknown ? true : false;
  }

  Widget _buildFormItem(BaseItemEntity formItem, int position) {
    return _checkIfQuestionTypeIsUnknown(formItem.item!)
        ? BaseItemWithWidgetSelector(
            key: formItem.key,
            formCubit: widget.formCubit,
            questionType: widget.formCubit.checkQuestionType(formItem.item),
            formItem: formItem,
            index: position,
          )
        : const SizedBox.shrink();
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
              widget.loadingHudCubit.show();
              widget.formCubit.submitRequest(widget.formId, fromShare: true);
            },
            onTapCancelButton: () {
              Navigator.pop(context);
              if (cancelText == 'exit') {
                Navigator.pop(context);
              }
            },
            cancelText: cancelText,
          );
        });
  }

  void pop() {
    widget.loadingHudCubit.cancel();
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
                _buildVideoAddButton(),
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
        widget.formCubit.addItem(
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

  Widget _buildVideoAddButton() {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog(
            useRootNavigator: false,
            context: context,
            builder: (_) {
              return VideoWidgetDialog(
                  context: context, formCubit: widget.formCubit);
            });

        YoutubeDataEntity youtubeDataEntity = result[0] as YoutubeDataEntity;

        widget.formCubit.addItem(
          Item(
            title: '',
            description: '',
            videoItem: VideoItem(
              caption: '',
              video: Video(youtubeUri: youtubeDataEntity.url),
            ),
          ),
          QuestionType.video,
        );
        scrollToBottom();
      },
      child: const SizedBox(
          height: 50, width: 50, child: Icon(Icons.slow_motion_video_sharp)),
    );
  }

  Widget _buildPageBreakAddButton() {
    return GestureDetector(
      onTap: () async {
        widget.formCubit.addItem(
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
        widget.formCubit.addItem(
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
          widget.formCubit.addItem(
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

  Widget _buildFormTitle() {
    return EditTextWidget(
      controller: _titleController,
      fontSize: 18,
      fontColor: Colors.black,
      fontWeight: FontWeight.w700,
      onChange: _onChangeTitleText,
      hint: 'Form Title',
      enabled: true,
    );
  }

  Widget _buildFormDescription() {
    return EditTextWidget(
      controller: _descriptionController,
      fontSize: 16,
      fontColor: Colors.black54,
      fontWeight: FontWeight.w500,
      onChange: _onChangeDescriptionText,
      hint: 'Form Description',
      enabled: true,
    );
  }

  void _onChangeTitleText(String value) {
    if (widget.formCubit.formInfoUpdateRequest != null) {
      widget.formCubit.formInfoUpdateRequest?.updateFormInfo?.info?.title =
          value;
      widget.formCubit.formInfoUpdateRequest?.updateFormInfo?.updateMask =
          'title';
      value;
    } else {
      widget.formCubit.formInfoUpdateRequest = Request(
          updateFormInfo: UpdateFormInfoRequest(
              info: Info(title: value), updateMask: 'title,description'));
    }
  }

  void _onChangeDescriptionText(String value) {
    if (widget.formCubit.formInfoUpdateRequest != null) {
      widget.formCubit.formInfoUpdateRequest?.updateFormInfo?.info
          ?.description = value;
      widget.formCubit.formInfoUpdateRequest?.updateFormInfo?.updateMask =
          'description';
      value;
    } else {
      widget.formCubit.formInfoUpdateRequest = Request(
          updateFormInfo: UpdateFormInfoRequest(
              info: Info(description: value), updateMask: 'title,description'));
    }
  }

  @override
  void dispose() {
    widget.formCubit.deleteImagesFromDrive();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
