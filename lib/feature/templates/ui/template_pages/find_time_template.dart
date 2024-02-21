import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../google_form/edit_form/domain/enums.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import '../constants.dart';
import '../cubit/create_form_cubit.dart';
import '../template_button.dart';

class FindTimeTemplate extends StatelessWidget {
  final CreateFormCubit createFormCubit;

  const FindTimeTemplate({super.key, required this.createFormCubit});

  @override
  Widget build(BuildContext context) {
    return TemplateButton(
      buttonName: 'Find a Time',
      buttonImage: findTimeImage,
      buttonOnClick: () async {
        createFormCubit.createTemplate('Find a Time', [],
            request: BatchUpdateFormRequest(requests: [
              Request(
                updateFormInfo: UpdateFormInfoRequest(
                    info: Info(
                        description:
                            '''We need to get together to talk about some things - when do you have time to meet?\nLet's meet at 123 Your Street Your City, ST 12345'''),
                    updateMask: 'description'),
              ),
              Request(
                createItem: CreateItemRequest(
                    item: Item(
                        title: 'What times are you available?',
                        description: 'Please select all that apply',
                        questionGroupItem: QuestionGroupItem(
                          grid: Grid(
                            columns: ChoiceQuestion(
                              options: [
                                Option(value: 'Morning'),
                                Option(value: 'Midday'),
                                Option(value: 'Afternoon'),
                                Option(value: 'Evening'),
                              ],
                              type: 'CHECKBOX',
                            ),
                          ),
                          questions: [
                            Question(
                                rowQuestion: RowQuestion(title: 'Monday'),
                                required: false),
                            Question(
                                rowQuestion: RowQuestion(title: 'Tuesday'),
                                required: false),
                            Question(
                                rowQuestion: RowQuestion(title: 'Wednesday'),
                                required: false),
                            Question(
                                rowQuestion: RowQuestion(title: 'Thursday'),
                                required: false),
                            Question(
                                rowQuestion: RowQuestion(title: 'Friday'),
                                required: false),
                          ],
                        )),
                    location: Location(index: 0)),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.paragraph,
                1,
                title: 'Items to discuss?',
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                    title: 'Allergies or dietary restrictions?',
                    description: '',
                    questionItem: QuestionItem(
                      question: Question(
                          choiceQuestion: ChoiceQuestion(
                            options: [
                              Option(value: 'Vegetarian'),
                              Option(value: 'Vegan'),
                              Option(value: 'Kosher'),
                              Option(value: 'Halal'),
                              Option(value: 'Gluten-free'),
                              Option(value: 'None'),
                              Option(isOther: true),
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
                title: 'Any other comments and/or questions?',
              ),
            ]));
      },
    );
  }
}
