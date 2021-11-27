import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemEdgeToEdge extends StatefulWidget {
  const SystemEdgeToEdge({Key key, this.child}) : super(key: key);
  final Widget/*!*//*!*/ child;

  @override
  _SystemEdgeToEdgeState createState() => _SystemEdgeToEdgeState();
}

class _SystemEdgeToEdgeState extends State<SystemEdgeToEdge>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // set it again every metrics change to ensure the platform does not override
  // it.
  @override
  void didChangeMetrics() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
