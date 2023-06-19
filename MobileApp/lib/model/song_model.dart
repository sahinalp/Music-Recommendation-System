import 'package:postgres/postgres.dart';

class SongModel {
  final int id;
  final String songId;
  final String songName;
  final String songCluster;
  final String availableMarkets;
  final String country;
  final String lyrics;
  final String uri;

  SongModel({
    required this.availableMarkets,
    required this.songId,
    required this.songName,
    required this.songCluster,
    required this.country,
    required this.id,
    required this.lyrics,
    required this.uri,
  });

  factory SongModel.fromJson(PostgreSQLResultRow resultRow) {
    return SongModel(
      id: resultRow[0],
      availableMarkets: resultRow[4],
      lyrics: resultRow[7],
      uri: resultRow[6],
      songId: resultRow[1],
      songName: resultRow[2],
      songCluster: resultRow[3],
      country: resultRow[5],
    );
  }
}
