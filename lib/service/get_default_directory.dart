import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> createUserDataDirectory() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'user_data');
  final userDataDirectory = Directory(path);
  if (!await userDataDirectory.exists()) {
    await userDataDirectory.create();
  }
  return userDataDirectory;
}
