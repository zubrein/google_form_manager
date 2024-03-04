import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../google_form/edit_form/domain/enums.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import '../constants.dart';
import '../cubit/create_form_cubit.dart';
import '../template_button.dart';

class OrderRequestTemplate extends StatelessWidget {
  final CreateFormCubit createFormCubit;

  const OrderRequestTemplate({super.key, required this.createFormCubit});

  @override
  Widget build(BuildContext context) {
    return TemplateButton(
      buttonName: 'Order Request',
      buttonImage: orderFormImage,
      buttonOnClick: () async {
        createFormCubit.createTemplate('Order Request', [],
            request: BatchUpdateFormRequest(requests: [
              Request(
                updateFormInfo: UpdateFormInfoRequest(
                    info: Info(
                        description:
                            'After you fill out this order request, we will contact you to go over details and availability before the order is completed. If you would like faster service and direct information on current stock and pricing please contact us at Contact us at (123) 456-7890 or no_reply@example.com'),
                    updateMask: 'description'),
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'Are you a new or existing customer?',
                    description: '',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'I am a new customer'),
                              Option(value: 'I am an existing customer'),
                            ],
                            shuffle: false,
                            type: CreateQuestionItemHelper.getTypeName(
                                QuestionType.multipleChoice),
                          ),
                          required: false),
                    ),
                  ),
                  location: Location(index: 0),
                ),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                1,
                title: 'What is the item you would like to order?',
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'What color(s) would you like to order?',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'color 1'),
                              Option(value: 'color 2'),
                              Option(value: 'color 3'),
                              Option(value: 'color 4'),
                            ],
                            shuffle: false,
                            type: CreateQuestionItemHelper.getTypeName(
                                QuestionType.checkboxes),
                          ),
                          required: false),
                    ),
                  ),
                  location: Location(index: 2),
                ),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.paragraph,
                3,
                title: 'Choose size and number per color',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                4,
                title: 'Contact info',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                5,
                title: 'Your name',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                6,
                title: 'Phone number',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                7,
                title: 'E-mail',
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'Preferred contact method',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'Phone'),
                              Option(value: 'Email'),
                            ],
                            shuffle: false,
                            type: CreateQuestionItemHelper.getTypeName(
                                QuestionType.checkboxes),
                          ),
                          required: false),
                    ),
                  ),
                  location: Location(index: 8),
                ),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.paragraph,
                9,
                title: 'Questions and comments',
              ),
            ]));
      },
    );
  }
}
