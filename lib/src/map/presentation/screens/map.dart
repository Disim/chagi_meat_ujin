import 'package:chagi_meat_ujin/src/map/domain/cubit/map_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static const routeName = '/map';

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapPageCubit(),
      child: Text('data'),
    );
  }
}
