import 'package:equatable/equatable.dart';

class TenantInformation extends Equatable {

  final String language;
  final String lossGeneralCurrency;
  final String lossGeneralUnit;
  final List<String> lossGridOptions;
  final String timeZone;

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
}