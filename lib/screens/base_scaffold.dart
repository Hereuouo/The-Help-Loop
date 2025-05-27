import 'package:flutter/material.dart';
import 'font_styles.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Decoration? decoration;
  final String? title;
  final List<Widget>? actions;

  const BaseScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.decoration,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          (title != null
              ? AppBar(
                  title: Text(title!,
                      style: FontStyles.heading(context, fontSize: 24)),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  centerTitle: true,
                  actions: actions,
                )
              : null),
      floatingActionButton: floatingActionButton,
      backgroundColor: Color(0xFF537895),
      body: Container(
        height: double.infinity,
        decoration: decoration ??
            const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF09203F), Color(0xFF537895)],
              ),
            ),
        child: SafeArea(
          child: DefaultTextStyle(
            style: FontStyles.body(context, color: Colors.white),
            child: child,
          ),
        ),
      ),
    );
  }
}

