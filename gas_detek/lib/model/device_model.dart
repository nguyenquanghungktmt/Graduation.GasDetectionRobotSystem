class Device {
  late String serialNumber;
  late String moduleId;
  late String modelName;
  late String deviceStatus;
  late String? imageUrl;
  late String description;

  Device({
    required this.serialNumber,
    required this.moduleId,
    required this.modelName,
    required this.deviceStatus,
    this.imageUrl,
    required this.description,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      serialNumber: json['serial_number'] ?? "",
      moduleId: json['module_id'] ?? "",
      modelName: json['model_name'] ?? "",
      deviceStatus: json['device_status'] ?? "",
      description: json['description'] ?? "",
      imageUrl: json['image_url'],
    );
  }

  Map<String, Object?> toJson() => {
    'serial_number': serialNumber,
    'module_id': moduleId,
    'model_name': modelName,
    'device_status': deviceStatus,
    'description': description,
    'image_url': imageUrl
  };

}
