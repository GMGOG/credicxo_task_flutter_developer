import 'package:credicxo_task/BLoC/trackLyricsBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:credicxo_task/BLoC/trackDetailsBloc.dart';
import 'package:credicxo_task/models/trackLyrics.dart';
import 'package:credicxo_task/models/trackDetails.dart';
import 'package:credicxo_task/Widgets/InfoWidget.dart';

class InfoPage extends StatefulWidget {
  final String trackId;
  InfoPage(this.trackId);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trackDetailsBloc.fetchTrackDetails(widget.trackId);
    trackLyricsBloc.fetchTrackLyrics(widget.trackId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
        ),
        elevation: 7,
        backgroundColor: Colors.white,
        title: Text(
          'Track Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 60, 20),
        child: ListView(
          children: [
            StreamBuilder<TrackDetails>(
              stream: trackDetailsBloc.trackDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _isLoaded = true;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoWidget(
                        header: 'Name',
                        content: snapshot.data.message.body.track.trackName,
                      ),
                      InfoWidget(
                        header: 'Artist',
                        content: snapshot.data.message.body.track.artistName,
                      ),
                      InfoWidget(
                        header: 'Album Name',
                        content: snapshot.data.message.body.track.albumName,
                      ),
                      InfoWidget(
                        header: 'Explicit',
                        content:
                            snapshot.data.message.body.track.explicit != null
                                ? 'True'
                                : 'False',
                      ),
                      InfoWidget(
                        header: 'Rating',
                        content: snapshot.data.message.body.track.trackRating
                            .toString(),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            StreamBuilder<TrackLyrics>(
              stream: trackLyricsBloc.trackLyrics,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InfoWidget(
                      header: 'Lyrics',
                      content: snapshot.data.message.body.lyrics.lyricsBody);
                } else {
                  if (_isLoaded) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
