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

class EnumTargetHelper{
  static Target parse(String value) {
    switch (value) {
      case 'general':
        return Target.general;
      case 'room':
        return Target.room;
      default:
        return Target.general;
    }
  }
}