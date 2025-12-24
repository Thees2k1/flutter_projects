import 'package:cupertino_sample/model/app_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart' show Consumer;

class ProductListTab extends StatelessWidget {
  const ProductListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        return CustomScrollView(
          slivers: const <Widget>[
            CupertinoSliverNavigationBar(largeTitle: Text('Cupertino Store')),
          ],
        );
      },
    );
    ;
  }
}
