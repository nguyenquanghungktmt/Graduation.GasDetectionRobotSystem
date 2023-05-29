import 'dart:ffi';

class Room {
  late String roomId;
  late String roomName;
  late String ownerUUID;
  late int isGasDetect;
  late String roomStatus;
  late String? map2dUrl;

  Room({
    required this.roomId, 
    required this.roomName, 
    required this.ownerUUID, 
    required this.isGasDetect, 
    required this.roomStatus,
    this.map2dUrl,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['room_id'] ?? "",
      roomName: json['room_name'] ?? "",
      ownerUUID: json['owner_uuid'] ?? "",
      isGasDetect: json['is_gas_detect'] ?? 0,
      roomStatus: json['room_status'] ?? "",
      map2dUrl: json['map2d_url'],
    );
  }

  Map<String, Object?> toJson() => {
    'room_id': roomId,
    'room_name': roomName,
    'owner_uuid': ownerUUID,
    'is_gas_detect': isGasDetect,
    'room_status': roomStatus,
    'map2d_url': map2dUrl
  };
}
