import '../constant/constants.dart';
import 'package:postgres/postgres.dart';
import '../model/song_model.dart';

class SongRepository {
  static final SongRepository _instance = SongRepository._private();

  static SongRepository get instance => _instance;

  SongRepository._private();

  final connection = PostgreSQLConnection(ConstantStrings.hostName,
      ConstantStrings.port, ConstantStrings.databaseName,
      username: ConstantStrings.username, password: ConstantStrings.password);

  Future<SongModel> getRandomSong(int random) async {
    SongModel song;
    final event = await connection.query(
        "select * from \"MusicRecommendation\".\"database\" d where id =$random order by popularity desc \n");
    try {
      song = SongModel.fromJson(event.first);
    } catch (e) {
      throw Error();
    }
    return (song);
  }

  Future<List<SongModel>> getRecommendedSongs(
      List<String> clusterLabels) async {
    final songs = <SongModel>[];

    for (var clusterLabel in clusterLabels) {
      await connection
          .query(
              "select * from \"MusicRecommendation\".\"database\" d where songcluster::int8 =${int.parse(clusterLabel)} LIMIT 2 \n")
          .then((event) {
        final songsList = event;
        for (var songMap in songsList) {
          final song = SongModel.fromJson(songMap);
          songs.add(song);
        }
      });
    }

    return songs;
  }

  Future<List<SongModel>> search(String query) async {
    final songs = <SongModel>[];
    await connection
        .query(
            "select * from \"MusicRecommendation\".\"database\" d where songname like '$query%' LIMIT 20\n")
        .then((event) {
      final songsList = event;
      for (var songMap in songsList) {
        final song = SongModel.fromJson(songMap);
        songs.add(song);
      }
    });

    return songs;
  }
}
