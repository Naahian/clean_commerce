class ShippingInfo {
  final String name;
  final String phone;
  final String address;

  const ShippingInfo({
    required this.name,
    required this.phone,
    required this.address,
  });

  factory ShippingInfo.defaultInfo() {
    return const ShippingInfo(
      name: 'John Doe',
      phone: '+1 234 567 8900',
      address: '123 Main Street, New York',
    );
  }

  ShippingInfo copyWith({String? name, String? phone, String? address}) {
    return ShippingInfo(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  toJson() {
    return {'name': name, 'phone': phone, 'address': address};
  }
}
