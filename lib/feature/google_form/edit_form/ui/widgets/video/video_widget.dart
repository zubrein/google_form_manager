import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:gap/gap.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../domain/constants.dart';
import '../../bottom_modal_operation_constant.dart';
import '../../cubit/form_cubit.dart';
import '../helper/request_builder_helper_mixin.dart';
import '../helper/title_desciption_adder_mixin.dart';

class VideoWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final FormCubit formCubit;

  const VideoWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.formCubit,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget>
    with
        RequestBuilderHelper,
        TitleDescriptionAdderMixin,
        AutomaticKeepAliveClientMixin {
  @override
  void init() {
    showDescription = widget.item?.videoItem?.caption != null;
    _prepareRequest();
  }

  @override
  Widget build(BuildContext context) {
    questionController.text = widget.item?.title ?? '';
    descriptionController.text = widget.item?.videoItem?.caption ?? '';
    super.build(context);
    return baseWidget();
  }

  @override
  Widget body() {
    return Column(
      children: [
        buildEditTitleWidget(),
        const Gap(4),
        showDescription
            ? buildEditDescriptionWidget(
                description: 'Caption', isCaption: true)
            : const SizedBox.shrink(),
        const Gap(16),
        SizedBox(
          height: 150,
          child: mat.Image.network(
            _getThumbnailUrl(widget.item?.videoItem?.video?.youtubeUri ?? ''),
          ),
        )
      ],
    );
  }

  void _prepareRequest() {
    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.videoItem?.video?.youtubeUri =
          widget.item?.videoItem?.video?.youtubeUri;
      updateMask.add(Constants.video);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest();
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.videoItem?.video?.youtubeUri =
          widget.item?.videoItem?.video?.youtubeUri;
      addRequest();
    }
  }

  @override
  int get widgetIndex => widget.index;

  @override
  QuestionType get questionType => QuestionType.video;

  @override
  OperationType get operationType => widget.operationType;

  @override
  bool? get isRequired => widget.item?.questionItem?.question?.required;

  @override
  FormCubit get formCubit => widget.formCubit;

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
              child:
                  _buildModalRow('Caption', showDescription, Icons.description),
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

  String _getThumbnailUrl(String url) {
    Log.info(url);
    final videoId = YoutubePlayer.convertUrlToId('https://$url');
    Log.info(videoId.toString());
    return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
  }
}
