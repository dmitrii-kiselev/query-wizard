part of 'query_orders_bloc.dart';

abstract class QueryOrdersEvent extends Equatable {
  const QueryOrdersEvent();
}

class QueryOrdersInitialized extends QueryOrdersEvent {
  const QueryOrdersInitialized({required this.orders});

  final List<QueryOrder> orders;

  @override
  List<Object?> get props => [orders];
}

class QueryOrderAdded extends QueryOrdersEvent {
  const QueryOrderAdded({required this.order});

  final QueryOrder order;

  @override
  List<Object?> get props => [order];
}

class QueryOrderUpdated extends QueryOrdersEvent {
  const QueryOrderUpdated({
    required this.index,
    required this.order,
  });

  final int index;
  final QueryOrder order;

  @override
  List<Object?> get props => [order];
}

class QueryOrderDeleted extends QueryOrdersEvent {
  const QueryOrderDeleted({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

class QueryOrderOrderChanged extends QueryOrdersEvent {
  const QueryOrderOrderChanged({
    required this.oldIndex,
    required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
