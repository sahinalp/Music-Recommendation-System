class SongModel {
  final double acousticness;
  final String albumId;
  final String artistsId;
  final String availableMarkets;
  final int clusterLabel;
  final String country;
  final String id;
  final String lyrics;
  final String name;
  final String playlist;
  final String uri;

  SongModel({
    required this.acousticness,
    required this.albumId,
    required this.artistsId,
    required this.availableMarkets,
    required this.clusterLabel,
    required this.country,
    required this.id,
    required this.lyrics,
    required this.name,
    required this.playlist,
    required this.uri,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      acousticness: json['acousticness'],
      albumId: json['album_id'],
      artistsId: json['artists_id'],
      availableMarkets: json['available_markets'],
      clusterLabel: json['cluster_label'],
      country: json['country'],
      id: json['id'],
      lyrics: json['lyrics'],
      name: json['name'],
      playlist: json['playlist'],
      uri: json['uri'],
    );
  }
}
