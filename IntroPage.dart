import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levelpage/shloka_entry.dart';
import 'package:levelpage/text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'remotefile.dart';
import 'package:download/download.dart';


// void main() {
// runApp(MyApp());
// }


// ValueNotifier<String> counter = ValueNotifier<String>('');
// AudioPlayer player = AudioPlayer();

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainHome(),
//     );
//   }
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return new MyAppState();
//   }
// }
// class MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }

class MyAppP extends StatefulWidget {
  @override
  MyAppPState createState() {
    return new MyAppPState();
  }
}

class MyAppPState extends State<MyAppP> {
  final imgUrl = "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
  bool downloading = false;
  var progressString = "";




  @override
  void initState() {
    super.initState();
    downloadFile();
  }

//   onReceiveProgress: (rec, total) {
//   print("Rec: $rec , Total: $total");
//   setState(() {
//   downloading = true;
//   progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
//   });
// });



  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      String syncPath = "${dir.path}/demo.mp4";
      bool exists = await io.File(syncPath).exists();
      if(!exists) {
        await dio.download(imgUrl, "${dir.path}/demo.mp4");
        await dio.download(imgUrl, "${dir.path}/demo1.mp4");
        await dio.download(imgUrl, "${dir.path}/demo2.mp4");
      }
      List<String> files = ["${dir.path}/demo.mp4", "${dir.path}/demo1.mp4", "${dir.path}/demo2.mp4"];
      // counter.addListener((){
      //   playAudioFile(syncPath);
      // });

      // for(int i=0; i<3; i++) {
      //   Duration duration = await player.getDuration() ?? Duration(milliseconds: 100);
      //   String path = files.elementAt(i);
      //   Future.delayed(const Duration(milliseconds: 10), () {
      //     counter.value = path;
      //   });
      //   io.sleep(duration);
      // }
      playFiles(Queue.from(files));
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  Future<void> playAudioFile(String syncPath) async {
    AudioPlayer mediaPlayer = AudioPlayer();
    // await mediaPlayer.setSourceUrl(syncPath);
    await mediaPlayer.play(UrlSource(syncPath));
    // player.onPlayerComplete.listen((event) {
    //   setState(() {
    //
    //   });
    // });
  }

  Future<void> playFiles(Queue<String> files) async {
    if(files.isEmpty) {
      return;
    }
    String path = files.removeFirst();
    // await player.setSourceUrl(path);
    // Duration ref = await player.getDuration() ?? Duration(milliseconds: 100);
    // counter.value = path;
    // Future.delayed(Duration(milliseconds:  ref.inMilliseconds * 2), () {
    //   playFiles(files);
    // });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Center(
        child: downloading
            ? Container(
          height: 120.0,
          width: 200.0,
          child: Card(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Downloading File: $progressString",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        )
            : Text("No Data"),
      ),
    );
  }
}



class MainHome extends StatefulWidget {
  MainHome({Key? key}) : super(key: key);

  final RemoteFile remoteFile = RemoteFile("https://drive.google.com/uc?export=download&id=1DLLEQHyHieFTOICYxEqZQ789A2WS8JCy");
  final localFileName = "ganesha_stotram";
  @override
  State<MainHome> createState() => _MainHomeState();

}

class _MainHomeState extends State<MainHome> {

  /// List of Tab Bar Item
  List<String> items = [];
  List<String> sequenceList = [""];
  String currentStotramLocation = "";

  int downloadedTotal = 0;

  int current = 0;

  String currentLevelPath = "";

  List<ShlokaEntry> shlokaEntries = [];

  ValueNotifier<ShlokaEntry> counter = ValueNotifier<ShlokaEntry>(
    ShlokaEntry("","", "")
  );


  @override
  void initState() {
    counter.addListener((){
      playAudioFile(counter.value);
    });

    downloadedTotal = 0;
    downloadRemoteZip(widget.remoteFile);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],

