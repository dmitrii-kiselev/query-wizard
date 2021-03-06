import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_gen/gen_l10n/query_wizard_localizations.dart';
import 'package:query_wizard/application.dart';
import 'package:query_wizard/domain.dart';
import 'package:query_wizard/presentation.dart';
import 'package:uuid/uuid.dart';

class QueryGroupingsBar extends HookWidget {
  const QueryGroupingsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<QueryGroupingsBloc>(context);
    final tables = BlocProvider.of<QueryTablesBloc>(context).state.tables;
    final localizations = QueryWizardLocalizations.of(context);

    return BlocBuilder<QueryGroupingsBloc, QueryGroupingsState>(
      builder: (
        context,
        state,
      ) {
        if (state is QueryGroupingsChanged) {
          return Scaffold(
            body: ReorderableListView.builder(
              itemCount: state.groupings.length,
              itemBuilder: (context, index) {
                final grouping = state.groupings[index];

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
                              QueryGroupingDeleted(id: grouping.id),
                            );
                          },
                        ),
                      ],
                    ),
                    title: Text(
                      grouping.toString(),
                    ),
                  ),
                );
              },
              padding: const EdgeInsets.all(
                QueryWizardConstants.defaultEdgeInsetsAllValue,
              ),
              onReorder: (int oldIndex, int newIndex) {
                bloc.add(
                  QueryGroupingOrderChanged(
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
                            QueryGroupingAdded(
                              grouping: QueryGrouping(
                                id: const Uuid().v1(),
                                name: field.name,
                                type: QueryGroupingType.grouping,
                                elements: List.empty(growable: true),
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
      },
    );
  }
}
