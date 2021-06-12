import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:query_wizard/application.dart';
import 'package:query_wizard/infrastructure.dart';

var log = [];

main() {
  setUp(() {
    log = [];
  });

  test('onEvent', overridePrint(() {
    final observer = QueryWizardBlocObserver();
    final event = 'event';
    final client = DesignTimeQueryWizardClient();
    final repository = QueryWizardRepository(queryWizardClient: client);
    final bloc = buildQueryWizardBloc(repository);

    observer.onEvent(bloc, event);

    expect(log, ['onEvent $event']);
  }));

  test('onTransition', overridePrint(() {
    final observer = QueryWizardBlocObserver();
    final client = DesignTimeQueryWizardClient();
    final repository = QueryWizardRepository(queryWizardClient: client);
    final bloc = buildQueryWizardBloc(repository);
    final state = '';
    final event = 'event';
    final transition = Transition<String, String>(
        currentState: state, event: event, nextState: state);

    observer.onTransition(bloc, transition);

    expect(log, ['onTransition $transition']);
  }));

  test('onError', overridePrint(() {
    final observer = QueryWizardBlocObserver();
    final error = 'error';
    final client = DesignTimeQueryWizardClient();
    final repository = QueryWizardRepository(queryWizardClient: client);
    final bloc = buildQueryWizardBloc(repository);

    observer.onError(bloc, error, StackTrace.empty);

    expect(log, ['onError $error']);
  }));
}

QueryWizardBloc buildQueryWizardBloc(
    QueryWizardRepository queryWizardRepository) {
  final sourcesBloc =
      QuerySourcesBloc(queryWizardRepository: queryWizardRepository);

  final tablesBloc = QueryTablesBloc();
  final fieldsBloc = QueryFieldsBloc();

  final joinsBloc = QueryJoinsBloc();
  final aggregatesBloc = QueryAggregatesBloc();
  final groupingsBloc = QueryGroupingsBloc();
  final conditionsBloc = QueryConditionsBloc();
  final queriesBloc = QueriesBloc();
  final ordersBloc = QueryOrdersBloc();
  final batchesBloc = QueryBatchesBloc();
  final queryWizardBloc = QueryWizardBloc(
      sourcesBloc: sourcesBloc,
      tablesBloc: tablesBloc,
      fieldsBloc: fieldsBloc,
      joinsBloc: joinsBloc,
      aggregatesBloc: aggregatesBloc,
      groupingsBloc: groupingsBloc,
      conditionsBloc: conditionsBloc,
      queriesBloc: queriesBloc,
      ordersBloc: ordersBloc,
      batchesBloc: batchesBloc,
      queryWizardRepository: queryWizardRepository);

  return queryWizardBloc;
}

void Function() overridePrint(void testFn()) => () {
      var spec = new ZoneSpecification(print: (_, __, ___, String msg) {
        log.add(msg);
      });

      return Zone.current.fork(specification: spec).run<void>(testFn);
    };
