enum Target {
  general,
  room
}

extension TargetExtension on Target {
  String get value {
    switch (this) {
      case Target.general:
        return 'general';
      case Target.room:
        return 'room';
      default:
        return 'general';
    }
  }
}