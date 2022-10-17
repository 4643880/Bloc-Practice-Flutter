import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_course_vnd/names_cubit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

const names = [
  'foo',
  'bar',
  'baz',
];

extension RandomElement<String> on Iterable<String> {
  getRandomElement() {
    return elementAt(Random().nextInt(length));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit _cubit;

  @override
  void initState() {
    _cubit = NamesCubit();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(names.getRandomElement().toString()),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _cubit.stream,
          builder: (context, snapshot) {
            final button = ElevatedButton(
                onPressed: () {
                  _cubit.pickRandomName();
                },
                child: const Text("Pick a Random Name"));
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button;
              case ConnectionState.waiting:
                return button;
              case ConnectionState.active:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data ?? '',
                      style: const TextStyle(fontSize: 30),
                    ),
                    button
                  ],
                );
              case ConnectionState.done:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
