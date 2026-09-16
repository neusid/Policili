import 'package:equatable/equatable.dart';

class TanamanEntity extends Equatable {
  final int idTanaman;
  final String name;
  final String kelebihan;
  final String url;

  const TanamanEntity({
    required this.idTanaman,
    required this.name,
    required this.kelebihan,
    required this.url,
  });

  @override
  List<Object?> get props => [idTanaman, name, kelebihan, url];
}
