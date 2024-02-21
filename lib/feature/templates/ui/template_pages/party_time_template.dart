import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../google_form/edit_form/domain/enums.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import '../constants.dart';
import '../cubit/create_form_cubit.dart';
import '../template_button.dart';

class PartyInviteTemplate extends StatelessWidget {
  final CreateFormCubit createFormCubit;

  const PartyInviteTemplate({super.key, required this.createFormCubit});

  @override
  Widget build(BuildContext context) {
    return TemplateButton(
      buttonName: 'Party Invite',
      buttonImage: partyInviteImage,
      buttonOnClick: () async {
        createFormCubit.createTemplate('Party Invite', [],
            request: BatchUpdateFormRequest(requests: [
              Request(
                updateFormInfo: UpdateFormInfoRequest(
                    info: Info(
                        description:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur quis sem odio. Sed commodo vestibulum leo, sit amet tempus odio consectetur in.'),
                    updateMask: 'description'),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                0,
                title: 'What is your name?',
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
                  location: Location(index: 1),
                ),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                2,
                title: 'How many of you are attending?',
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'What will you be bringing?',
                    description: 'Let us know what kind of dish(es) you will be bringing',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'Mains'),
                              Option(value: 'Salad'),
                              Option(value: 'Dessert'),
                              Option(value: 'Drinks'),
                              Option(value: 'Sides/Appetizers'),
                              Option(isOther: true),
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
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                4,
                title: 'Do you have any allergies or dietary restrictions?',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                5,
                title: 'What is your email address?',
              ),
            ]));
      },
    );
  }
}
