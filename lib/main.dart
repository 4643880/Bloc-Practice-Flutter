import 'dart:convert';
import 'dart:io';
import 'package:bloc_course_vnd/loading_bloc/load_api_bloc.dart';
import 'package:bloc_course_vnd/loading_bloc/load_api_event.dart';
import 'package:bloc_course_vnd/loading_bloc/load_api_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApiBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

// ================================================================
// Model Starts Here
// ================================================================
@immutable
class Person {
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => "Name: $name, Age: $age";
}

// ================================================================
// Model Ends Here
// ================================================================

enum PersonUrl { person1, person2 }

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return "http://192.168.26.180:5500/lib/api/person1.json";
      case PersonUrl.person2:
        return "http://192.168.26.180:5500/lib/api/person2.json";
    }
  }
}

Future<List<Person>> getPersonsApi(String url) {
  url.log();
  final result = HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((res) => res.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>)
      .then((json) => json.map((e) => Person.fromJson(e)).toList());
  return result;
}

// extension Subscript<Person> on Iterable<Person> {
//   Person? operator [](int index) => length > index ? elementAt(index) : null;
// }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final a = PersonUrl.person1.urlString;
    a.log();
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ApiBloc, FetchResultState?>(
          builder: (context, state) {
            return Text("Loaded From Cache: ${state?.isRetrievedFromCache}");
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.read<ApiBloc>().add(
                            const LoadPersonsActionOrEvent(
                              url: PersonUrl.person1,
                            ),
                          );
                    },
                    child: const Text("Load Json 1")),
                const SizedBox(
                  height: 20,
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<ApiBloc>().add(
                          const LoadPersonsActionOrEvent(
                            url: PersonUrl.person2,
                          ),
                        );
                  },
                  child: const Text("Load Json 2"),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<ApiBloc, FetchResultState?>(
                buildWhen: (previousResult, currentResult) {
                  return previousResult?.persons != currentResult?.persons;
                },
                builder: (context, state) {
                  final result = state?.persons;

                  if (result == null) {
                    return const SizedBox();
                  }
                  return ListView.builder(
                    itemCount: state?.persons.length,
                    itemBuilder: (context, index) {
                      final result = state?.persons;
                      return ListTile(
                        title: Text(result?[index].name ?? ""),
                        subtitle: Text(result?[index].age.toString() ?? ""),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// extension Subscript<T> on Iterable<T> {
//   T? operator [](int index) => length > index ? elementAt(index) : null;
// }




// ==================================================
// Practice of Extensions in Dart
// ==================================================
// Both int and double extennds num class
// as list and map extends iterable

// extension IntExtension on int {
//   int addTen() => this + 10;
// }

// extension DoubleExtension on double {
//   double addTen() => this + 10;
// }

// extension Bravo on num {
//   num addTen() => this + 10;
// }

// int g = 10.addTen();
// int h = 10.22.addTen();
// print(g);
// print(h);
