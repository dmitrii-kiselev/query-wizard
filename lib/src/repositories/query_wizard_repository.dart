import 'dart:async';

import 'package:query_wizard/models.dart';
import 'package:query_wizard/repositories.dart';

class QueryWizardRepository {
  final QueryWizardClient queryWizardClient;

  QueryWizardRepository({required this.queryWizardClient});

  Future<List<DbElement>> getSources() async {
    return await queryWizardClient.getSources();
  }

  Future<QuerySchema> parseQuery(String query) async {
    return await queryWizardClient.parseQuery(query);
  }
}
