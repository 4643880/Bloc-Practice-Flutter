// ================================================================
// State Starts Here
// ================================================================

import 'package:bloc_course_vnd/main.dart';
import 'package:flutter/material.dart';

@immutable
class FetchResultState {
  final List<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResultState({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      "isRetrievedFromCache : $isRetrievedFromCache, persons: $persons";
}
