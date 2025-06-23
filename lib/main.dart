import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/network/simple_dio.dart';
import 'features/breed_list/data/datasources/breed_local_data_source.dart';
import 'features/breed_list/data/datasources/breed_remote_data_source.dart';
import 'features/breed_list/data/repositories/breed_repository_impl.dart';
import 'features/breed_list/domain/repositories/breed_repository.dart';
import 'features/breed_list/domain/usecases/get_all_breeds.dart';
import 'features/breed_list/presentation/bloc/breed_list_bloc.dart';
import 'features/breed_list/presentation/pages/breed_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Open Hive box for breeds caching
  await BreedLocalDataSource.initHive();

  final dio = createDio();

  final BreedRepository breedRepository = BreedRepositoryImpl(
    remote: BreedRemoteDataSource(dio: dio),
    local: BreedLocalDataSource(),
  );

  runApp(MyApp(breedRepository: breedRepository));
}

class MyApp extends StatelessWidget {
  final BreedRepository breedRepository;
  const MyApp({super.key, required this.breedRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: breedRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => BreedListBloc(
              getAllBreeds: GetAllBreeds(breedRepository),
            )..add(const BreedListEventLoad()),
          ),
        ],
        child: MaterialApp(
          title: 'Dog Breeds',
          theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
          home: const BreedListPage(),
        ),
      ),
    );
  }
}
