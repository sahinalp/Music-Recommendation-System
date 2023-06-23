part of 'song_cubit.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object?> get props => [];
}

class SongInitial extends SongState {}

class RandomSongLoading extends SongState {}

class SongSelection extends SongState {

  const SongSelection({this.selectedSongs = const []});
  final List<SongModel> selectedSongs;

  @override
  List<Object?> get props => [selectedSongs];
}

class SelectedSongLoading extends SongState {

  const SelectedSongLoading({required this.selectedSongs});
  final List<SongModel> selectedSongs;

  @override
  List<Object?> get props => [selectedSongs];
}

class SongLoaded extends SongState {

  const SongLoaded({required this.recommendedSongs});
  final List<SongModel> recommendedSongs;

  @override
  List<Object?> get props => [recommendedSongs];
}

class SongError extends SongState {

  const SongError({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}

class SongSearch extends SongState {}

class SongSearchComplete extends SongState {

  const SongSearchComplete({required this.songs});
  final List<SongModel> songs;

  @override
  List<Object?> get props => [songs];
}
