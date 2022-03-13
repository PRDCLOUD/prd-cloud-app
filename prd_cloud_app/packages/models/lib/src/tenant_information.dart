import 'package:equatable/equatable.dart';
import 'package:timezone/timezone.dart' as tz;

class TenantInformation extends Equatable {

  final String language;
  final String lossGeneralCurrency;
  final String lossGeneralUnit;
  final List<String> lossGridOptions;
  final String timeZone;

  tz.Location? _location;
  tz.Location get location {
    if (_location == null) {
      _location = tz.getLocation(timeZone);
    }
    return _location!;
  }

  TenantInformation({ required this.language, required  this.lossGeneralCurrency, required  this.lossGeneralUnit, required  this.lossGridOptions, required  this.timeZone });

  factory TenantInformation.fromJson(Map<String, dynamic> json) {
    return TenantInformation(
      language: json['language'], 
      lossGeneralCurrency: json['lossGeneralCurrency'], 
      lossGeneralUnit: json['lossGeneralUnit'], 
      lossGridOptions: List<String>.from(json['lossGridOptions']), 
      timeZone: json['timeZone']);
  }

  @override
  List<Object> get props => [language, lossGeneralCurrency, lossGeneralUnit, lossGridOptions, timeZone];

  TenantInformation copyWith({
    String? language,
    String? lossGeneralCurrency,
    String? lossGeneralUnit,
    List<String>? lossGridOptions,
    String? timeZone,
  }) {
    return TenantInformation(
      language: language ?? this.language,
      lossGeneralCurrency: lossGeneralCurrency ?? this.lossGeneralCurrency,
      lossGeneralUnit: lossGeneralUnit ?? this.lossGeneralUnit,
      lossGridOptions: lossGridOptions ?? this.lossGridOptions,
      timeZone: timeZone ?? this.timeZone,
    );
  }
}
