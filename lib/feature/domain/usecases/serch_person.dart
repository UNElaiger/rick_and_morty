import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/core/usecases/usecases.dart';
import 'package:rick_and_morty/feature/domain/repositories/person_repository.dart';
import '../../../core/error/failure.dart';
import '../entities/person_entity.dart';

class SearchPeson extends UseCase<List<PersonEntity>,SearchPesonParams>{
  final PersonRepository personRepository;

  SearchPeson(this.personRepository);

  Future<Either<Failure,List<PersonEntity>>> call(SearchPesonParams params) async {
    return await personRepository.searchPerson(params.query);
  }
}

class SearchPesonParams extends Equatable{
  final String query;

  SearchPesonParams({required this.query});

  @override
  List<Object?> get props => [query];
}