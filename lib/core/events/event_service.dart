import 'package:flutter/cupertino.dart';
import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/events/models/start_event.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class EventService extends ChangeNotifier {
  final BehaviorSubject<IEvent> _behaviorSubject = BehaviorSubject();

  EventService() {
    dispatch(StartEvent());
  }

  Stream<IEvent> getGlobalEventStream() {
    return getEventStream("global");
  }

  Stream<IEvent> getEventStream(String audience) => _behaviorSubject.stream
    .where(
      (event) => event.audience == audience,
    );

  void dispatch(IEvent event) {
    Logger().i(event);
    _behaviorSubject.add(event);
  }
}
