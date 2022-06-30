import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/feature/domain/usecases/serch_person.dart';
import 'package:rick_and_morty/feature/presentation/block/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/block/search_bloc/search_state.dart';

import '../../../../core/error/failure.dart';

// class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState>{
//   final SearchPerson searchPerson;
//   PersonSearchBloc({required this.searchPerson}) : super(PersonEmpty());

//   @override
//   Stream <PersonSearchState> mapEventToState(PersonSearchEvent event) async*{
//     if(event is SearchPerson){
//       yield* _mapFetchPersonsToState(event.personQuery);
//     }
//     throw UnimplementedError();
//   }

//   Stream<PersonSearchState?> _mapFetchPersonsToState(String personQuery) async*{
//     yield PersonSearchLoading();

//     final failureOrPerson = await searchPerson(SearchPesonParams(query: personQuery));

//     yield failureOrPerson.fold(
//         (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
//         (person) => PersonSearchLoaded(persons: person));
//   }
//   }

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

// BLoC 8.0.0
class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPersons searchPersons;

  PersonSearchBloc({required this.searchPersons}) : super(PersonSearchEmpty()) {
    on<SearchPersons>(_onEvent);
  }

  FutureOr<void> _onEvent(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading());
    final failureOrPerson =
        await searchPersons(SearchPesonParams(query: event.personQuery));
    emit(failureOrPerson.fold(
        (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        (person) => PersonSearchLoaded(persons: person)));
  }

    String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
