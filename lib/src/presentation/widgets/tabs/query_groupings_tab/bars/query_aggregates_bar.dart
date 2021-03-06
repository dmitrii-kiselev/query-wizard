import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_gen/gen_l10n/query_wizard_localizations.dart';
import 'package:query_wizard/application.dart';
import 'package:query_wizard/domain.dart';
import 'package:query_wizard/presentation.dart';

class QueryAggregatesBar extends HookWidget {
  const QueryAggregatesBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<QueryAggregatesBloc>(context);
    final tables = BlocProvider.of<QueryTablesBloc>(context).state.tables;
    final localizations = QueryWizardLocalizations.of(context);

    return BlocBuilder<QueryAggregatesBloc, QueryAggregatesState>(builder: (
      context,
      state,
    ) {
      if (state is QueryAggregatesChanged) {
        return Scaffold(
          body: ReorderableListView.builder(
            itemCount: state.aggregates.length,
            itemBuilder: (context, index) {
              final aggregate = state.aggregates[index];

              return Card(
                key: ValueKey('$index'),
                child: ListTile(
                  leading: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.highlight_remove_outlined),
                        tooltip: localizations?.remove ?? 'Remove',
                        onPressed: () {
                          bloc.add(
                            QueryAggregateDeleted(id: aggregate.id),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      DialogRoute<String>(
                        context: context,
                        builder: (context) => _ChangeAggregateDialog(
                          id: aggregate.id,
                        ),
                      ),
                    );
                  },
                  title: Text(
                    aggregate.toString(),
                  ),
                ),
              );
            },
            padding: const EdgeInsets.all(
              QueryWizardConstants.defaultEdgeInsetsAllValue,
            ),
            onReorder: (int oldIndex, int newIndex) {
              bloc.add(
                QueryAggregateOrderChanged(
                  oldIndex: oldIndex,
                  newIndex: newIndex,
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => FieldsSelectionPage(
                    tables: tables,
                    onSelected: (fields) {
                      for (final field in fields) {
                        bloc.add(
                          QueryAggregateAdded(
                            aggregate: QueryAggregate(
                              id: const Uuid().v1(),
                              field: field.name,
                              function: QueryAggregateFunction.sum,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
            tooltip: localizations?.add ?? 'Add',
            child: const Icon(Icons.add),
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    });
  }
}

class _ChangeAggregateDialog extends HookWidget {
  const _ChangeAggregateDialog({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    final localizations = QueryWizardLocalizations.of(context);
    final function = useState<QueryAggregateFunction?>(
      QueryAggregateFunction.sum,
    );
    final bloc = BlocProvider.of<QueryAggregatesBloc>(context);
    final aggregate = bloc.state.aggregates.findById(id);

    return AlertDialog(
      title: Text(localizations?.changeTableName ?? 'Change aggregate field'),
      content: DropdownButtonFormField<QueryAggregateFunction>(
        value: function.value,
        items: QueryWizardConstants.aggregateFunctions
            .map<DropdownMenuItem<QueryAggregateFunction>>(
          (value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value.toString()),
            );
          },
        ).toList(),
        onChanged: (value) => function.value = value,
        decoration: InputDecoration(
          labelText: localizations?.function ?? 'Function',
          icon: const Icon(Icons.compare_arrows),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final newAggregate = QueryAggregate(
              id: aggregate.id,
              field: aggregate.field,
              function: function.value ?? QueryAggregateFunction.sum,
            );

            bloc.add(
              QueryAggregateUpdated(aggregate: newAggregate),
            );
            Navigator.pop(context);
          },
          child: Text(localizations?.save ?? 'Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(localizations?.cancel ?? 'Cancel'),
        ),
      ],
    );
  }
}
