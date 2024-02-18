import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlankMemoPage extends StatefulWidget {
  @override
  _BlankMemoPageState createState() => _BlankMemoPageState();
}

class _BlankMemoPageState extends State<BlankMemoPage> {
  final TextEditingController _textEditingController = TextEditingController();

  String textContent = "12341243";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30.0,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "todo",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: TextField(
                  onChanged: (value) {
                    setState(() => _textEditingController.text = value);
                  },
                  controller: _textEditingController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
