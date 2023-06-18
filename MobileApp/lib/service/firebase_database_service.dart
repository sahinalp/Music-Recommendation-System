// // Package imports:
// import 'package:firebase_database/firebase_database.dart';

// // Project imports:
// import '../constant/constants.dart';
// import '../model/song_model.dart';

// class FirebaseDatabaseService {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();

//   Future<void> createSong(SongModel song) async {
//     try {
//       final songRef = _database.child('songs').push();
//       await songRef.set({
//         'acousticness': song.acousticness,
//         'album_id': song.albumId,
//         'artists_id': song.artistsId,
//         'available_markets': song.availableMarkets,
//         'cluster_label': song.clusterLabel,
//         'country': song.country,
//         'id': song.id,
//         'lyrics': song.lyrics,
//         'name': song.name,
//         'playlist': song.playlist,
//         'uri': song.uri,
//       });
//     } catch (e) {
//       // Handle the error as desired
//     }
//   }

//   Future<List<SongModel>> getSongs() async {
//     try {
//       final event =
//           await _database.child(ConstantStrings.firebaseDatabasePath).once();
//       final songs = <SongModel>[];
//       if (event.snapshot.value != null) {
//         // event.snapshot.value.forEach((key, value) {
//         //   final song = SongModel(
//         //     acousticness: value['acousticness'],
//         //     albumId: value['album_id'],
//         //     artistsId: value['artists_id'],
//         //     availableMarkets: value['available_markets'],
//         //     clusterLabel: value['cluster_label'],
//         //     country: value['country'],
//         //     id: value['id'],
//         //     lyrics: value['lyrics'],
//         //     name: value['name'],
//         //     playlist: value['playlist'],
//         //     uri: value['uri'],
//         //   );
//         //   songs.add(song);
//         // });
//       }
//       return songs;
//     } catch (e) {
//       return [];
//     }
//   }

//   // Add more methods for updating, deleting, or querying data as needed
// }
