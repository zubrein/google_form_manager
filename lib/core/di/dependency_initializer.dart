import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependency_initializer.config.dart';

final sl = GetIt.instance;

@InjectableInit()
void configureDependencies() => sl.init();