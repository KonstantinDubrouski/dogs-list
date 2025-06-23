import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/get_breed_images.dart';

part 'breed_images_event.dart';
part 'breed_images_state.dart';

class BreedImagesBloc extends Bloc<BreedImagesEvent, BreedImagesState> {
  final GetBreedImages getImages;
  BreedImagesBloc({required this.getImages}) : super(BreedImagesState.initial()) {
    on<BreedImagesEventLoad>(_onLoad);
  }

  Future<void> _onLoad(BreedImagesEventLoad event, Emitter<BreedImagesState> emit) async {
    emit(state.copyWith(status: BreedImagesStatus.loading));
    try {
      final images = await getImages(breed: event.breed, subBreed: event.subBreed);
      // Convert from entity to plain url list
      final urls = images.map((e) => e.url).toList();
      emit(state.copyWith(status: BreedImagesStatus.success, images: urls));
    } catch (e) {
      emit(state.copyWith(status: BreedImagesStatus.failure, message: 'Failed to load images. Check your internet connection.'));
    }
  }
}
