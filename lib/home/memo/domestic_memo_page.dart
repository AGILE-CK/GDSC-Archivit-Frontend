import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:gdsc/provider/make_file_page_provider.dart';
import 'package:gdsc/service/get_default_directory.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DomesticMemoPage extends StatefulWidget {
  @override
  _DomesticMemoPage createState() => _DomesticMemoPage();
}

class _DomesticMemoPage extends State<DomesticMemoPage> {
  final TextEditingController _textEditingController = TextEditingController(
    text:
        "Incident statement\n\nWHEN     Date of Incident\n⚠️ If the violence has persisted for an extended period, please provide more detailed information on the “WHAT/HOW” section regarding the specific start date and frequency. \n\n  Date ::  ___  Month ::  ___  Year ::  ___  \n\nWhen     Time of Incident\n⚠️ If you don’t know the exact time, please specify the time using situations (e.g. after the class finished)\n\n  AM PM\n   Hours  ::  ___  Minutes  ::  ___  \n                            \n                            ⁝\n                            ⁝\n\n   Hours  ::  ___  Minutes  ::  ___  \n\n\nWhere   Location of incident\n\n\n\nWHO     Perpetrator's information\n⚠️Please provide a list of all people related to this incident\n(name, relationship with you,etc...)\n\n\nWHAT   What kind of harm have you suffered?\n⚠️if possible, please chronologically describe the violent situation,\nduration, and whether there was a group assault\n1.\n2.\n3.\n\n\nWHY     Why did the perpetrator use violence?\n\n\n\n\n  Presence of any witnesses\n⚠️if there are witnesses, please record their statements in either audio or\nwritten from (Guidelines for writing witness statements)\n\n\n\n\n  Feelings\n\n\n\n\n  Desired action\n\n\n\n\n\n\n  Evidence\n⚖️ List of evidence that can be uesd as proof\n1.photos(showing evidence of violence, used weapons, screenshots of online conversations)\n*if you have injuries, take two photos : one focused on the injuries and another showing them along with your face\n2. videos or recordings of the scene of violence(including call recording)\n3.CCTV footage\n  *CCTV footage can be deleted, so please secure it as soon as\npossible)\n4. medical diagnosis report\n5. counseling records\n6. written statement from spouse\n7. police report records\n*Records of reaching out for help about violence to those around you can also serve as evidence\nFor more detailed information, please check 'here'   ",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<MakeFilePageProvider>(
            builder: (context, makeTextFilePageProvider, child) {
              return GestureDetector(
                onTap: () {
                  _saveTextFile(makeTextFilePageProvider.fullPath, context);
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 16.0, top: 15),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
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

  Future<void> _saveTextFile(String path, context) async {
    final Directory directory = await createUserDataDirectory();

    final File file = File('${directory.path}/$path.txt'); //provider todo
    await file.writeAsString(_textEditingController.text);
    Provider.of<FolderPageProvider>(context, listen: false).listFilesAndTexts();
  }
}
