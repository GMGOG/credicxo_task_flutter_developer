import 'package:credicxo_task/BLoC/ConnectivityBloc.dart';
import 'package:credicxo_task/models/trendingtracks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../BLoC/trendingTracsksBloc.dart';
import 'package:credicxo_task/screens/Info.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivityBloc.statusController.stream.listen((event) {
      if (event) {
        bloc.fetchTrendingTracks();
      }
    });
    connectivityBloc.observeConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 7,
        backgroundColor: Colors.white,
        title: Text(
          'Trending',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<bool>(
          stream: connectivityBloc.statusController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data
                  ? StreamBuilder<TrendingTracks>(
                      stream: bloc.allTracks,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            separatorBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                color: Colors.black54,
                              ),
                            ),
                            itemCount:
                                snapshot.data.message.body.trackList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InfoPage(
                                            snapshot.data.message.body
                                                .trackList[index].track.trackId
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    leading: Icon(Icons.library_music),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data.message.body
                                              .trackList[index].track.trackName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data.message.body
                                              .trackList[index].track.albumName,
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      width: 100,
                                      child: Text(
                                        snapshot.data.message.body
                                            .trackList[index].track.artistName,
                                      ),
                                    )),
                              );
                            },
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      })
                  : Container(
                      child: Center(
                        child: Text('No Internet Connection'),
                      ),
                    );
            } else {
              return Container();
            }
          }),
    );
  }
}
