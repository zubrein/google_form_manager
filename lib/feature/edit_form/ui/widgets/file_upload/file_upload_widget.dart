import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/helper/title_desciption_adder_mixin.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../domain/constants.dart';
import '../../bottom_modal_operation_constant.dart';
import '../helper/request_builder_helper_mixin.dart';

class FileUploadWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final EditFormCubit editFormCubit;

  const FileUploadWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.editFormCubit,
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget>
    with
        RequestBuilderHelper,
        TitleDescriptionAdderMixin,
        AutomaticKeepAliveClientMixin {
  bool fileTypeCheck = false;
  List<String>? fileTypeList = [];

  @override
  void init() {
    showDescription = widget.item?.description != null;
    fileTypeCheck = _checkAnyFileTypeIsSelected();
  }

  @override
  Widget build(BuildContext context) {
    questionController.text = widget.item?.title ?? '';
    descriptionController.text = widget.item?.description ?? '';
    fileTypeList =
        widget.item?.questionItem?.question?.fileUploadQuestion?.types;
    super.build(context);
    return baseWidget();
  }

  bool _checkAnyFileTypeIsSelected() {
    final item = widget.item?.questionItem?.question?.fileUploadQuestion;
    if (item != null) {
      final typeList = item.types;
      if (typeList!.contains('ANY')) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  Widget body() {
    return Column(children: [
      buildEditTitleWidget(enabled: false),
      const Gap(4),
      buildEditDescriptionWidget(enabled: false),
      const Gap(16),
      _buildFileTypeList(),
    ]);
  }

  Widget _buildFileTypeList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildFileTypeSwitchWidget(),
          const Gap(16),
          if (fileTypeCheck) _buildFileTypeListGrid(),
          const Gap(8),
          _buildMaxFileCountRow(),
          const Gap(8),
          _buildMaxFileSizeRow(),
          const Gap(16),
          Container(
            color: Colors.redAccent,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'File upload question cant be edited/created on this version',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxFileCountRow() {
    return Row(
      children: [
        const Text('Maximum number of files'),
        const Gap(32),
        _buildMaxFileCountDropDown(),
      ],
    );
  }

  Widget _buildMaxFileSizeRow() {
    return Row(
      children: [
        const Text('Maximum file size'),
        const Gap(32),
        _buildMaxFileSizeDropDown(),
      ],
    );
  }

  Widget _buildMaxFileCountDropDown() {
    List<int> count = [1, 5, 10];
    return DropdownButton<int>(
      value:
          widget.item?.questionItem?.question?.fileUploadQuestion?.maxFiles ??
              1,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      elevation: 16,
      style: const TextStyle(color: Colors.black54),
      onChanged: null,
      items: count.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildMaxFileSizeDropDown() {
    List<int> count = [1, 10, 100, 1024, 10240];
    return DropdownButton<int>(
      value:
          widget.item?.questionItem?.question?.fileUploadQuestion?.maxFiles ??
              1,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      elevation: 16,
      style: const TextStyle(color: Colors.black54),
      onChanged: null,
      items: count.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value < 100
              ? '$value MB'
              : value == 1024
                  ? '1 GB'
                  : '10 GB'),
        );
      }).toList(),
    );
  }

  Widget _buildFileTypeListGrid() {
    return GridView.builder(
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        mainAxisExtent: 35,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, position) {
        return _buildFileTypeItem(uploadAFileTypeList[position]);
      },
    );
  }

  Widget _buildFileTypeItem(String name) {
    bool checkBoxValue = fileTypeList?.contains(name) ?? false;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: checkBoxValue, onChanged: (value) {}),
        Text(
          name,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFileTypeSwitchWidget() {
    return Row(
      children: [
        const Text('Allow Only Specific file types'),
        const Gap(16),
        FlutterSwitch(
          activeColor: Colors.green,
          width: 30.0,
          height: 16.0,
          toggleSize: 12.0,
          value: fileTypeCheck,
          borderRadius: 8.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {},
        )
      ],
    );
  }

  @override
  int get widgetIndex => widget.index;

  @override
  QuestionType get questionType => QuestionType.fileUpload;

  @override
  OperationType get operationType => widget.operationType;

  @override
  bool? get isRequired => widget.item?.questionItem?.question?.required;

  @override
  EditFormCubit get editFormCubit => widget.editFormCubit;

  @override
  bool get wantKeepAlive => true;

  @override
  VoidCallback get onTapMenuButton => () async {
        BuildContext buildContext = context;
        final response = await showDialog(
            context: buildContext,
            builder: (context) {
              return _buildBottomModal();
            });
        if (response != null) {
          if (response[0] == ItemMenuOpConstant.showDesc) {
            showDescription = true;
          } else if (response[0] == ItemMenuOpConstant.hideDesc) {
            showDescription = false;
          }
          setState(() {});
        }
      };

  Widget _buildBottomModal() {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Show',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Gap(16),
            InkWell(
              onTap: onTapModalDescription,
              child: _buildModalRow(
                  'Description', showDescription, Icons.description),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModalRow(String label, bool shouldShowCheck, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Gap(8),
          Icon(
            icon,
            color: Colors.black45,
            size: 18,
          ),
          const Gap(4),
          Text(label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          const Expanded(child: SizedBox()),
          shouldShowCheck
              ? const Icon(Icons.check, size: 18, color: Colors.green)
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  void onTapModalDescription() {
    showDescription = showDescription ? true : false;
    Navigator.of(context).pop([
      showDescription
          ? ItemMenuOpConstant.hideDesc
          : ItemMenuOpConstant.showDesc
    ]);
  }

  @override
  Item? get widgetItem => widget.item;

  @override
  Set<String> get titleDescUpdateMask => updateMask;

  @override
  Request get titleDescRequest => request;

  @override
  VoidCallback? get onAnswerKeyPressed => () {};
}