      /// APPBAR
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "SHLOKAM",
          style: GoogleFonts.laila(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [

            /// SHLOKAM
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            loadSequenceList(index).then((value) => {
                              setState(() {
                                current = index;
                                shlokaEntries = value;
                              })
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 80,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? Colors.white70
                                  : Colors.white54,
                              borderRadius: current == index
                                  ? BorderRadius.circular(15)
                                  : BorderRadius.circular(10),
                              border: current == index
                                  ? Border.all(
                                  color: Colors.deepPurpleAccent, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: GoogleFonts.laila(
                                    fontWeight: FontWeight.w500,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: current == index,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  shape: BoxShape.circle),
                            ))
                      ],
                    );
                  }),
            ),
            SizedBox(
              width: double.infinity,
              height: 500,
              child: ListView.builder(
                  itemCount: shlokaEntries.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                          title: Text(shlokaEntries[index].text),
                          onTap: () {
                            // playCurrentSelection(index);
                            playCurrentSelectionInSequence(index);
                          },
                        )
                    );
                  }),
            ),

            /// MAIN BODY
          ],
        ),
      ),
    );
  }

  void playCurrentSelection(int index) {
    AudioPlayer player = AudioPlayer();
    player.play(UrlSource(shlokaEntries[index].mp3Path));
  }

  downloadRemoteZip(RemoteFile remoteFile) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    print("path ${dir.path}");
    String filename = "${widget.localFileName}.zip";
    String syncPath = "${dir.path}/$filename";
    var extractionDirPath = "${dir.path}";
    var finalDirPath = "$extractionDirPath/${widget.localFileName}";
    bool exists = await io.Directory(finalDirPath).exists();
    if (!exists) {
      dio.download(
          remoteFile.url, syncPath, onReceiveProgress: (count, total) =>
      {
        if(count == total) {
          extractFile(total, syncPath, extractionDirPath)
        }
      }, deleteOnError: true);
      // Delete zip file
    } else {
      setState(() {
        setupLevels(extractionDirPath, basenameWithoutExtension(syncPath));
      });
    }
  }

  void extractFile(int count, String syncPath, String extractionDirPath) {
    // print("total downloaded $count");
    // print("total downloaded $downloadedTotal");
    // if(count != downloadedTotal) {
    //   downloadedTotal = count;
    //   return;
    // }
    // print("total downloaded continued $count");
    io.File zipFile = io.File(syncPath);
    zipFile.exists().then((value) =>
    {
      if(value) {
        extractFileInternal(extractionDirPath, zipFile)
      } else
        {
          print("File not ready yet.")
        }
    });
    print("Total dowanloaded count. $count");
  }

  void extractFileInternal(String extractionDirPath, io.File zipFile) {
    final destinationDir = io.Directory(extractionDirPath);
    try {
      ZipFile.extractToDirectory(zipFile: zipFile,
          destinationDir: destinationDir).then((value) =>
      {
        setupLevels(extractionDirPath, basenameWithoutExtension(zipFile.path))
      });
    } catch (e) {
      print(e);
    }
  }

  void setupLevels(String extractionDirPath, String dirName) {
    io.Directory extractionDir = io.Directory("$extractionDirPath/$dirName");
    currentStotramLocation = extractionDir.path;
    setState(() {
      items = extractionDir.listSync().map((e) => basename(e.path)).toList();
      loadSequenceList(current);
    });
  }

  Future<List<ShlokaEntry>> loadSequenceList(int index) async {
    currentLevelPath = "$currentStotramLocation/${items.elementAt(index)}";
    List<String> ids = await io.File("$currentLevelPath/index.txt").readAsLines();
    return [for(String id in ids) await mapEntry(id)];
    //print("Loaded ${shlokaEntries.length} Entries");
  }

  Future<ShlokaEntry> mapEntry (String id) async{
    String content = await io.File("$currentLevelPath/text/${id}.txt")
        .readAsString();
    return ShlokaEntry(id, content, "$currentLevelPath/media/${id}.mp3");
  }

  Future<void> playAudioFile(ShlokaEntry entry) async {
    AudioPlayer mediaPlayer = AudioPlayer();
    Uint8List data = io.File(entry.mp3Path).readAsBytesSync();
    await mediaPlayer.play(BytesSource(data));
  }

  void playCurrentSelectionInSequence(int index) {
    Queue<ShlokaEntry> queue = Queue.from(shlokaEntries
        .sublist(index, shlokaEntries.length));
    playFiles(queue);
  }

  Future<void> playFiles(Queue<ShlokaEntry> entries) async {
    AudioPlayer player = AudioPlayer();
    if(entries.isEmpty) {
      return;
    }
    ShlokaEntry entry = entries.removeFirst();
    await player.setSourceUrl(entry.mp3Path);
    Duration ref = await player.getDuration() ?? Duration(milliseconds: 100);
    counter.value = entry;
    Future.delayed(Duration(milliseconds:  ref.inMilliseconds * 2), () {
      playFiles(entries);
    });
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //
  //       child: RawMaterialButton(child: Text("Click here"),
  //         fillColor: Colors.lightBlueAccent,
  //         onPressed: () {
  //           final PlayerAudio = AudioCache();
  //         },
  //
  //
  //       ),
  //     ),
  //
  //   );
  //   throw UnimplementedError();
  // }
}



