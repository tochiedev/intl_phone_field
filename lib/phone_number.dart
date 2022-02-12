class PhoneNumber {
  String countryISOCode;
  String countryCode;
  String number;
  String country;

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
    required this.country,
  });

  String get completeNumber {
    return countryCode + number;
  }

  String toString() => 'PhoneNumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number)';
}
