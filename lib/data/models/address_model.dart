import 'dart:convert';

class AddressModel {
  String? street;
  String? number;
  String? complement;
  String? district;
  String? zipCode;
  String? city;
  String? state;
  double? lat;
  double? long;

  AddressModel({
    this.zipCode,
    this.street,
    this.number,
    this.complement,
    this.district,
    this.state,
    this.city,
    this.lat,
    this.long,
  });

  @override
  String toString() {
    return 'Address(street: $street, number: $number, complement: $complement, district: $district, zipCode: $zipCode, city: $city, state: $state, lat: $lat, long: $long)';
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'district': district,
      'zipCode': zipCode,
      'city': city,
      'state': state,
      'lat': lat,
      'long': long,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      street: map['street'],
      number: map['number'],
      complement: map['complement'],
      district: map['district'],
      zipCode: map['zipCode'],
      city: map['city'],
      state: map['state'],
      lat: map['lat']?.toDouble(),
      long: map['long']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) => AddressModel.fromMap(json.decode(source));
}
