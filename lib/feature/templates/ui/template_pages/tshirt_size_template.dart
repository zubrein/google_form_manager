import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../google_form/edit_form/domain/enums.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import '../constants.dart';
import '../cubit/create_form_cubit.dart';
import '../template_button.dart';

class TShirtSizeTemplate extends StatelessWidget {
  final CreateFormCubit createFormCubit;

  const TShirtSizeTemplate({super.key, required this.createFormCubit});

  @override
  Widget build(BuildContext context) {
    return TemplateButton(
      buttonName: 'T-Shirt Sign Up',
      buttonImage: tShirtSizeImage,
      buttonOnClick: () async {
        createFormCubit.createTemplate('T-Shirt Sign Up', [],
            request: BatchUpdateFormRequest(requests: [
              Request(
                updateFormInfo: UpdateFormInfoRequest(
                    info: Info(
                        description:
                            'Enter your name and size to sign up for a T-Shirt.'),
                    updateMask: 'description'),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                0,
                title: 'Name',
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'Shirt size',
                    description: '',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'XS'),
                              Option(value: 'S'),
                              Option(value: 'M'),
                              Option(value: 'L'),
                              Option(value: 'XL'),
                              Option(isOther: true),
                            ],
                            shuffle: false,
                            type: CreateQuestionItemHelper.getTypeName(
                                QuestionType.multipleChoice),
                          ),
                          required: false),
                    ),
                  ),
                  location: Location(index: 1),
                ),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                2,
                title: 'Other thoughts or comments',
              ),
            ]));
      },
    );
  }
}
