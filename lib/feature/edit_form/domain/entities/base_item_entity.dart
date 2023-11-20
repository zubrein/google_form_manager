import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

class BaseItemEntity {
  final String? itemId;
  final Item? item;
  final OperationType opType;
  Request? request;
  final Key key;

  BaseItemEntity({
    this.itemId,
    required this.item,
    required this.opType,
    required this.request,
    required this.key,
  });
}
