import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:new_flutter_temp_project/shared/widgets/advance_grid_delegate.dart';
import 'package:new_flutter_temp_project/shared/widgets/card_item.dart';
import 'package:new_flutter_temp_project/shared/widgets/drawer_sheet.dart';
import 'package:new_flutter_temp_project/shared/widgets/navigation_bottom_bar.dart';
import 'package:new_flutter_temp_project/shared/widgets/navigation_side_bar.dart';

const kAlwaysDisplayDrawer = BreakpointValue(xs: false, md: true);

class ResponsiveApp extends StatefulWidget {
  const ResponsiveApp({required this.title, super.key});

  final String title;

  @override
  State<ResponsiveApp> createState() => _ResponsiveAppState();
}

class _ResponsiveAppState extends State<ResponsiveApp> {
  int index = 0;

  void _incrementCounter() {
    setState(() {
      index++;
    });
  }

  void onIndexSelect(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alwaysDisplayDrawer = context.layout.breakpoint > LayoutBreakpoint.sm;
    final isSM = context.layout.breakpoint < LayoutBreakpoint.md;
    final appBar = AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(widget.title, style: TextStyle(color: Colors.black)),
    );
    final Widget? endDrawer = alwaysDisplayDrawer
        ? null
        : DrawerSheet(key: ValueKey('Drawer'));

    final body = Row(
      children: [
        if (!isSM) ...[
          NavigationSideBar(selectedIndex: index, onIndexSelect: onIndexSelect),
          VerticalDivider(),
        ],
        Expanded(key: ValueKey('HomePageBody'), child: _HomeBody()),
        if (alwaysDisplayDrawer) DrawerSheet(key: ValueKey('Drawer')),
      ],
    );

    final bottomNavigationBar = isSM
        ? NavigationBottomBar(
            selectedIndex: index,
            onIndexSelect: onIndexSelect,
          )
        : null;
    return Scaffold(
      appBar: appBar,
      body: body,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: FloatingActionButton(
        onPressed: index < 2 ? _incrementCounter : null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double spacing = BreakpointValue(xs: 0.0, sm: 10.0).resolve(context);
    return Scrollbar(
      controller: _scrollController,
      child: CustomScrollView(
        controller: _scrollController,
        semanticChildCount: 100,
        slivers: [
          SliverGutter(),
          SliverToBoxAdapter(child: Margin(child: Text('Section Title'))),
          SliverGutter(),
          SliverMargin(
            margin: context.layout.breakpoint == LayoutBreakpoint.xs
                ? EdgeInsets.all(16)
                : null,
            sliver: SliverGrid(
              delegate: SliverChildListDelegate.fixed(
                List.generate(100, (index) => CardItem(index: index)),
              ),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndMainAxisExtent(
                    crossAxisCount: context.layout.value(
                      xs: 1,
                      sm: 2,
                      md: 2,
                      lg: 3,
                      xl: 4,
                    ),
                    mainAxisExtent: 60,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
