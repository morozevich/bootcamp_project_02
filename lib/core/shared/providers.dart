import 'package:bootcamp_project_02/core/infraestructure/sembast_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sembastProvider = Provider(
  (ref) => SembastDatabase(),
);
