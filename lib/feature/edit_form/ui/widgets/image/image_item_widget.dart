import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mt;
import 'package:gap/gap.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import '../helper/title_desciption_adder_mixin.dart';
import 'package:googleapis/forms/v1.dart';

import '../../bottom_modal_operation_constant.dart';
import '../../utils/image_picker_helper.dart';
import '../helper/request_builder_helper_mixin.dart';

class ImageItemWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final EditFormCubit editFormCubit;

  const ImageItemWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.editFormCubit,
  });

  @override
  State<ImageItemWidget> createState() => _ImageItemWidgetState();
}

class _ImageItemWidgetState extends State<ImageItemWidget>
    with
        RequestBuilderHelper,
        TitleDescriptionAdderMixin,
        AutomaticKeepAliveClientMixin {
  @override
  void init() {}

  @override
  Widget build(BuildContext context) {
    questionController.text = widget.item?.title ?? '';
    super.build(context);
    return baseWidget();
  }

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          buildEditTitleWidget(),
          const Gap(8),
          _getImage(),
        ],
      ),
    );
  }

  Widget _getImage() {
    String sourceUri = widget.item?.imageItem?.image?.sourceUri??'';
    String contentUri = widget.item?.imageItem?.image?.contentUri??'';
    if (sourceUri.isNotEmpty) {
      return mt.Image.network(
        widget.item?.imageItem?.image?.sourceUri.toString() ?? '',
        height: 150,
        width: double.infinity,
      );
    } else if (contentUri.isNotEmpty) {
      return mt.Image.network(
        widget.item?.imageItem?.image?.contentUri.toString() ?? '',
        height: 150,
        width: double.infinity,
      );
    } else {
      return const SizedBox(height: 150, child: Icon(Icons.image));
    }
  }

  @override
  int get widgetIndex => widget.index;

  @override
  QuestionType get questionType => QuestionType.image;

  @override
  OperationType get operationType => widget.operationType;

  @override
  bool? get isRequired => null;

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
            ),
            const Gap(16),
            const Divider(
              color: Colors.black87,
            ),
            InkWell(
              onTap: onTapModalImageChange,
              child: _buildModalRow('Change image', false, Icons.image),
            ),
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

  void onTapModalImageChange() async {
    Navigator.of(context).pop();
    widget.item!.imageItem!.image!.sourceUri =
        await ImagePickerHelper.pickImage();
    if (widget.item!.imageItem!.image!.sourceUri != null) {
      Log.info(operationType.name);
      if (operationType == OperationType.update) {
        Log.info(widget.item!.imageItem!.image!.sourceUri.toString());
        request.updateItem?.item?.imageItem?.image?.sourceUri =
            widget.item!.imageItem!.image!.sourceUri;
        updateMask.add(Constants.image);
        request.updateItem?.updateMask = updateMaskBuilder(updateMask);
        addRequest();
      } else if (operationType == OperationType.create) {
        Log.info(widget.item!.imageItem!.image!.sourceUri.toString());
        request.createItem?.item?.imageItem?.image?.sourceUri =
            widget.item!.imageItem!.image!.sourceUri;
        addRequest();
      }
      setState(() {});
    }
    setState(() {});
  }

  @override
  Item? get widgetItem => widget.item;

  @override
  Set<String> get titleDescUpdateMask => updateMask;

  @override
  Request get titleDescRequest => request;
}
