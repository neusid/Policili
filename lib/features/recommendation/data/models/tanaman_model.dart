import '../../domain/entities/tanaman_entity.dart';

class TanamanModel extends TanamanEntity {
  const TanamanModel({
    required super.idTanaman,
    required super.name,
    required super.kelebihan,
    required super.url,
  });

  factory TanamanModel.fromJson(Map<String, dynamic> json) => TanamanModel(
        idTanaman: json["id_tanaman"] ?? 0,
        name: json["name"] ?? '',
        kelebihan: json["kelebihan"] ?? '',
        url: json["url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id_tanaman": idTanaman,
        "name": name,
        "kelebihan": kelebihan,
        "url": url,
      };
}
