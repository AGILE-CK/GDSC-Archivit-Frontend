import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BlankMemoPage extends StatefulWidget {
  const BlankMemoPage({Key? key}) : super(key: key);

  @override
  _BlankMemoPageState createState() => _BlankMemoPageState();
}

class _BlankMemoPageState extends State<BlankMemoPage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = 'Initial markdown text';
  }

  var markdownText = ''' ''';

  Widget getMarkdownWidget(String text) {
    return Markdown(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(fontSize: 24),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markdown Editor'),
      ),
      body: getMarkdownWidget(markdownText),
    );
  }
}
