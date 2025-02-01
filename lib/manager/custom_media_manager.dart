import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../app_helper/route.dart';
import '../utils/upload_utils.dart';

const String pathExternalStorageAndroid =
    "/storage/emulated/0/Android/data/com.example.poc_custom_gallery/files/Media Files";
const String pathExternalStorageIOS =
    "/var/mobile/Containers/Data/Application/F55EBAC6-5EAB-46FB-A8B6-9E856FED2538/Documents/Media Files";

class CustomMediaManager extends StatefulWidget {
  const CustomMediaManager({Key? key}) : super(key: key);

  @override
  State<CustomMediaManager> createState() => _CustomMediaManagerState();
}

class _CustomMediaManagerState extends State<CustomMediaManager> {
  VideoPlayerController? videoPlayerController;
  List<FileSystemEntity> data = [];
  bool isDelete = false;
  bool isChecked = false;
  List<FileSystemEntity> checkedFileList = [];

  List<FileSystemEntity> getFileData() {
    var path = (Platform.isAndroid) ? pathExternalStorageAndroid : pathExternalStorageIOS;
    List<FileSystemEntity> dir = [];
    try {
      List<FileSystemEntity> finalList;
      finalList = Directory(path).listSync();
      dir = finalList.toList(growable: true);
      for (var element in finalList) {
        if (element.path.contains('mp4')) {
          dir.remove(element);
        }
      }
    } catch (e) {
      print(e);
      return dir;
    }
    return dir;
  }

  @override
  void initState() {
    data = getFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
        backgroundColor: const Color(0xFFe71b73),
        centerTitle: true,
        actions: (isDelete)
            ? [
                IconButton(
                  onPressed: deleteGridItemsOnPressed,
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ]
            : null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: (data.isEmpty)
          ? const Center(
              child: Text("No data found"),
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GridView.count(
                padding: const EdgeInsets.all(10),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: data.map(
                  (e) {
                    bool hasImage = e.path.contains(RegExp('image'));
                    return InkWell(
                      onTap: () {
                        if (!isDelete) {
                          print("navigate path ${e.path}");

                          if (hasImage) {
                            Navigator.pushNamed(
                              context,
                              Routes.imagePreview,
                              arguments: {"path": e.path},
                            );
                          } else {
                            var joinPath = e.path.split('.png').join('.mp4');
                            print("join : $joinPath");
                            Navigator.pushNamed(
                              context,
                              Routes.videoPreview,
                              arguments: {"path": joinPath},
                            );
                          }
                        }
                      },
                      onLongPress: () {
                        if (data.isNotEmpty) {
                          isDelete = !isDelete;
                          setState(() {});
                        }
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: (hasImage)
                                ? Image.file(
                                    File(e.path),
                                    fit: BoxFit.fill,
                                  )
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        File(e.path),
                                        fit: BoxFit.fill,
                                      ),
                                      const Center(
                                        child: Icon(
                                          CupertinoIcons.play_rectangle,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          if (isDelete)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.pink.withOpacity(
                                  (checkedFileList.contains(e)) ? 0.2 : 0,
                                ),
                              ),
                            ),
                          if (isDelete)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Checkbox(
                                shape: const CircleBorder(
                                  side: BorderSide(color: Colors.white, width: 5),
                                ),
                                value: (checkedFileList.contains(e)),
                                onChanged: (bool? check) {
                                  isChecked = check!;
                                  print("is checked : $isChecked");

                                  if (checkedFileList.contains(e)) {
                                    var index = checkedFileList.indexOf(e);
                                    checkedFileList.removeAt(index);
                                  } else {
                                    checkedFileList.add(e);
                                  }
                                  print("checked index : $checkedFileList");
                                  setState(() {});
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
      bottomSheet: checkedFileList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: UploadUtils(
                  checkedFileList: checkedFileList,
                ),
              ),
            )
          : null,
    );
  }

  void deleteGridItemsOnPressed() async {
    if (isDelete) {
      for (var file in checkedFileList) {
        print("files : $file");
        try {
          await file.delete().then((value) {
            data.remove(file);
            setState(() {});
            print("object delete is done.");
          });
        } catch (e) {
          print("error occurred in deletion");
        }
      }
      isDelete = !isDelete;
      print("files are deleted : $checkedFileList");
      checkedFileList.clear();
    }
  }
}
