import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_by_mood/constant/constants.dart';
import 'package:music_by_mood/model/song_model.dart';
import 'package:music_by_mood/service/song_repository.dart';

part 'song_state.dart';

class SongCubit extends Cubit<SongState> {

  SongCubit() : super(SongInitial());
  final SongRepository _songRepository = SongRepository.instance;

  List<SongModel> randomSongs = [];
  List<SongModel> selectedSongs = [];

  Future<void> initialize() async {
    // TODO: Fix Taste Profile
    // final prefs = await SharedPreferences.getInstance();
    _songRepository.connection.isClosed ? await _songRepository.connection.open() : null;
    //final tables = await _songRepository.connection.query("select * from \"MusicRecommendation\".\"database\" d \n");
    // List<String>? tasteProfile = prefs.getStringList('tasteProfile');
    // if (tasteProfile != null && tasteProfile.length == 5) {
    //   loadRecommendedSongs(tasteProfile.toList());
    // } else {
    randomSongs = await getRandomSong();
    selectedSongs.clear();
    emit(const SongSelection(selectedSongs: []));
    //}
  }

  // @override
  // Future<void> close() async {
  //   _songRepository.connection.isClosed?null:
  //   await _songRepository.connection.close();
  //   super.close();
  // }

  Future<void> refreshRandomSongs() async {
    emit(RandomSongLoading());
    randomSongs = await getRandomSong().then((songs) {
      emit(SongSelection(selectedSongs: selectedSongs));
      return songs;
    });
  }

  void selectSong(SongModel song) async {
    if (selectedSongs.any((element) => element.id == song.id)) {
      return;
    }
    if (state is SongSelection) {
      selectedSongs = (state as SongSelection).selectedSongs.toList();
      selectedSongs.add(song);

      if (selectedSongs.length < 5) {
        emit(RandomSongLoading());
        randomSongs = await getRandomSong();
        emit(SongSelection(selectedSongs: selectedSongs));
      } else {
        emit(SelectedSongLoading(selectedSongs: selectedSongs));
      }
    }
    if (state is SongSearchComplete) {
      (state as SongSearchComplete).songs.removeWhere((element) => element.id == song.id);
      List<SongModel> songs = (state as SongSearchComplete).songs;
      emit(SongSearch());

      selectedSongs.add(song);

      if (selectedSongs.length < 5) {
        emit(SongSearchComplete(songs: songs));
      } else {
        emit(SelectedSongLoading(selectedSongs: selectedSongs));
      }
    }
  }

  Future<void> loadRecommendedSongs(List<String> clusterLabels) async {
    // TODO: Fix Taste Profile
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String>? tasteProfile = prefs.getStringList('tasteProfile');
    // if (tasteProfile != null) {
    //   for (int i = 0; i < tasteProfile.length; i++) {
    //     clusterLabels[i] = tasteProfile[i];
    //   }
    //   prefs.setStringList('tasteProfile', clusterLabels.toList());
    // }

    try {
      final recommendedSongs = await _songRepository.getRecommendedSongs(clusterLabels);

      emit(SongLoaded(recommendedSongs: recommendedSongs));
    } catch (error) {
      emit(const SongError(error: 'Failed to load recommended songs.'));
    }
  }

  void recommendNewSongs() {
    if (state is SongLoaded) {
      final recommendedSongs = (state as SongLoaded).recommendedSongs;
      final List<SongModel> newSongs = [];

      for (var i = 0; i < 10; i++) {
        final randomIndex = Random().nextInt(recommendedSongs.length);
        newSongs.add(recommendedSongs[randomIndex]);
      }

      emit(SongLoaded(recommendedSongs: newSongs));
    }
  }

  Future<List<SongModel>> getRandomSong() async {
    List<SongModel> songs = [];
    for (var i = 0; i < 5; i++) {
      final random = Random();
      int songIndex = random.nextInt(ConstantNumbers.firabaseDatabaseSize);
      songIndex == 0 ? songIndex = 1 : songIndex;
      final randomSong = await _songRepository.getRandomSong(songIndex);
      songs.add(randomSong);
    }
    return songs;
  }

  Future<List<SongModel>> search(String query) async {
    if (state is SongSelection) {
      selectedSongs = (state as SongSelection).selectedSongs.toList();
    }
    emit(SongSearch());
    final songs = await _songRepository.search(query);
    songs.removeWhere((song) => selectedSongs.where((element) => element.id == song.id).isNotEmpty);
    emit(SongSearchComplete(songs: songs));
    return songs;
  }
}
