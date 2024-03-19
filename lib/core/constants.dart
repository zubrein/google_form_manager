import 'package:onepref/onepref.dart';

const defaultErrorMessage = 'Something went wrong';

final List<ProductId> androidProductIds = [
  ProductId(id: 'gfm_2.99_monthly', isConsumable: false),
  ProductId(id: 'gfm_1.99_weekly', isConsumable: false),
  ProductId(id: 'gfm_29.99_yearly', isConsumable: false),
];
final List<ProductId> iosProductIds = [
  ProductId(id: 'GFM_1.99_weekly', isConsumable: false),
  ProductId(id: 'GFM_2.99_Monthly', isConsumable: false),
  ProductId(id: 'GFM_29.99_Yearly', isConsumable: false),
];
