enum Target {
  general,
  room,
  map
}

extension TargetExtension on Target {
  String get value {
    switch (this) {
      case Target.general:
        return 'general';
      case Target.room:
        return 'room';
      case Target.map:
        return 'map';
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
      case 'map':
        return Target.map;
      default:
        return Target.general;
    }
  }
}