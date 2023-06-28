import 'package:dima_project/classes/note_model.dart';

import 'package:flutter/material.dart';

class ShowNotePage extends StatefulWidget {
  final NoteModel? selectedNote;

  final userID = "0123456789";
  ShowNotePage({super.key, this.selectedNote});

  @override
  State<ShowNotePage> createState() => _ShowNotePageState();
}

class _ShowNotePageState extends State<ShowNotePage> {
  List<bool> isSelected = List.filled(100, false, growable: false);
  @override
  void initState() {
    super.initState();
    List<bool> isSelected = List.filled(widget.selectedNote?.attachmentUrls?.length ?? 0, false, growable: false);
  }

  @override
  Widget build(BuildContext context) {
    //todo check selected for tablet
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Details"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            key: Key("title"),
            " Title: ${widget.selectedNote!.name}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          //print ⭐️ according to the evaluation
          //used to set the right width of the pace, due to column set the withd according to the size of the biggest widget
          Row(children: []),
          SizedBox(height: 7),

          Text(
            key: Key("information"),
            widget.selectedNote!.author.uid == widget.userID
                ? "Your ${widget.selectedNote!.isShared ? "shared" : "private"} note written on ${widget.selectedNote!.timestamp.toDate().toString().split(" ")[0]}"
                : "Written By: ${widget.selectedNote!.author.username} on ${widget.selectedNote!.timestamp.toDate().toString().split(" ")[0]}",
            style: TextStyle(fontSize: 15),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 15),
          //print description with scrollable view if too long using NestedScrollView
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple[300]!),
                borderRadius: BorderRadius.circular(10),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.selectedNote?.description ?? "No description available",
                      style: TextStyle(fontSize: 16),
                    ),
                  ))),
          SizedBox(height: 10),
          if (widget.selectedNote?.attachmentUrls != null)
            Text(
              "Pick the File you want to download 📲",
              style: TextStyle(fontSize: 16),
            ),
          SizedBox(height: 10),

          //horizontal list with all the attachments
          /*widget.selectedNote?.attachmentUrls != null
              ? Container(
                  decoration: BoxDecoration(),
                  height: 110,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.selectedNote!.attachmentUrls!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: InkWell(
                              onTap: () {
                                //downloadFile(widget.selectedNote!.attachmentUrls![index].url, index);
                              },
                              child: Container(
                                width: 100,
                                child: Card(
                                    child: isSelected[index]
                                        ? Center(child: CircularProgressIndicator())
                                        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.description_outlined, size: 35),
                                            Text(
                                              textAlign: TextAlign.center,
                                              widget.selectedNote!.attachmentUrls![index].name,
                                              style: TextStyle(fontSize: 11),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ])),
                              )));
                    },
                  ))
              : */
          Expanded(key: Key("noAttachments"), child: Image(image: AssetImage("assets/noAttachments.png"))),
        ],
      ),
      floatingActionButton: widget.selectedNote?.author.uid != widget.userID
          ? null
          : FloatingActionButton(
              child: Icon(Icons.edit_document),
              onPressed: () {
                //context.push("/courses/reviews/modifyNote", extra: widget.selectedNote!).then((value) => context.pop(value ?? ""));
              },
            ),
    );
  }

  //download file
  /*
  Future<bool>? downloadFile(String url, int index) async {
    
    print("Downloading file");
    FileDownloader.downloadFile(
      url: url,
      onProgress: (fileName, progress) {
        print("Downloading file $progress");
        setState(() {
          isSelected[index] = true;
        });
      },
      onDownloadCompleted: (fileName) {
        print("Download completed");

        setState(() {
          isSelected[index] = false;
        });
      },
      onDownloadError: (errorMessage) {
        print(errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download Failed")));
        setState(() {
          isSelected[index] = false;
        });
      },
    );
  
    isSelected[index] = false;
    return true;
  }
  */
}
