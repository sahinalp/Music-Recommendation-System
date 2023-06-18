// Package imports:
import 'package:firebase_database/firebase_database.dart';

// Project imports:
import 'package:music_by_mood/constant/constants.dart';
import '../model/song_model.dart';

class SongRepository {
  final _database = FirebaseDatabase.instance.ref();

  Future<int> getSongsLength() {
    return _database.child(ConstantStrings.firebaseDatabasePath).get().then(
      (DataSnapshot snapshot) {
        return snapshot.children.length;
      },
    );
  }

  Future<SongModel> getRandomSong(int random) async {
    SongModel song;
    final event = await _database
        .child('${ConstantStrings.firebaseDatabasePath}/$random')
        .once();
    try {
      song = SongModel.fromJson((event.snapshot.value as Map<Object?, Object?>)
          .cast<String, dynamic>());
    } catch (e) {
      throw Error();
    }
    return (song);
  }

  Future<List<SongModel>> getRecommendedSongs(List<int> clusterLabels) async {
    final songs = <SongModel>[];

    // clusterLabels.toSet().toList(); //remove duplicates

    for (var clusterLabel in clusterLabels) {
      await _database
          .child(ConstantStrings.firebaseDatabasePath)
          .orderByChild('cluster_label')
          .equalTo(clusterLabel)
          .limitToFirst(2)
          .once()
          .then((event) {
        if (event.snapshot.value != null) {
          print(event.snapshot.value);
          final songsList = event.snapshot.value as List<Map<Object?, Object>>;
          for (var songMap in songsList) {
            final song = SongModel.fromJson(songMap.cast<String, dynamic>());
            songs.add(song);
          }
        }
      });
    }

    return songs;
  }
}
