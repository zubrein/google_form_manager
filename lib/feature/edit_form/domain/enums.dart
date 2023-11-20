import 'package:flutter/material.dart';

enum QuestionType {
  shortAnswer,
  paragraph,
  multipleChoice,
  checkboxes,
  dropdown,
  linearScale,
  multipleChoiceGrid,
  checkboxGrid,
  date,
  time,
  image,
  text,
  pageBreak,
  unknown,
}

Map<QuestionType, String> questionTypeNameMap = {
  QuestionType.shortAnswer: 'Short Answer',
  QuestionType.paragraph: 'Paragraph',
  QuestionType.multipleChoice: 'Multiple Choice',
  QuestionType.checkboxes: 'Checkboxes',
  QuestionType.dropdown: 'Dropdown',
  QuestionType.linearScale: 'Linear Scale',
  QuestionType.multipleChoiceGrid: 'Multiple-choice grid',
  QuestionType.checkboxGrid: 'Tick box grid',
  QuestionType.date: 'Date',
  QuestionType.time: 'Time',
  QuestionType.image: 'Image',
  QuestionType.text: 'text',
  QuestionType.pageBreak: 'Page Break',
};

Map<QuestionType, IconData> questionTypeIconMap = {
  QuestionType.shortAnswer: Icons.short_text_rounded,
  QuestionType.paragraph: Icons.format_line_spacing_rounded,
  QuestionType.multipleChoice: Icons.radio_button_checked_rounded,
  QuestionType.checkboxes: Icons.check_box,
  QuestionType.dropdown: Icons.arrow_drop_down_circle,
  QuestionType.linearScale: Icons.linear_scale,
  QuestionType.date: Icons.calendar_month,
  QuestionType.time: Icons.watch_later_outlined,
  QuestionType.multipleChoiceGrid: Icons.grid_view_rounded,
  QuestionType.checkboxGrid: Icons.grid_view_outlined,
  QuestionType.image: Icons.image,
  QuestionType.text: Icons.text_fields_outlined,
  QuestionType.pageBreak: Icons.insert_page_break,
};

enum OperationType { create, delete, update }
