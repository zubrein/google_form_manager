import 'package:flutter/material.dart';

enum QuestionType {
  shortAnswer,
  paragraph,
  multipleChoice,
  checkboxes,
  dropdown,
  linearScale,
  date,
  time,
  multipleChoiceGrid,
  checkboxGrid,
  image,
  text,
  unknown,
}

Map<QuestionType, String> questionTypeNameMap = {
  QuestionType.shortAnswer: 'Short Answer',
  QuestionType.paragraph: 'Paragraph',
  QuestionType.multipleChoice: 'Multiple Choice',
  QuestionType.checkboxes: 'Checkboxes',
  QuestionType.dropdown: 'Dropdown',
  QuestionType.linearScale: 'Linear Scale',
  QuestionType.date: 'Date',
  QuestionType.time: 'Time',
  QuestionType.multipleChoiceGrid: 'Multiple choice grid',
  QuestionType.checkboxGrid: 'Checkbox grid',
  QuestionType.image: 'Image',
  QuestionType.text: 'text',
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
};

enum OperationType { create, delete, update }
