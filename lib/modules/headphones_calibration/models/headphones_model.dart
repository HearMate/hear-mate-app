class HeadphonesModel {
  final String name;
  final String manufacturer;

  const HeadphonesModel({required this.name, required this.manufacturer});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeadphonesModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          manufacturer == other.manufacturer;

  @override
  int get hashCode => name.hashCode ^ manufacturer.hashCode;
}
