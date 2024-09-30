// blog_events.dart
abstract class LocaldbEvent {}

class LoadLocaldbEvent extends LocaldbEvent {}

class AddLocaldbEvent extends LocaldbEvent {
  final String title;
  AddLocaldbEvent(this.title);
}

