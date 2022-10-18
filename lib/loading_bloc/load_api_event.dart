// ================================================================
// Events Starts Here
// ================================================================
import 'package:bloc_course_vnd/main.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoadActionEvent {
  const LoadActionEvent();
}

class LoadPersonsActionOrEvent extends LoadActionEvent {
  final PersonUrl url;

  const LoadPersonsActionOrEvent({required this.url});
}
