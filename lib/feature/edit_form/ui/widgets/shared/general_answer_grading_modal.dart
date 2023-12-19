import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/shared/point_and_feedback_mixin.dart';
import 'package:googleapis/forms/v1.dart';

class GeneralAnswerGradingModal extends StatefulWidget {
  final Request request;
  final OperationType opType;
  final VoidCallback addRequest;
  final Set<String> updateMask;
  final Grading widgetGrading;

  const GeneralAnswerGradingModal({
    super.key,
    required this.request,
    required this.opType,
    required this.addRequest,
    required this.updateMask,
    required this.widgetGrading,
  });

  @override
  State<GeneralAnswerGradingModal> createState() => _GeneralAnswerGradingModalState();
}

class _GeneralAnswerGradingModalState extends State<GeneralAnswerGradingModal>
    with PointAndFeedbackMixin {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _feedbackController.text = widget.widgetGrading.generalFeedback?.text ?? '';
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPointWidget(),
            const Gap(32),
            buildFeedbackWidget(),
            const Gap(16),
            _buildDoneButton()
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueAccent, width: 1.5)),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Grading get grading => widget.widgetGrading;

  @override
  VoidCallback get addRequest => widget.addRequest;

  @override
  OperationType get opType => widget.opType;

  @override
  Request get request => widget.request;

  @override
  Set<String> get updateMask => widget.updateMask;

  @override
  TextEditingController get feedbackController => _feedbackController;

  @override
  TextEditingController get correctAnswerController => TextEditingController();

  @override
  TextEditingController get wrongAnswerController => TextEditingController();
}
