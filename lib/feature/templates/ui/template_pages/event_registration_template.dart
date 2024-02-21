import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../google_form/edit_form/domain/enums.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import '../constants.dart';
import '../cubit/create_form_cubit.dart';
import '../template_button.dart';

class EventRegistrationTemplate extends StatelessWidget {
  final CreateFormCubit createFormCubit;

  const EventRegistrationTemplate({super.key, required this.createFormCubit});

  @override
  Widget build(BuildContext context) {
    return TemplateButton(
      buttonName: 'Event registration',
      buttonImage: eventRegistrationImage,
      buttonOnClick: () async {
        createFormCubit.createTemplate('Event registration', [],
            request: BatchUpdateFormRequest(requests: [
              Request(
                updateFormInfo: UpdateFormInfoRequest(
                    info: Info(
                        description:
                        'Event Timing: January 4th-6th, 2016\nEvent Address: 123 Your Street Your City, ST 12345\nContact us at (123) 456-7890 or no_reply@example.com'),
                    updateMask: 'description'),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                0,
                title: 'Name',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                1,
                title: 'Email',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                2,
                title: 'Organization',
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'What days will you attend?',
                    description: '',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'Day 1'),
                              Option(value: 'Day 2'),
                              Option(value: 'Day 3'),
                            ],
                            shuffle: false,
                            type: CreateQuestionItemHelper.getTypeName(
                                QuestionType.checkboxes),
                          ),
                          required: false),
                    ),
                  ),
                  location: Location(index: 3),
                ),
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'Dietary restrictions',
                    description: '',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'None'),
                              Option(value: 'Vegetarian'),
                              Option(value: 'Vegan'),
                              Option(value: 'Kosher'),
                              Option(value: 'Gluten-free'),
                              Option(isOther: true),
                            ],
                            shuffle: false,
                            type: CreateQuestionItemHelper.getTypeName(
                                QuestionType.multipleChoice),
                          ),
                          required: false),
                    ),
                  ),
                  location: Location(index: 4),
                ),
              ), Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'I understand that I will have to pay upon arrival',
                    description: '',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'Yes'),
                            ],
                            shuffle: false,
                            type: CreateQuestionItemHelper.getTypeName(
                                QuestionType.checkboxes),
                          ),
                          required: false),
                    ),
                  ),
                  location: Location(index: 5),
                ),
              ),
            ]));
      },
    );
  }
}
