import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:query_wizard/domain.dart';

void main() {
  test('QueryAggregate initialized', () {
    final aggregate = QueryAggregate(
      id: const Uuid().v1(),
      field: '',
      function: QueryAggregateFunction.sum,
    );

    expect(aggregate.field, '');
    expect(aggregate.function, QueryAggregateFunction.sum);
    expect(
        aggregate.props,
        equals([
          aggregate.id,
          aggregate.field,
          aggregate.function,
        ]));
  });
}
