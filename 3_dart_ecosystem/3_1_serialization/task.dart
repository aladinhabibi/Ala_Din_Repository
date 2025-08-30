import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:toml/toml.dart';

class PublicTariff {
  final int id;
  final int price;
  final String duration;
  final String description;

  PublicTariff({
    required this.id,
    required this.price,
    required this.duration,
    required this.description,
  });

  factory PublicTariff.fromJson(Map<String, dynamic> json) {
    return PublicTariff(
      id: json['id'] as int,
      price: json['price'] as int,
      duration: json['duration'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'duration': duration,
        'description': description,
      };
}

class PrivateTariff {
  final int clientPrice;
  final String duration;
  final String description;

  PrivateTariff({
    required this.clientPrice,
    required this.duration,
    required this.description,
  });

  factory PrivateTariff.fromJson(Map<String, dynamic> json) {
    return PrivateTariff(
      clientPrice: json['client_price'] as int,
      duration: json['duration'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'client_price': clientPrice,
        'duration': duration,
        'description': description,
      };
}

class Stream {
  final String userId;
  final bool isPrivate;
  final int settings;
  final String shardUrl;
  final PublicTariff publicTariff;
  final PrivateTariff privateTariff;

  Stream({
    required this.userId,
    required this.isPrivate,
    required this.settings,
    required this.shardUrl,
    required this.publicTariff,
    required this.privateTariff,
  });

  factory Stream.fromJson(Map<String, dynamic> json) {
    return Stream(
      userId: json['user_id'] as String,
      isPrivate: json['is_private'] as bool,
      settings: json['settings'] as int,
      shardUrl: json['shard_url'] as String,
      publicTariff:
          PublicTariff.fromJson(json['public_tariff'] as Map<String, dynamic>),
      privateTariff: PrivateTariff.fromJson(
          json['private_tariff'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'is_private': isPrivate,
        'settings': settings,
        'shard_url': shardUrl,
        'public_tariff': publicTariff.toJson(),
        'private_tariff': privateTariff.toJson(),
      };
}

class Gift {
  final int id;
  final int price;
  final String description;

  Gift({
    required this.id,
    required this.price,
    required this.description,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'] as int,
      price: json['price'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'description': description,
      };
}

class Debug {
  final String duration;
  final DateTime at;

  Debug({
    required this.duration,
    required this.at,
  });

  factory Debug.fromJson(Map<String, dynamic> json) {
    return Debug(
      duration: json['duration'] as String,
      at: DateTime.parse(json['at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'at': at.toIso8601String(),
      };
}

class Request {
  final String type;
  final Stream stream;
  final List<Gift> gifts;
  final Debug debug;

  Request({
    required this.type,
    required this.stream,
    required this.gifts,
    required this.debug,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      type: json['type'] as String,
      stream: Stream.fromJson(json['stream'] as Map<String, dynamic>),
      gifts: (json['gifts'] as List<dynamic>)
          .map((giftJson) => Gift.fromJson(giftJson as Map<String, dynamic>))
          .toList(),
      debug: Debug.fromJson(json['debug'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'stream': stream.toJson(),
        'gifts': gifts.map((gift) => gift.toJson()).toList(),
        'debug': debug.toJson(),
      };
}

void main() async {
  // Read and deserialize the JSON file
  final file = File('request.json');
  final jsonString = await file.readAsString();
  final jsonData = json.decode(jsonString) as Map<String, dynamic>;

  // Deserialize into Request object
  final request = Request.fromJson(jsonData);

  // Convert back to Map for serialization
  final requestMap = request.toJson();

  // Print YAML format
  print('YAML Format:');
  print('---');
  final yamlString = _mapToYaml(requestMap);
  print(yamlString);

  print('\n' + '=' * 50 + '\n');

  // Print TOML format
  print('TOML Format:');
  final tomlString = TomlDocument.fromMap(requestMap).toString();
  print(tomlString);
}

String _mapToYaml(Map<String, dynamic> map, [int indent = 0]) {
  final buffer = StringBuffer();
  final spaces = '  ' * indent;

  map.forEach((key, value) {
    buffer.write('$spaces$key: ');
    if (value is Map<String, dynamic>) {
      buffer.writeln();
      buffer.write(_mapToYaml(value, indent + 1));
    } else if (value is List) {
      buffer.writeln();
      for (final item in value) {
        buffer.write('$spaces- ');
        if (item is Map<String, dynamic>) {
          buffer.writeln();
          buffer.write(_mapToYaml(item, indent + 1));
        } else {
          buffer.writeln(item);
        }
      }
    } else if (value is String) {
      buffer.writeln('"$value"');
    } else {
      buffer.writeln(value);
    }
  });

  return buffer.toString();
}
