import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/breed_images_bloc.dart';
import '../../domain/usecases/get_breed_images.dart';
import '../../data/repositories/breed_images_repository_impl.dart';
import '../../data/datasources/breed_images_remote_data_source.dart';
import '../../../../core/network/simple_dio.dart';
import 'image_full_screen_page.dart';

String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

class BreedImagesPage extends StatelessWidget {
  final String breed;
  final String? subBreed;
  const BreedImagesPage({super.key, required this.breed, this.subBreed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BreedImagesBloc(
        getImages: GetBreedImages(
          BreedImagesRepositoryImpl(
            remote: BreedImagesRemoteDataSource(dio: createDio()),
          ),
        ),
      )
        ..add(BreedImagesEventLoad(breed: breed, subBreed: subBreed)),
      child: Scaffold(
        appBar: AppBar(title: Text(subBreed == null ? _capitalize(breed) : '${_capitalize(breed)} ${_capitalize(subBreed!)}')),
        body: const _BreedImagesView(),
      ),
    );
  }
}

class _BreedImagesView extends StatefulWidget {
  const _BreedImagesView();

  @override
  State<_BreedImagesView> createState() => _BreedImagesViewState();
}

class _BreedImagesViewState extends State<_BreedImagesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BreedImagesBloc, BreedImagesState>(
      builder: (context, state) {
        if (state.status == BreedImagesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == BreedImagesStatus.failure) {
          return Center(child: Text(state.message ?? 'Error', textAlign: TextAlign.center));
        }
        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: state.images.length,
          itemBuilder: (context, index) {
            final url = state.images[index];
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ImageFullScreenPage(imageUrl: url),
                ),
              ),
              child: Image.network(url, fit: BoxFit.cover),
            );
          },
        );
      },
    );
  }
}
