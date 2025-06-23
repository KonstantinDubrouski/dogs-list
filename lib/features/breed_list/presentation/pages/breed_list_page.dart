import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../breed_images/presentation/pages/breed_images_page.dart';
import '../../domain/entities/breed.dart';
import '../bloc/breed_list_bloc.dart';

String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

class BreedListPage extends StatelessWidget {
  const BreedListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog Breeds')),
      body: BlocListener<BreedListBloc, BreedListState>(
        listener: (context, state) {
          if (state.message != null && state.message!.isNotEmpty) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            final controller = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
            controller.closed.then((_) => context.read<BreedListBloc>().add(const BreedListEventClearMessage()));
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _SearchField(),
                const SizedBox(height: 8),
                Expanded(
                  child: BlocBuilder<BreedListBloc, BreedListState>(
                    builder: (context, state) {
                      if (state.status == BreedListStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.status == BreedListStatus.failure) {
                        return Center(child: Text(state.message ?? 'Error', textAlign: TextAlign.center));
                      }
                      final breeds =
                          state.searchQuery.isEmpty ? state.breeds : state.filteredBreeds;
                      if (breeds.isEmpty) {
                        return const Center(child: Text('No breeds'));
                      }
                      return RefreshIndicator(
                        onRefresh: () async =>
                            context.read<BreedListBloc>().add(const BreedListEventRefresh()),
                        child: ListView.builder(
                          itemCount: breeds.length,
                          itemBuilder: (context, index) {
                            final breed = breeds[index];
                            if (breed.subBreeds.isEmpty) {
                              return ListTile(
                                title: Text(_capitalize(breed.name)),
                                onTap: () => _openImages(context, breed),
                              );
                            }
                            return ExpansionTile(
                              title: Text(_capitalize(breed.name)),
                              children: breed.subBreeds
                                  .map((s) => ListTile(
                                        title: Text(_capitalize(s)),
                                        onTap: () => _openImages(context, breed, s),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openImages(BuildContext context, Breed breed, [String? sub]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BreedImagesPage(breed: breed.name, subBreed: sub),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search breed...',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => context.read<BreedListBloc>().add(BreedListEventSearch(value)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
