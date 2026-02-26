/// Address model representing a delivery address
class AddressModel {
  final int id;
  final String street;
  final String city;
  final String? apartment;
  final String? state;
  final String? zipCode;
  final String? country;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final String? label; // e.g., "Home", "Work", "Other"
  final String? phoneNumber;
  final String? recipientName;

  const AddressModel({
    required this.id,
    required this.street,
    required this.city,
    this.apartment,
    this.state,
    this.zipCode,
    this.country,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.label,
    this.phoneNumber,
    this.recipientName,
  });

  AddressModel copyWith({
    int? id,
    String? street,
    String? city,
    String? apartment,
    String? state,
    String? zipCode,
    String? country,
    double? latitude,
    double? longitude,
    bool? isDefault,
    String? label,
    String? phoneNumber,
    String? recipientName,
  }) {
    return AddressModel(
      id: id ?? this.id,
      street: street ?? this.street,
      city: city ?? this.city,
      apartment: apartment ?? this.apartment,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      label: label ?? this.label,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      recipientName: recipientName ?? this.recipientName,
    );
  }

  String get fullAddress {
    final parts = <String>[
      if (apartment != null && apartment!.isNotEmpty) apartment!,
      street,
      city,
      if (state != null && state!.isNotEmpty) state!,
      if (zipCode != null && zipCode!.isNotEmpty) zipCode!,
      if (country != null && country!.isNotEmpty) country!,
    ];
    return parts.join(', ');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'street': street,
        'city': city,
        'apartment': apartment,
        'state': state,
        'zip_code': zipCode,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'is_default': isDefault,
        'label': label,
        'phone_number': phoneNumber,
        'recipient_name': recipientName,
      };

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'] as int,
        street: json['street'] as String,
        city: json['city'] as String,
        apartment: json['apartment'] as String?,
        state: json['state'] as String?,
        zipCode: json['zip_code'] as String? ?? json['zipCode'] as String?,
        country: json['country'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        isDefault: json['is_default'] as bool? ?? json['isDefault'] as bool? ?? false,
        label: json['label'] as String?,
        phoneNumber: json['phone_number'] as String? ?? json['phoneNumber'] as String?,
        recipientName: json['recipient_name'] as String? ?? json['recipientName'] as String?,
      );

  @override
  String toString() {
    return 'AddressModel(id: $id, street: $street, city: $city, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.id == id &&
        other.street == street &&
        other.city == city &&
        other.apartment == apartment;
  }

  @override
  int get hashCode {
    return id.hashCode ^ street.hashCode ^ city.hashCode ^ apartment.hashCode;
  }
}
