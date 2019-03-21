import 'package:events_app/models/models.dart';

class GetEvents{
  List<Event> fetchEvents(){
    return [
      new Event('Rome', DateTime.now()),
      new Event('Croatie', DateTime.now()),
      new Event('Rome', DateTime.now()),
      new Event('Croatie', DateTime.now()),
      new Event('Rome', DateTime.now()),
      new Event('Croatie', DateTime.now()),
      new Event('Rome', DateTime.now()),
      new Event('Croatie', DateTime.now()),
      new Event('Rome', DateTime.now()),
      new Event('Croatie', DateTime.now()),
      new Event('Rome', DateTime.now()),
      new Event('Croatie', DateTime.now())
    ];
  } 

  List<Event> fetchEmptyEvents(){
    return [];
  }
}