import 'package:onepref/onepref.dart';

const defaultErrorMessage = 'Something went wrong';

final List<ProductId> androidWeeklyProductIds = [
  ProductId(id: 'gfm_1.99_weekly', isConsumable: false),
];
final List<ProductId> androidMonthlyProductIds = [
  ProductId(id: 'gfm_2.99_monthly', isConsumable: false),
];
final List<ProductId> androidYearlyProductIds = [
  ProductId(id: 'gfm_29.99_yearly', isConsumable: false),
];

final List<ProductId> iosWeeklyProductIds = [
  ProductId(id: 'GFM_1.99_weekly', isConsumable: false),
];
final List<ProductId> iosMonthlyProductIds = [
  ProductId(id: 'GFM_2.99_Monthly', isConsumable: false),
];
final List<ProductId> iosYearlyProductIds = [
  ProductId(id: 'GFM_29.99_Yearly', isConsumable: false),
];

const String playStoreUrl = 'http://play.google.com/store/apps/details?id=';
const String packageName = 'com.gfm.gformmanager';