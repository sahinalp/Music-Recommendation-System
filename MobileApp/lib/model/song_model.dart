import 'package:postgres/postgres.dart';

class SongModel {
  final int id;
  final String songId;
  final String songName;
  final String songCluster;
  final int popularity;
  final String availableMarkets;
  final String country;
  final String lyrics;
  final String uri;

  SongModel({
    required this.availableMarkets,
    required this.songId,
    required this.songName,
    required this.songCluster,
    required this.popularity,
    required this.country,
    required this.id,
    required this.lyrics,
    required this.uri,
  });

  factory SongModel.fromJson(PostgreSQLResultRow resultRow) {
    return SongModel(
      id: resultRow[0],
      songId: resultRow[1],
      songName: resultRow[2],
      songCluster: resultRow[3],
      popularity: resultRow[4],
      availableMarkets: resultRow[5],
      country: resultRow[6],
      uri: resultRow[7],
      lyrics: resultRow[8],
    );
  }
}
