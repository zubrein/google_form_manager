import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../google_form/edit_form/domain/enums.dart';
import '../../../google_form/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import '../constants.dart';
import '../cubit/create_form_cubit.dart';
import '../template_button.dart';

class EventFeedbackTemplate extends StatelessWidget {
  final CreateFormCubit createFormCubit;

  const EventFeedbackTemplate({super.key, required this.createFormCubit});

  @override
  Widget build(BuildContext context) {
    return TemplateButton(
      buttonName: 'Event feedback',
      buttonImage: eventFeedBackImage,
      buttonOnClick: () async {
        createFormCubit.createTemplate('Event feedback', [],
            request: BatchUpdateFormRequest(requests: [
              Request(
                updateFormInfo: UpdateFormInfoRequest(
                    info: Info(
                        description:
                            '''Thank you for participating in our event. We hope you had as much fun attending as we did organizing it.\n\nWe want to hear your feedback so we can keep improving our logistics and content. Please fill this quick survey and let us know your thoughts (your answers will be anonymous).'''),
                    updateMask: 'description'),
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                      title: 'How satisfied were you with the event?',
                      questionItem: QuestionItem(
                          question: Question(
                              scaleQuestion: ScaleQuestion(
                        high: 5,
                        low: 1,
                        highLabel: 'very much',
                        lowLabel: 'Not very',
                      )))),
                  location: Location(index: 0),
                ),
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                      title:
                          'How relevant and helpful do you think it was for your job?',
                      questionItem: QuestionItem(
                          question: Question(
                              scaleQuestion: ScaleQuestion(
                        high: 5,
                        low: 1,
                        highLabel: 'very much',
                        lowLabel: 'Not very',
                      )))),
                  location: Location(index: 1),
                ),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                2,
                title: 'What were your key take aways from this event?',
              ),
              Request(
                createItem: CreateItemRequest(
                    item: Item(
                        title: 'How satisfied were you with the logistics?',
                        description:
                            '1 = Very dissatisfied   5 = Very satisfied',
                        questionGroupItem: QuestionGroupItem(
                          grid: Grid(
                            columns: ChoiceQuestion(
                              options: [
                                Option(value: '1'),
                                Option(value: '2'),
                                Option(value: '3'),
                                Option(value: '4'),
                                Option(value: '5'),
                                Option(value: 'N/A'),
                              ],
                              type: 'RADIO',
                            ),
                          ),
                          questions: [
                            Question(
                                rowQuestion:
                                    RowQuestion(title: 'Accommodation'),
                                required: false),
                            Question(
                                rowQuestion: RowQuestion(title: 'Welcome kit'),
                                required: false),
                            Question(
                                rowQuestion:
                                    RowQuestion(title: 'Communication emails'),
                                required: false),
                            Question(
                                rowQuestion:
                                    RowQuestion(title: 'Transportation'),
                                required: false),
                            Question(
                                rowQuestion:
                                    RowQuestion(title: 'Welcome activity'),
                                required: false),
                            Question(
                                rowQuestion: RowQuestion(title: 'Venue'),
                                required: false),
                            Question(
                                rowQuestion: RowQuestion(title: 'Activities'),
                                required: false),
                            Question(
                                rowQuestion:
                                    RowQuestion(title: 'Closing ceremony'),
                                required: false),
                          ],
                        )),
                    location: Location(index: 3)),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                4,
                title: 'Additional feedback on logistics',
              ),
              Request(
                createItem: CreateItemRequest(
                  item: Item(
                      title: 'How satisfied were you with the session content?',
                      description: 'Both presented and pre-read material',
                      questionItem: QuestionItem(
                          question: Question(
                              scaleQuestion: ScaleQuestion(
                        high: 5,
                        low: 1,
                        highLabel: 'Excellent',
                        lowLabel: 'Poor',
                      )))),
                  location: Location(index: 5),
                ),
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                6,
                title:
                    'Any additional comments regarding the sessions or overall agenda?',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                7,
                title: 'Any overall feedback for the event?',
              ),
              CreateRequestItemHelper.prepareCreateRequest(
                QuestionType.shortAnswer,
                8,
                title: 'Name (optional)',
              ),
            ]));
      },
    );
  }
}
