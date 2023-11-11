import 'package:googleapis/forms/v1.dart';

class DeleteRequestItemHelper {
  static Request createDeleteRequest(int widgetIndex) {
    return Request(
      deleteItem: DeleteItemRequest(
          location: Location(
        index: widgetIndex,
      )),
    );
  }
}
