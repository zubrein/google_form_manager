import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../google_form/edit_form/domain/enums.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import '../constants.dart';
import '../cubit/create_form_cubit.dart';
import '../template_button.dart';

class EventRsvpTemplate extends StatelessWidget {
  final CreateFormCubit createFormCubit;

  const EventRsvpTemplate({super.key, required this.createFormCubit});

  @override
  Widget build(BuildContext context) {
    return TemplateButton(
      buttonName: 'RSVP',
      buttonImage: rsvpImage,
      buttonOnClick: () async {
        createFormCubit.createTemplate('Event RSVP', [],
            request: BatchUpdateFormRequest(requests: [
              Request(
                updateFormInfo: UpdateFormInfoRequest(
                    info: Info(
                        description:
                            'Event Address: 123 Your Street Your City, ST 12345\nContact us at (123) 456-7890 or no_reply@example.com'),
                    updateMask: 'description'),
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'Can you attend?',
                    description: '',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'Yes,  I will be there'),
                              Option(value: 'Sorry, cant make it'),
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
                QuestionType.paragraph,
                1,
                title: 'What are the names of people attending?',
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'How did you hear about this event?',
                    description: '',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'Website'),
                              Option(value: 'Friend'),
                              Option(value: 'Newsletter'),
                              Option(value: 'Advertisement'),
                            ],
                            shuffle: false,
                            type: CreateQuestionItemHelper.getTypeName(
                                QuestionType.multipleChoice),
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
                title: 'Comments and/or questions',
              ),
            ]));
      },
    );
  }
}
