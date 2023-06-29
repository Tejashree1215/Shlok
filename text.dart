import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FileListView extends StatefulWidget {
  @override
  _FileListViewState createState() => _FileListViewState();
}

class _FileListViewState extends State<FileListView> {
  List<String> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      String contents = await rootBundle.loadString('assets/0_0.txt');
      setState(() {
        data = contents.split('\n');
      });
    } catch (e) {
      print("Error reading file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File ListView'),
      ),
      body: Column(
        children: [
        SizedBox(
        width: double.infinity,
        height: 400,
        child: ListView.builder(
            //itemCount: name.length,
            itemBuilder:(context, index){
              return Card(
                  child: ListTile(
                    title: Text(data[index]),
                  )
              );
            }),
      ),

        ],
      ),
    );
  }
}



