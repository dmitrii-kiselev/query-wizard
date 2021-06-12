import 'package:flutter_test/flutter_test.dart';

import 'package:query_wizard/domain.dart';

void main() {
  test('QueryAggregate initialized', () {
    final aggregate = QueryAggregate(field: '', function: '');

    expect(aggregate.field, '');
    expect(aggregate.function, '');
    expect(aggregate.props, equals([aggregate.field, aggregate.function]));
  });
}
