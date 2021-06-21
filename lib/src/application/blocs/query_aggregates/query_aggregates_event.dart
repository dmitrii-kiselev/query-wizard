import 'package:equatable/equatable.dart';

import 'package:query_wizard/domain.dart';

abstract class QueryAggregatesEvent extends Equatable {
  const QueryAggregatesEvent();
}

class QueryAggregatesInitialized extends QueryAggregatesEvent {
  const QueryAggregatesInitialized({required this.aggregates});

  final List<QueryAggregate> aggregates;

  @override
  List<Object?> get props => [aggregates];
}

class QueryAggregateAdded extends QueryAggregatesEvent {
  const QueryAggregateAdded({required this.aggregate});

  final QueryAggregate aggregate;

  @override
  List<Object?> get props => [aggregate];
}

class QueryAggregateUpdated extends QueryAggregatesEvent {
  const QueryAggregateUpdated({
    required this.index,
    required this.aggregate,
  });

  final int index;
  final QueryAggregate aggregate;

  @override
  List<Object?> get props => [aggregate];
}

class QueryAggregateDeleted extends QueryAggregatesEvent {
  const QueryAggregateDeleted({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

class QueryAggregateOrderChanged extends QueryAggregatesEvent {
  const QueryAggregateOrderChanged(
      {required this.oldIndex, required this.newIndex});

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
