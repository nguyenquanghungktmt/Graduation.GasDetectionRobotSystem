class Device {
  late String serialNumber;
  late String modelName;
  late String deviceStatus;
  late String? imageUrl;
  late String description;

  Device({
    required this.serialNumber,
    required this.modelName,
    required this.deviceStatus,
    this.imageUrl,
    required this.description,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      serialNumber: json['serial_number'] ?? "",
      modelName: json['model_name'] ?? "",
      deviceStatus: json['device_status'] ?? "",
      description: json['description'] ?? "",
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, Object?> toJson() => {
    'serial_number': serialNumber,
    'model_name': modelName,
    'device_status': deviceStatus,
    'description': description,
    'imageUrl': imageUrl
  };

}
