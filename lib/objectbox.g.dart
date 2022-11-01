// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/exchange_rates_for_date.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 3020849200193332495),
      name: 'ExchangeRatesForDate',
      lastPropertyId: const IdUid(2, 4151900817950056397),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2653679360672798748),
            name: 'date',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 4151900817950056397),
            name: 'dbRates',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 3020849200193332495),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    ExchangeRatesForDate: EntityDefinition<ExchangeRatesForDate>(
        model: _entities[0],
        toOneRelations: (ExchangeRatesForDate object) => [],
        toManyRelations: (ExchangeRatesForDate object) => {},
        getId: (ExchangeRatesForDate object) => object.date,
        setId: (ExchangeRatesForDate object, int id) {
          object.date = id;
        },
        objectToFB: (ExchangeRatesForDate object, fb.Builder fbb) {
          final dbRatesOffset =
              object.dbRates == null ? null : fbb.writeString(object.dbRates!);
          fbb.startTable(3);
          fbb.addInt64(0, object.date);
          fbb.addOffset(1, dbRatesOffset);
          fbb.finish(fbb.endTable());
          return object.date;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ExchangeRatesForDate(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0))
            ..dbRates = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 6);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [ExchangeRatesForDate] entity fields to define ObjectBox queries.
class ExchangeRatesForDate_ {
  /// see [ExchangeRatesForDate.date]
  static final date =
      QueryIntegerProperty<ExchangeRatesForDate>(_entities[0].properties[0]);

  /// see [ExchangeRatesForDate.dbRates]
  static final dbRates =
      QueryStringProperty<ExchangeRatesForDate>(_entities[0].properties[1]);
}
