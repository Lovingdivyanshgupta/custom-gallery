import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadUtils extends StatefulWidget {
  const UploadUtils({Key? key, required this.checkedFileList}) : super(key: key);

  // final bool isUpload;
  final List<FileSystemEntity> checkedFileList;

  @override
  State<UploadUtils> createState() => _UploadUtilsState();
}

class _UploadUtilsState extends State<UploadUtils> {
  double inProgress = 0;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: const EdgeInsets.all(10),
      elevation: 6,
      onPressed: () async {
        gs: //my-project-social-integration.appspot.com
        var inst = FirebaseStorage.instance;

        var file = File("${widget.checkedFileList[0].path.split(".png")[0]}.mp4");
        print("object : ${file.path} : ${file.existsSync()}  : ${file.path.split("Files/")[1]}");

        try {
          final ref = inst.ref("Video").child(file.path.split("Files/")[1]);
          print("object : ${ref.name}");
          final upload = await ref
              .putFile(
            file,
            SettableMetadata(
              contentType: "video/mp4",
              contentEncoding: "deflate, gzip",
              contentDisposition: "form-data; name=\"${ref.name.split(".mp4")[0]}\"; filename=\"${ref.name}\" ",
            ),
          );

          if(upload.state == TaskState.running){
            var progress = (upload.bytesTransferred/upload.totalBytes)*100;
            print("progress : $progress");
            setState(() {
              inProgress = progress ;
            });
          }
          // await upload.ref.getDownloadURL().then((value) => print("url download : $value"));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload Successfully.")));
          // Navigator.pop(context);
        } catch (e) {
          print("error occurred : $e");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Occurred : $e.")));
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      fillColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Upload to cloud",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            width: 10,
          ),
          (inProgress == 0)
              ? const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.black,
                )
              : Text(inProgress.toString()),
        ],
      ),
    );
  }
}
