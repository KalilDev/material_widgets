import 'package:example/common/layout.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:flutter/material.dart';

class SliverAppBarDemo extends StatelessWidget {
  const SliverAppBarDemo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MD3AdaptativeScaffold(
      bodyMargin: false,
      body: CustomScrollView(
        slivers: [
          MD3SliverAppBar(
            title: Text('Sliver AppBar'),
            pinned: true,
          ),
          SliverToBoxAdapter(child: margin),
          SliverFillViewport(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Text('An view with an SliverAppBar'),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(child: margin),
        ],
      ),
    );
  }
}
