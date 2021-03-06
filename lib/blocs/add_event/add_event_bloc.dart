import 'package:rxdart/rxdart.dart';
import 'package:events_app/blocs/bloc_provider.dart';
import 'package:events_app/models/event.dart';
class AddEventBloc extends BlocBase{
  final BehaviorSubject<bool> _descriptionSubject = BehaviorSubject.seeded(false);
  Observable<bool> get hasDescription => _descriptionSubject.stream;

  final BehaviorSubject<bool> _checklistSubject = BehaviorSubject.seeded(false);
  Observable<bool> get hasChecklist => _checklistSubject.stream;

  final BehaviorSubject<bool> _locationSubject = BehaviorSubject.seeded(false);
  Observable<bool> get hasLocation => _locationSubject.stream;

  final PublishSubject<DateTime> _dateSubject =PublishSubject<DateTime>();
  Observable<DateTime> get eventDate => _dateSubject.stream;

  final PublishSubject<String> _imageSubject = PublishSubject<String>();
  Observable<String> get eventImage => _imageSubject.stream;

  void changeDescription(final bool status) => _descriptionSubject.sink.add(status);
  void changeChecklist(final bool status) => _checklistSubject.sink.add(status);
  void changeLocation(final bool status) => _locationSubject.sink.add(status);
  void changeEventDate(final DateTime date) => _dateSubject.sink.add(date);
  void changeEventImage(final String image) => _imageSubject.sink.add(image);
  
  void initEvent(Event event){
    if (event.description != null && event.description.trim().isNotEmpty) {
      changeDescription(true);
    }
    changeLocation(event.hasLocation);
    changeEventImage(event.image);
    changeEventDate(event.date);
  }
  @override
  dispose(){
    _checklistSubject?.close();
    _locationSubject?.close();
    _descriptionSubject?.close();
    _dateSubject?.close();
    _imageSubject?.close();
  }
}