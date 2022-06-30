import 'dart:convert';
import 'package:rick_and_morty/core/error/exception.dart';
import 'package:rick_and_morty/feature/data/models/person_model.dart';
import 'package:rick_and_morty/feature/domain/usecases/get_all_persons.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class PersonRemoteDataSource {
  Future <List<PersonModel>> getAllPersons(int page);
  Future <List<PersonModel>> searchPerson(String query);

}
//"https://rickandmortyapi.com/api/character/?page=$page"
//"https://rickandmortyapi.com/api/character/?name=$query"
//https://rickandmortyapi.com/api/character
class PersonRemoteDataSourceImpl implements PersonRemoteDataSource{
  final http.Client client;
  PersonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPersons(int page) => _getPersonFromUrl(
    "https://rickandmortyapi.com/api/character/?page=$page");

  @override
  Future<List<PersonModel>> searchPerson(String query) => _getPersonFromUrl(
    "https://rickandmortyapi.com/api/character/?name=$query");

  Future<List<PersonModel>> _getPersonFromUrl(String url) async{
    print(url);
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-type':'application/json'});
    if(response.statusCode == 200){
      final person = json.decode(response.body);
      return (person['results'] as List).map((person) => PersonModel.fromJson(person)).toList();
    }else{
    throw ServerException();
    }
  }
}
