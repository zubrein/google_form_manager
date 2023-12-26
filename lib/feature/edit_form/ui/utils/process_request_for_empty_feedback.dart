import 'package:googleapis/forms/v1.dart';

void processGradingFeedbackRequest(Request request) {
  processCreateGradingRequest(request);
  processUpdateGradingRequest(request);
}

void processUpdateGradingRequest(Request request) {
  final generalFeedback = request.updateItem?.item?.questionItem?.question
          ?.grading?.generalFeedback?.text ??
      '';
  if (generalFeedback.isEmpty) {
    request.updateItem?.item?.questionItem?.question?.grading?.generalFeedback
        ?.text = ' ';
  }
  final whenRight = request
          .updateItem?.item?.questionItem?.question?.grading?.whenRight?.text ??
      '';
  if (whenRight.isEmpty) {
    request.updateItem?.item?.questionItem?.question?.grading?.whenRight?.text =
        ' ';
  }

  final whenWrong = request
          .updateItem?.item?.questionItem?.question?.grading?.whenWrong?.text ??
      '';
  if (whenWrong.isEmpty) {
    request.updateItem?.item?.questionItem?.question?.grading?.whenWrong?.text =
        ' ';
  }
}

void processCreateGradingRequest(Request request) {
  final generalFeedback = request.createItem?.item?.questionItem?.question
          ?.grading?.generalFeedback?.text ??
      '';
  if (generalFeedback.isEmpty) {
    request.createItem?.item?.questionItem?.question?.grading?.generalFeedback
        ?.text = ' ';
  }
  final whenRight = request
          .createItem?.item?.questionItem?.question?.grading?.whenRight?.text ??
      '';
  if (whenRight.isEmpty) {
    request.createItem?.item?.questionItem?.question?.grading?.whenRight?.text =
        ' ';
  }

  final whenWrong = request
          .createItem?.item?.questionItem?.question?.grading?.whenWrong?.text ??
      '';
  if (whenWrong.isEmpty) {
    request.createItem?.item?.questionItem?.question?.grading?.whenWrong?.text =
        ' ';
  }
}
