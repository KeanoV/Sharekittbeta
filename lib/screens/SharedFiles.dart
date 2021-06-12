import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class UploadDoc extends StatefulWidget {
  @override
  _UploadDocState createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  FirebaseStorage storage = FirebaseStorage.instance;
  File _path;
  List<File> _paths;
  String _extension;
  FileType _pickType;
  bool _multiPick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<UploadTask> _tasks = <UploadTask>[];

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Download "),
      content: Text("Download Completed"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> downloadFile(Reference ref) async {
    final String url = await ref.getDownloadURL();
    print("download link is");
    print(url);

    final dir = await getApplicationDocumentsDirectory();
    print("Download path");
    print(dir.path.toString());
    final file = File('${dir.path}/${ref.name}');
    final DownloadTask task = ref.writeToFile(file);
    task.then((value) => {
          showAlertDialog(context),
          print(
            'Success!downloaded ',
          )
        });
  }

  Future<String> uploadFile(fileName) {
    try {
      Reference ref =
          FirebaseStorage.instance.ref(fileName.path.split('/').last);
      UploadTask uploadTask =
          ref.putFile(fileName, SettableMetadata(contentType: 'document'));

      setState(() {
        _tasks.add(uploadTask);
      });
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  String _bytesTransferred(UploadTask snapshot1) {
    return '${snapshot1.snapshot.bytesTransferred}/${snapshot1.snapshot.totalBytes}';
  }

  void openFileExplorer() async {
    try {
      _path = null;
      if (_multiPick) {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['docx', 'pdf', 'doc'],
        );
        if (result != null) {
          _paths = result.paths.map((path) => File(path)).toList();
          uploadToFirebase();
        } else {
          // User canceled the picker
        }
      } else {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['docx', 'pdf', 'doc'],
        );

        if (result != null) {
          _path = File(result.files.single.path);
          uploadToFirebase();
        } else {
          // User canceled the picker
        }
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  uploadToFirebase() {
    bool flag = true;
    String temp1;
    if (_multiPick) {
      _paths.forEach((element) => {
            temp1 = element.path.split('/').last,
            temp1 = temp1.split('.').last,
            if (temp1 == "doc" || temp1 == "docx" || temp1 == "pdf")
              {
                uploadFile(element),
              }
            else
              {}
          });
    } else {
      temp1 = _path.path.split('/').last;
      temp1 = temp1.split('.').last;
      if (temp1 == "doc" || temp1 == "docx" || temp1 == "pdf") {
        uploadFile(_path);
      } else {}

      //if (flag) uploadFile(_path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    _tasks.forEach((UploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
        onDownload: () => downloadFile(task.snapshot.ref),
      );
      children.add(tile);
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("File Upload"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            //  dropDown(),
            SwitchListTile.adaptive(
              title: Text('Pick multiple files', textAlign: TextAlign.left),
              onChanged: (bool value) => setState(() => _multiPick = value),
              value: _multiPick,
            ),
            OutlineButton(
              onPressed: () => openFileExplorer(),
              child: new Text("Open file picker"),
            ),
            SizedBox(
              height: 20.0,
            ),
            Flexible(
              child: ListView(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final UploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    String temp;
    result = task.snapshot.state.toString();
    temp = result.split('.').last;
    if (temp == "running") result = 'Uploading';
    if (temp == "success") result = 'Complete';
    if (temp == "paused") result = 'Paused';
    print(result);
    return result;
  }

  bool send(String state1) {
    String result = status;
    bool result2;
    if (state1 == "isInProgress" && result == "Uploading") result2 = true;
    if (state1 == "isInProgress" && result != "Uploading") result2 = false;
    if (state1 == "isPaused" && result == "Paused") result2 = true;
    if (state1 == "isPaused" && result != "Paused") result2 = false;
    if (state1 == "isComplete" && result == "Complete") result2 = true;
    if (state1 == "isComplete" && result != "Complete") result2 = false;
    return result2;
  }

  String _bytesTransferred(UploadTask snapshot1) {
    return '${snapshot1.snapshot.bytesTransferred}/${snapshot1.snapshot.totalBytes}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder:
          (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final TaskSnapshot event = asyncSnapshot.data;
          // event.;
          subtitle = Text(
              '$status: ${event.bytesTransferred}/${event.totalBytes} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !send("isInProgress"),
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !send("isPaused"),
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: !send("isComplete"),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
