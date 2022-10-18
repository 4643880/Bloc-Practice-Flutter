// ================================================================
// Bloc Starts Here
// ================================================================

import 'package:bloc/bloc.dart';
import 'package:bloc_course_vnd/main.dart';
import 'load_api_event.dart';
import 'load_api_state.dart';

class ApiBloc extends Bloc<LoadActionEvent, FetchResultState?> {
  // Empty Map For Cache
  Map<PersonUrl, List<Person>> cache = {};

  ApiBloc() : super(null) {
    on<LoadPersonsActionOrEvent>((event, emit) async {
      if (cache.containsKey(event.url)) {
        // We have value in the cache
        final cachedResult = cache[event.url];
        final result = FetchResultState(
          persons: cachedResult!,
          isRetrievedFromCache: true,
        );
        emit(result);
        result.log();
      } else {
        final resultOfApi = await getPersonsApi(event.url.urlString);
        // Storing in the Cache
        cache[event.url] = resultOfApi;
        final result = FetchResultState(
          persons: resultOfApi,
          isRetrievedFromCache: false,
        );
        emit(result);
        result.log();
      }
    });
  }
}
