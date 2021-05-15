import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_gen/gen_l10n/query_wizard_localizations.dart';
import 'package:query_wizard/blocs.dart';
import 'package:query_wizard/widgets.dart';

class QueryTablesAndFieldsTab extends HookWidget {
  QueryTablesAndFieldsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentIndex = useState(0);

    final localizations = QueryWizardLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.source_rounded),
        label: localizations?.database ?? 'Database',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.table_rows_rounded),
        label: localizations?.tables ?? 'Tables',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.horizontal_rule_rounded),
        label: localizations?.fields ?? 'Fields',
      ),
    ];

    return Scaffold(
      body: BlocBuilder<QueryTablesAndFieldsTabBloc,
          QueryTablesAndFieldsTabState>(builder: (context, state) {
        if (state is QueryTablesAndFieldsTabChanged) {
          final tabs = [
            QuerySources(sources: state.sources),
            QueryTables(tables: state.tables),
            QueryFields(fields: state.fields)
          ];

          return Center(
            child: PageTransitionSwitcher(
              child: tabs[_currentIndex.value],
              transitionBuilder: (child, animation, secondaryAnimation) {
                return FadeThroughTransition(
                  child: child,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                );
              },
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      }),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        items: bottomNavigationBarItems,
        currentIndex: _currentIndex.value,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: textTheme.caption!.fontSize!,
        unselectedFontSize: textTheme.caption!.fontSize!,
        onTap: (index) {
          _currentIndex.value = index;
        },
        selectedItemColor: colorScheme.onPrimary,
        unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}