part of 'tenant_information_cubit.dart';

@immutable
abstract class TenantInformationState extends Equatable {

  @override
  List<Object> get props => [];
}

class TenantInformationUnloaded extends TenantInformationState {}

class TenantInformationLoading extends TenantInformationState {}

class TenantInformationLoaded extends TenantInformationState {

  final TenantInformation tenantInformation;

  TenantInformationLoaded({ required this.tenantInformation });

  @override
  List<Object> get props => [tenantInformation];
}