// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#FF6B35'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('utensils'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, color, icon, sortOrder, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String color;
  final String icon;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  const Category(
      {required this.id,
      required this.name,
      required this.color,
      required this.icon,
      required this.sortOrder,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['icon'] = Variable<String>(icon);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      icon: Value(icon),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      icon: serializer.fromJson<String>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'icon': serializer.toJson<String>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          String? color,
          String? icon,
          int? sortOrder,
          bool? isActive,
          DateTime? createdAt}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        icon: icon ?? this.icon,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, color, icon, sortOrder, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  final Value<String> icon;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? color,
      Value<String>? icon,
      Value<int>? sortOrder,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceInPaisaMeta =
      const VerificationMeta('priceInPaisa');
  @override
  late final GeneratedColumn<int> priceInPaisa = GeneratedColumn<int>(
      'price_in_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isAvailableMeta =
      const VerificationMeta('isAvailable');
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
      'is_available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_available" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDealMeta = const VerificationMeta('isDeal');
  @override
  late final GeneratedColumn<bool> isDeal = GeneratedColumn<bool>(
      'is_deal', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deal" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        priceInPaisa,
        categoryId,
        imagePath,
        isAvailable,
        isDeal,
        sortOrder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('price_in_paisa')) {
      context.handle(
          _priceInPaisaMeta,
          priceInPaisa.isAcceptableOrUnknown(
              data['price_in_paisa']!, _priceInPaisaMeta));
    } else if (isInserting) {
      context.missing(_priceInPaisaMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
    }
    if (data.containsKey('is_deal')) {
      context.handle(_isDealMeta,
          isDeal.isAcceptableOrUnknown(data['is_deal']!, _isDealMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      priceInPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_in_paisa'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      isDeal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deal'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String? description;
  final int priceInPaisa;
  final int categoryId;
  final String? imagePath;
  final bool isAvailable;
  final bool isDeal;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product(
      {required this.id,
      required this.name,
      this.description,
      required this.priceInPaisa,
      required this.categoryId,
      this.imagePath,
      required this.isAvailable,
      required this.isDeal,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price_in_paisa'] = Variable<int>(priceInPaisa);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['is_available'] = Variable<bool>(isAvailable);
    map['is_deal'] = Variable<bool>(isDeal);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      priceInPaisa: Value(priceInPaisa),
      categoryId: Value(categoryId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      isAvailable: Value(isAvailable),
      isDeal: Value(isDeal),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      priceInPaisa: serializer.fromJson<int>(json['priceInPaisa']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      isDeal: serializer.fromJson<bool>(json['isDeal']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'priceInPaisa': serializer.toJson<int>(priceInPaisa),
      'categoryId': serializer.toJson<int>(categoryId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'isDeal': serializer.toJson<bool>(isDeal),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          int? priceInPaisa,
          int? categoryId,
          Value<String?> imagePath = const Value.absent(),
          bool? isAvailable,
          bool? isDeal,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        priceInPaisa: priceInPaisa ?? this.priceInPaisa,
        categoryId: categoryId ?? this.categoryId,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        isAvailable: isAvailable ?? this.isAvailable,
        isDeal: isDeal ?? this.isDeal,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      priceInPaisa: data.priceInPaisa.present
          ? data.priceInPaisa.value
          : this.priceInPaisa,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      isDeal: data.isDeal.present ? data.isDeal.value : this.isDeal,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priceInPaisa: $priceInPaisa, ')
          ..write('categoryId: $categoryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isDeal: $isDeal, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      priceInPaisa,
      categoryId,
      imagePath,
      isAvailable,
      isDeal,
      sortOrder,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.priceInPaisa == this.priceInPaisa &&
          other.categoryId == this.categoryId &&
          other.imagePath == this.imagePath &&
          other.isAvailable == this.isAvailable &&
          other.isDeal == this.isDeal &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> priceInPaisa;
  final Value<int> categoryId;
  final Value<String?> imagePath;
  final Value<bool> isAvailable;
  final Value<bool> isDeal;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.priceInPaisa = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isDeal = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int priceInPaisa,
    required int categoryId,
    this.imagePath = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isDeal = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        priceInPaisa = Value(priceInPaisa),
        categoryId = Value(categoryId);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? priceInPaisa,
    Expression<int>? categoryId,
    Expression<String>? imagePath,
    Expression<bool>? isAvailable,
    Expression<bool>? isDeal,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (priceInPaisa != null) 'price_in_paisa': priceInPaisa,
      if (categoryId != null) 'category_id': categoryId,
      if (imagePath != null) 'image_path': imagePath,
      if (isAvailable != null) 'is_available': isAvailable,
      if (isDeal != null) 'is_deal': isDeal,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? priceInPaisa,
      Value<int>? categoryId,
      Value<String?>? imagePath,
      Value<bool>? isAvailable,
      Value<bool>? isDeal,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priceInPaisa: priceInPaisa ?? this.priceInPaisa,
      categoryId: categoryId ?? this.categoryId,
      imagePath: imagePath ?? this.imagePath,
      isAvailable: isAvailable ?? this.isAvailable,
      isDeal: isDeal ?? this.isDeal,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priceInPaisa.present) {
      map['price_in_paisa'] = Variable<int>(priceInPaisa.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (isDeal.present) {
      map['is_deal'] = Variable<bool>(isDeal.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priceInPaisa: $priceInPaisa, ')
          ..write('categoryId: $categoryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isDeal: $isDeal, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductVariantsTable extends ProductVariants
    with TableInfo<$ProductVariantsTable, ProductVariant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES products (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _priceInPaisaMeta =
      const VerificationMeta('priceInPaisa');
  @override
  late final GeneratedColumn<int> priceInPaisa = GeneratedColumn<int>(
      'price_in_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isAvailableMeta =
      const VerificationMeta('isAvailable');
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
      'is_available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_available" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, name, priceInPaisa, isAvailable, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_variants';
  @override
  VerificationContext validateIntegrity(Insertable<ProductVariant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price_in_paisa')) {
      context.handle(
          _priceInPaisaMeta,
          priceInPaisa.isAcceptableOrUnknown(
              data['price_in_paisa']!, _priceInPaisaMeta));
    } else if (isInserting) {
      context.missing(_priceInPaisaMeta);
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductVariant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductVariant(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      priceInPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_in_paisa'])!,
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $ProductVariantsTable createAlias(String alias) {
    return $ProductVariantsTable(attachedDatabase, alias);
  }
}

class ProductVariant extends DataClass implements Insertable<ProductVariant> {
  final int id;
  final int productId;
  final String name;
  final int priceInPaisa;
  final bool isAvailable;
  final int sortOrder;
  const ProductVariant(
      {required this.id,
      required this.productId,
      required this.name,
      required this.priceInPaisa,
      required this.isAvailable,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['name'] = Variable<String>(name);
    map['price_in_paisa'] = Variable<int>(priceInPaisa);
    map['is_available'] = Variable<bool>(isAvailable);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ProductVariantsCompanion toCompanion(bool nullToAbsent) {
    return ProductVariantsCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      priceInPaisa: Value(priceInPaisa),
      isAvailable: Value(isAvailable),
      sortOrder: Value(sortOrder),
    );
  }

  factory ProductVariant.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductVariant(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      priceInPaisa: serializer.fromJson<int>(json['priceInPaisa']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'name': serializer.toJson<String>(name),
      'priceInPaisa': serializer.toJson<int>(priceInPaisa),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ProductVariant copyWith(
          {int? id,
          int? productId,
          String? name,
          int? priceInPaisa,
          bool? isAvailable,
          int? sortOrder}) =>
      ProductVariant(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        name: name ?? this.name,
        priceInPaisa: priceInPaisa ?? this.priceInPaisa,
        isAvailable: isAvailable ?? this.isAvailable,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  ProductVariant copyWithCompanion(ProductVariantsCompanion data) {
    return ProductVariant(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      priceInPaisa: data.priceInPaisa.present
          ? data.priceInPaisa.value
          : this.priceInPaisa,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariant(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('priceInPaisa: $priceInPaisa, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, name, priceInPaisa, isAvailable, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductVariant &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.priceInPaisa == this.priceInPaisa &&
          other.isAvailable == this.isAvailable &&
          other.sortOrder == this.sortOrder);
}

class ProductVariantsCompanion extends UpdateCompanion<ProductVariant> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> name;
  final Value<int> priceInPaisa;
  final Value<bool> isAvailable;
  final Value<int> sortOrder;
  const ProductVariantsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.priceInPaisa = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  ProductVariantsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String name,
    required int priceInPaisa,
    this.isAvailable = const Value.absent(),
    this.sortOrder = const Value.absent(),
  })  : productId = Value(productId),
        name = Value(name),
        priceInPaisa = Value(priceInPaisa);
  static Insertable<ProductVariant> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? name,
    Expression<int>? priceInPaisa,
    Expression<bool>? isAvailable,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (priceInPaisa != null) 'price_in_paisa': priceInPaisa,
      if (isAvailable != null) 'is_available': isAvailable,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  ProductVariantsCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<String>? name,
      Value<int>? priceInPaisa,
      Value<bool>? isAvailable,
      Value<int>? sortOrder}) {
    return ProductVariantsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      priceInPaisa: priceInPaisa ?? this.priceInPaisa,
      isAvailable: isAvailable ?? this.isAvailable,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (priceInPaisa.present) {
      map['price_in_paisa'] = Variable<int>(priceInPaisa.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariantsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('priceInPaisa: $priceInPaisa, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $DealsTable extends Deals with TableInfo<$DealsTable, Deal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceInPaisaMeta =
      const VerificationMeta('priceInPaisa');
  @override
  late final GeneratedColumn<int> priceInPaisa = GeneratedColumn<int>(
      'price_in_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isAvailableMeta =
      const VerificationMeta('isAvailable');
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
      'is_available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_available" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, priceInPaisa, imagePath, isAvailable, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deals';
  @override
  VerificationContext validateIntegrity(Insertable<Deal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('price_in_paisa')) {
      context.handle(
          _priceInPaisaMeta,
          priceInPaisa.isAcceptableOrUnknown(
              data['price_in_paisa']!, _priceInPaisaMeta));
    } else if (isInserting) {
      context.missing(_priceInPaisaMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      priceInPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_in_paisa'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DealsTable createAlias(String alias) {
    return $DealsTable(attachedDatabase, alias);
  }
}

class Deal extends DataClass implements Insertable<Deal> {
  final int id;
  final String name;
  final String? description;
  final int priceInPaisa;
  final String? imagePath;
  final bool isAvailable;
  final DateTime createdAt;
  const Deal(
      {required this.id,
      required this.name,
      this.description,
      required this.priceInPaisa,
      this.imagePath,
      required this.isAvailable,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price_in_paisa'] = Variable<int>(priceInPaisa);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['is_available'] = Variable<bool>(isAvailable);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DealsCompanion toCompanion(bool nullToAbsent) {
    return DealsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      priceInPaisa: Value(priceInPaisa),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      isAvailable: Value(isAvailable),
      createdAt: Value(createdAt),
    );
  }

  factory Deal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      priceInPaisa: serializer.fromJson<int>(json['priceInPaisa']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'priceInPaisa': serializer.toJson<int>(priceInPaisa),
      'imagePath': serializer.toJson<String?>(imagePath),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Deal copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          int? priceInPaisa,
          Value<String?> imagePath = const Value.absent(),
          bool? isAvailable,
          DateTime? createdAt}) =>
      Deal(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        priceInPaisa: priceInPaisa ?? this.priceInPaisa,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        isAvailable: isAvailable ?? this.isAvailable,
        createdAt: createdAt ?? this.createdAt,
      );
  Deal copyWithCompanion(DealsCompanion data) {
    return Deal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      priceInPaisa: data.priceInPaisa.present
          ? data.priceInPaisa.value
          : this.priceInPaisa,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priceInPaisa: $priceInPaisa, ')
          ..write('imagePath: $imagePath, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, description, priceInPaisa, imagePath, isAvailable, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deal &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.priceInPaisa == this.priceInPaisa &&
          other.imagePath == this.imagePath &&
          other.isAvailable == this.isAvailable &&
          other.createdAt == this.createdAt);
}

class DealsCompanion extends UpdateCompanion<Deal> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> priceInPaisa;
  final Value<String?> imagePath;
  final Value<bool> isAvailable;
  final Value<DateTime> createdAt;
  const DealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.priceInPaisa = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DealsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int priceInPaisa,
    this.imagePath = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        priceInPaisa = Value(priceInPaisa);
  static Insertable<Deal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? priceInPaisa,
    Expression<String>? imagePath,
    Expression<bool>? isAvailable,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (priceInPaisa != null) 'price_in_paisa': priceInPaisa,
      if (imagePath != null) 'image_path': imagePath,
      if (isAvailable != null) 'is_available': isAvailable,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DealsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? priceInPaisa,
      Value<String?>? imagePath,
      Value<bool>? isAvailable,
      Value<DateTime>? createdAt}) {
    return DealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priceInPaisa: priceInPaisa ?? this.priceInPaisa,
      imagePath: imagePath ?? this.imagePath,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priceInPaisa.present) {
      map['price_in_paisa'] = Variable<int>(priceInPaisa.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priceInPaisa: $priceInPaisa, ')
          ..write('imagePath: $imagePath, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DealItemsTable extends DealItems
    with TableInfo<$DealItemsTable, DealItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DealItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dealIdMeta = const VerificationMeta('dealId');
  @override
  late final GeneratedColumn<int> dealId = GeneratedColumn<int>(
      'deal_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES deals (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _variantIdMeta =
      const VerificationMeta('variantId');
  @override
  late final GeneratedColumn<int> variantId = GeneratedColumn<int>(
      'variant_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_variants (id) ON DELETE SET NULL'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, dealId, productId, variantId, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deal_items';
  @override
  VerificationContext validateIntegrity(Insertable<DealItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('deal_id')) {
      context.handle(_dealIdMeta,
          dealId.isAcceptableOrUnknown(data['deal_id']!, _dealIdMeta));
    } else if (isInserting) {
      context.missing(_dealIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DealItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DealItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dealId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deal_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      variantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}variant_id']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $DealItemsTable createAlias(String alias) {
    return $DealItemsTable(attachedDatabase, alias);
  }
}

class DealItem extends DataClass implements Insertable<DealItem> {
  final int id;
  final int dealId;
  final int productId;
  final int? variantId;
  final int quantity;
  const DealItem(
      {required this.id,
      required this.dealId,
      required this.productId,
      this.variantId,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deal_id'] = Variable<int>(dealId);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<int>(variantId);
    }
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  DealItemsCompanion toCompanion(bool nullToAbsent) {
    return DealItemsCompanion(
      id: Value(id),
      dealId: Value(dealId),
      productId: Value(productId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      quantity: Value(quantity),
    );
  }

  factory DealItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DealItem(
      id: serializer.fromJson<int>(json['id']),
      dealId: serializer.fromJson<int>(json['dealId']),
      productId: serializer.fromJson<int>(json['productId']),
      variantId: serializer.fromJson<int?>(json['variantId']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dealId': serializer.toJson<int>(dealId),
      'productId': serializer.toJson<int>(productId),
      'variantId': serializer.toJson<int?>(variantId),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  DealItem copyWith(
          {int? id,
          int? dealId,
          int? productId,
          Value<int?> variantId = const Value.absent(),
          int? quantity}) =>
      DealItem(
        id: id ?? this.id,
        dealId: dealId ?? this.dealId,
        productId: productId ?? this.productId,
        variantId: variantId.present ? variantId.value : this.variantId,
        quantity: quantity ?? this.quantity,
      );
  DealItem copyWithCompanion(DealItemsCompanion data) {
    return DealItem(
      id: data.id.present ? data.id.value : this.id,
      dealId: data.dealId.present ? data.dealId.value : this.dealId,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DealItem(')
          ..write('id: $id, ')
          ..write('dealId: $dealId, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dealId, productId, variantId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DealItem &&
          other.id == this.id &&
          other.dealId == this.dealId &&
          other.productId == this.productId &&
          other.variantId == this.variantId &&
          other.quantity == this.quantity);
}

class DealItemsCompanion extends UpdateCompanion<DealItem> {
  final Value<int> id;
  final Value<int> dealId;
  final Value<int> productId;
  final Value<int?> variantId;
  final Value<int> quantity;
  const DealItemsCompanion({
    this.id = const Value.absent(),
    this.dealId = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  DealItemsCompanion.insert({
    this.id = const Value.absent(),
    required int dealId,
    required int productId,
    this.variantId = const Value.absent(),
    this.quantity = const Value.absent(),
  })  : dealId = Value(dealId),
        productId = Value(productId);
  static Insertable<DealItem> custom({
    Expression<int>? id,
    Expression<int>? dealId,
    Expression<int>? productId,
    Expression<int>? variantId,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dealId != null) 'deal_id': dealId,
      if (productId != null) 'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      if (quantity != null) 'quantity': quantity,
    });
  }

  DealItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? dealId,
      Value<int>? productId,
      Value<int?>? variantId,
      Value<int>? quantity}) {
    return DealItemsCompanion(
      id: id ?? this.id,
      dealId: dealId ?? this.dealId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dealId.present) {
      map['deal_id'] = Variable<int>(dealId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<int>(variantId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DealItemsCompanion(')
          ..write('id: $id, ')
          ..write('dealId: $dealId, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $RestaurantTablesTable extends RestaurantTables
    with TableInfo<$RestaurantTablesTable, RestaurantTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestaurantTablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, name, capacity, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restaurant_tables';
  @override
  VerificationContext validateIntegrity(Insertable<RestaurantTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestaurantTable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $RestaurantTablesTable createAlias(String alias) {
    return $RestaurantTablesTable(attachedDatabase, alias);
  }
}

class RestaurantTable extends DataClass implements Insertable<RestaurantTable> {
  final int id;
  final String name;
  final int capacity;
  final bool isActive;
  const RestaurantTable(
      {required this.id,
      required this.name,
      required this.capacity,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['capacity'] = Variable<int>(capacity);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RestaurantTablesCompanion toCompanion(bool nullToAbsent) {
    return RestaurantTablesCompanion(
      id: Value(id),
      name: Value(name),
      capacity: Value(capacity),
      isActive: Value(isActive),
    );
  }

  factory RestaurantTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestaurantTable(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      capacity: serializer.fromJson<int>(json['capacity']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'capacity': serializer.toJson<int>(capacity),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  RestaurantTable copyWith(
          {int? id, String? name, int? capacity, bool? isActive}) =>
      RestaurantTable(
        id: id ?? this.id,
        name: name ?? this.name,
        capacity: capacity ?? this.capacity,
        isActive: isActive ?? this.isActive,
      );
  RestaurantTable copyWithCompanion(RestaurantTablesCompanion data) {
    return RestaurantTable(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTable(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('capacity: $capacity, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, capacity, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantTable &&
          other.id == this.id &&
          other.name == this.name &&
          other.capacity == this.capacity &&
          other.isActive == this.isActive);
}

class RestaurantTablesCompanion extends UpdateCompanion<RestaurantTable> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> capacity;
  final Value<bool> isActive;
  const RestaurantTablesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.capacity = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  RestaurantTablesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.capacity = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<RestaurantTable> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? capacity,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (capacity != null) 'capacity': capacity,
      if (isActive != null) 'is_active': isActive,
    });
  }

  RestaurantTablesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? capacity,
      Value<bool>? isActive}) {
    return RestaurantTablesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTablesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('capacity: $capacity, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderNumberMeta =
      const VerificationMeta('orderNumber');
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
      'order_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderTypeMeta =
      const VerificationMeta('orderType');
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
      'order_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tableIdMeta =
      const VerificationMeta('tableId');
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
      'table_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES restaurant_tables (id)'));
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerContactMeta =
      const VerificationMeta('customerContact');
  @override
  late final GeneratedColumn<String> customerContact = GeneratedColumn<String>(
      'customer_contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deliveryAddressMeta =
      const VerificationMeta('deliveryAddress');
  @override
  late final GeneratedColumn<String> deliveryAddress = GeneratedColumn<String>(
      'delivery_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subtotalInPaisaMeta =
      const VerificationMeta('subtotalInPaisa');
  @override
  late final GeneratedColumn<int> subtotalInPaisa = GeneratedColumn<int>(
      'subtotal_in_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taxInPaisaMeta =
      const VerificationMeta('taxInPaisa');
  @override
  late final GeneratedColumn<int> taxInPaisa = GeneratedColumn<int>(
      'tax_in_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountInPaisaMeta =
      const VerificationMeta('discountInPaisa');
  @override
  late final GeneratedColumn<int> discountInPaisa = GeneratedColumn<int>(
      'discount_in_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalInPaisaMeta =
      const VerificationMeta('totalInPaisa');
  @override
  late final GeneratedColumn<int> totalInPaisa = GeneratedColumn<int>(
      'total_in_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _orderStatusMeta =
      const VerificationMeta('orderStatus');
  @override
  late final GeneratedColumn<String> orderStatus = GeneratedColumn<String>(
      'order_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('in_progress'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderNumber,
        orderType,
        tableId,
        customerName,
        customerContact,
        deliveryAddress,
        subtotalInPaisa,
        taxInPaisa,
        discountInPaisa,
        totalInPaisa,
        orderStatus,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_number')) {
      context.handle(
          _orderNumberMeta,
          orderNumber.isAcceptableOrUnknown(
              data['order_number']!, _orderNumberMeta));
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('order_type')) {
      context.handle(_orderTypeMeta,
          orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta));
    } else if (isInserting) {
      context.missing(_orderTypeMeta);
    }
    if (data.containsKey('table_id')) {
      context.handle(_tableIdMeta,
          tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('customer_contact')) {
      context.handle(
          _customerContactMeta,
          customerContact.isAcceptableOrUnknown(
              data['customer_contact']!, _customerContactMeta));
    }
    if (data.containsKey('delivery_address')) {
      context.handle(
          _deliveryAddressMeta,
          deliveryAddress.isAcceptableOrUnknown(
              data['delivery_address']!, _deliveryAddressMeta));
    }
    if (data.containsKey('subtotal_in_paisa')) {
      context.handle(
          _subtotalInPaisaMeta,
          subtotalInPaisa.isAcceptableOrUnknown(
              data['subtotal_in_paisa']!, _subtotalInPaisaMeta));
    } else if (isInserting) {
      context.missing(_subtotalInPaisaMeta);
    }
    if (data.containsKey('tax_in_paisa')) {
      context.handle(
          _taxInPaisaMeta,
          taxInPaisa.isAcceptableOrUnknown(
              data['tax_in_paisa']!, _taxInPaisaMeta));
    }
    if (data.containsKey('discount_in_paisa')) {
      context.handle(
          _discountInPaisaMeta,
          discountInPaisa.isAcceptableOrUnknown(
              data['discount_in_paisa']!, _discountInPaisaMeta));
    }
    if (data.containsKey('total_in_paisa')) {
      context.handle(
          _totalInPaisaMeta,
          totalInPaisa.isAcceptableOrUnknown(
              data['total_in_paisa']!, _totalInPaisaMeta));
    } else if (isInserting) {
      context.missing(_totalInPaisaMeta);
    }
    if (data.containsKey('order_status')) {
      context.handle(
          _orderStatusMeta,
          orderStatus.isAcceptableOrUnknown(
              data['order_status']!, _orderStatusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_number'])!,
      orderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_type'])!,
      tableId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}table_id']),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      customerContact: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}customer_contact']),
      deliveryAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}delivery_address']),
      subtotalInPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subtotal_in_paisa'])!,
      taxInPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_in_paisa'])!,
      discountInPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_in_paisa'])!,
      totalInPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_in_paisa'])!,
      orderStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final String orderNumber;
  final String orderType;
  final int? tableId;
  final String? customerName;
  final String? customerContact;
  final String? deliveryAddress;
  final int subtotalInPaisa;
  final int taxInPaisa;
  final int discountInPaisa;
  final int totalInPaisa;
  final String orderStatus;
  final String? notes;
  final DateTime createdAt;
  const Order(
      {required this.id,
      required this.orderNumber,
      required this.orderType,
      this.tableId,
      this.customerName,
      this.customerContact,
      this.deliveryAddress,
      required this.subtotalInPaisa,
      required this.taxInPaisa,
      required this.discountInPaisa,
      required this.totalInPaisa,
      required this.orderStatus,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_number'] = Variable<String>(orderNumber);
    map['order_type'] = Variable<String>(orderType);
    if (!nullToAbsent || tableId != null) {
      map['table_id'] = Variable<int>(tableId);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || customerContact != null) {
      map['customer_contact'] = Variable<String>(customerContact);
    }
    if (!nullToAbsent || deliveryAddress != null) {
      map['delivery_address'] = Variable<String>(deliveryAddress);
    }
    map['subtotal_in_paisa'] = Variable<int>(subtotalInPaisa);
    map['tax_in_paisa'] = Variable<int>(taxInPaisa);
    map['discount_in_paisa'] = Variable<int>(discountInPaisa);
    map['total_in_paisa'] = Variable<int>(totalInPaisa);
    map['order_status'] = Variable<String>(orderStatus);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      orderNumber: Value(orderNumber),
      orderType: Value(orderType),
      tableId: tableId == null && nullToAbsent
          ? const Value.absent()
          : Value(tableId),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      customerContact: customerContact == null && nullToAbsent
          ? const Value.absent()
          : Value(customerContact),
      deliveryAddress: deliveryAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryAddress),
      subtotalInPaisa: Value(subtotalInPaisa),
      taxInPaisa: Value(taxInPaisa),
      discountInPaisa: Value(discountInPaisa),
      totalInPaisa: Value(totalInPaisa),
      orderStatus: Value(orderStatus),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      orderType: serializer.fromJson<String>(json['orderType']),
      tableId: serializer.fromJson<int?>(json['tableId']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      customerContact: serializer.fromJson<String?>(json['customerContact']),
      deliveryAddress: serializer.fromJson<String?>(json['deliveryAddress']),
      subtotalInPaisa: serializer.fromJson<int>(json['subtotalInPaisa']),
      taxInPaisa: serializer.fromJson<int>(json['taxInPaisa']),
      discountInPaisa: serializer.fromJson<int>(json['discountInPaisa']),
      totalInPaisa: serializer.fromJson<int>(json['totalInPaisa']),
      orderStatus: serializer.fromJson<String>(json['orderStatus']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'orderType': serializer.toJson<String>(orderType),
      'tableId': serializer.toJson<int?>(tableId),
      'customerName': serializer.toJson<String?>(customerName),
      'customerContact': serializer.toJson<String?>(customerContact),
      'deliveryAddress': serializer.toJson<String?>(deliveryAddress),
      'subtotalInPaisa': serializer.toJson<int>(subtotalInPaisa),
      'taxInPaisa': serializer.toJson<int>(taxInPaisa),
      'discountInPaisa': serializer.toJson<int>(discountInPaisa),
      'totalInPaisa': serializer.toJson<int>(totalInPaisa),
      'orderStatus': serializer.toJson<String>(orderStatus),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Order copyWith(
          {int? id,
          String? orderNumber,
          String? orderType,
          Value<int?> tableId = const Value.absent(),
          Value<String?> customerName = const Value.absent(),
          Value<String?> customerContact = const Value.absent(),
          Value<String?> deliveryAddress = const Value.absent(),
          int? subtotalInPaisa,
          int? taxInPaisa,
          int? discountInPaisa,
          int? totalInPaisa,
          String? orderStatus,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Order(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        orderType: orderType ?? this.orderType,
        tableId: tableId.present ? tableId.value : this.tableId,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        customerContact: customerContact.present
            ? customerContact.value
            : this.customerContact,
        deliveryAddress: deliveryAddress.present
            ? deliveryAddress.value
            : this.deliveryAddress,
        subtotalInPaisa: subtotalInPaisa ?? this.subtotalInPaisa,
        taxInPaisa: taxInPaisa ?? this.taxInPaisa,
        discountInPaisa: discountInPaisa ?? this.discountInPaisa,
        totalInPaisa: totalInPaisa ?? this.totalInPaisa,
        orderStatus: orderStatus ?? this.orderStatus,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      orderNumber:
          data.orderNumber.present ? data.orderNumber.value : this.orderNumber,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerContact: data.customerContact.present
          ? data.customerContact.value
          : this.customerContact,
      deliveryAddress: data.deliveryAddress.present
          ? data.deliveryAddress.value
          : this.deliveryAddress,
      subtotalInPaisa: data.subtotalInPaisa.present
          ? data.subtotalInPaisa.value
          : this.subtotalInPaisa,
      taxInPaisa:
          data.taxInPaisa.present ? data.taxInPaisa.value : this.taxInPaisa,
      discountInPaisa: data.discountInPaisa.present
          ? data.discountInPaisa.value
          : this.discountInPaisa,
      totalInPaisa: data.totalInPaisa.present
          ? data.totalInPaisa.value
          : this.totalInPaisa,
      orderStatus:
          data.orderStatus.present ? data.orderStatus.value : this.orderStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('orderType: $orderType, ')
          ..write('tableId: $tableId, ')
          ..write('customerName: $customerName, ')
          ..write('customerContact: $customerContact, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('subtotalInPaisa: $subtotalInPaisa, ')
          ..write('taxInPaisa: $taxInPaisa, ')
          ..write('discountInPaisa: $discountInPaisa, ')
          ..write('totalInPaisa: $totalInPaisa, ')
          ..write('orderStatus: $orderStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderNumber,
      orderType,
      tableId,
      customerName,
      customerContact,
      deliveryAddress,
      subtotalInPaisa,
      taxInPaisa,
      discountInPaisa,
      totalInPaisa,
      orderStatus,
      notes,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.orderNumber == this.orderNumber &&
          other.orderType == this.orderType &&
          other.tableId == this.tableId &&
          other.customerName == this.customerName &&
          other.customerContact == this.customerContact &&
          other.deliveryAddress == this.deliveryAddress &&
          other.subtotalInPaisa == this.subtotalInPaisa &&
          other.taxInPaisa == this.taxInPaisa &&
          other.discountInPaisa == this.discountInPaisa &&
          other.totalInPaisa == this.totalInPaisa &&
          other.orderStatus == this.orderStatus &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String> orderNumber;
  final Value<String> orderType;
  final Value<int?> tableId;
  final Value<String?> customerName;
  final Value<String?> customerContact;
  final Value<String?> deliveryAddress;
  final Value<int> subtotalInPaisa;
  final Value<int> taxInPaisa;
  final Value<int> discountInPaisa;
  final Value<int> totalInPaisa;
  final Value<String> orderStatus;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.orderType = const Value.absent(),
    this.tableId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerContact = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    this.subtotalInPaisa = const Value.absent(),
    this.taxInPaisa = const Value.absent(),
    this.discountInPaisa = const Value.absent(),
    this.totalInPaisa = const Value.absent(),
    this.orderStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String orderNumber,
    required String orderType,
    this.tableId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerContact = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    required int subtotalInPaisa,
    this.taxInPaisa = const Value.absent(),
    this.discountInPaisa = const Value.absent(),
    required int totalInPaisa,
    this.orderStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : orderNumber = Value(orderNumber),
        orderType = Value(orderType),
        subtotalInPaisa = Value(subtotalInPaisa),
        totalInPaisa = Value(totalInPaisa);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? orderNumber,
    Expression<String>? orderType,
    Expression<int>? tableId,
    Expression<String>? customerName,
    Expression<String>? customerContact,
    Expression<String>? deliveryAddress,
    Expression<int>? subtotalInPaisa,
    Expression<int>? taxInPaisa,
    Expression<int>? discountInPaisa,
    Expression<int>? totalInPaisa,
    Expression<String>? orderStatus,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      if (orderType != null) 'order_type': orderType,
      if (tableId != null) 'table_id': tableId,
      if (customerName != null) 'customer_name': customerName,
      if (customerContact != null) 'customer_contact': customerContact,
      if (deliveryAddress != null) 'delivery_address': deliveryAddress,
      if (subtotalInPaisa != null) 'subtotal_in_paisa': subtotalInPaisa,
      if (taxInPaisa != null) 'tax_in_paisa': taxInPaisa,
      if (discountInPaisa != null) 'discount_in_paisa': discountInPaisa,
      if (totalInPaisa != null) 'total_in_paisa': totalInPaisa,
      if (orderStatus != null) 'order_status': orderStatus,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OrdersCompanion copyWith(
      {Value<int>? id,
      Value<String>? orderNumber,
      Value<String>? orderType,
      Value<int?>? tableId,
      Value<String?>? customerName,
      Value<String?>? customerContact,
      Value<String?>? deliveryAddress,
      Value<int>? subtotalInPaisa,
      Value<int>? taxInPaisa,
      Value<int>? discountInPaisa,
      Value<int>? totalInPaisa,
      Value<String>? orderStatus,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return OrdersCompanion(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderType: orderType ?? this.orderType,
      tableId: tableId ?? this.tableId,
      customerName: customerName ?? this.customerName,
      customerContact: customerContact ?? this.customerContact,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      subtotalInPaisa: subtotalInPaisa ?? this.subtotalInPaisa,
      taxInPaisa: taxInPaisa ?? this.taxInPaisa,
      discountInPaisa: discountInPaisa ?? this.discountInPaisa,
      totalInPaisa: totalInPaisa ?? this.totalInPaisa,
      orderStatus: orderStatus ?? this.orderStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerContact.present) {
      map['customer_contact'] = Variable<String>(customerContact.value);
    }
    if (deliveryAddress.present) {
      map['delivery_address'] = Variable<String>(deliveryAddress.value);
    }
    if (subtotalInPaisa.present) {
      map['subtotal_in_paisa'] = Variable<int>(subtotalInPaisa.value);
    }
    if (taxInPaisa.present) {
      map['tax_in_paisa'] = Variable<int>(taxInPaisa.value);
    }
    if (discountInPaisa.present) {
      map['discount_in_paisa'] = Variable<int>(discountInPaisa.value);
    }
    if (totalInPaisa.present) {
      map['total_in_paisa'] = Variable<int>(totalInPaisa.value);
    }
    if (orderStatus.present) {
      map['order_status'] = Variable<String>(orderStatus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('orderType: $orderType, ')
          ..write('tableId: $tableId, ')
          ..write('customerName: $customerName, ')
          ..write('customerContact: $customerContact, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('subtotalInPaisa: $subtotalInPaisa, ')
          ..write('taxInPaisa: $taxInPaisa, ')
          ..write('discountInPaisa: $discountInPaisa, ')
          ..write('totalInPaisa: $totalInPaisa, ')
          ..write('orderStatus: $orderStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _dealIdMeta = const VerificationMeta('dealId');
  @override
  late final GeneratedColumn<int> dealId = GeneratedColumn<int>(
      'deal_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES deals (id)'));
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceInPaisaMeta =
      const VerificationMeta('unitPriceInPaisa');
  @override
  late final GeneratedColumn<int> unitPriceInPaisa = GeneratedColumn<int>(
      'unit_price_in_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalPriceInPaisaMeta =
      const VerificationMeta('totalPriceInPaisa');
  @override
  late final GeneratedColumn<int> totalPriceInPaisa = GeneratedColumn<int>(
      'total_price_in_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDealMeta = const VerificationMeta('isDeal');
  @override
  late final GeneratedColumn<bool> isDeal = GeneratedColumn<bool>(
      'is_deal', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deal" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lineDetailsMeta =
      const VerificationMeta('lineDetails');
  @override
  late final GeneratedColumn<String> lineDetails = GeneratedColumn<String>(
      'line_details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        productId,
        dealId,
        itemName,
        quantity,
        unitPriceInPaisa,
        totalPriceInPaisa,
        isDeal,
        lineDetails
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('deal_id')) {
      context.handle(_dealIdMeta,
          dealId.isAcceptableOrUnknown(data['deal_id']!, _dealIdMeta));
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_in_paisa')) {
      context.handle(
          _unitPriceInPaisaMeta,
          unitPriceInPaisa.isAcceptableOrUnknown(
              data['unit_price_in_paisa']!, _unitPriceInPaisaMeta));
    } else if (isInserting) {
      context.missing(_unitPriceInPaisaMeta);
    }
    if (data.containsKey('total_price_in_paisa')) {
      context.handle(
          _totalPriceInPaisaMeta,
          totalPriceInPaisa.isAcceptableOrUnknown(
              data['total_price_in_paisa']!, _totalPriceInPaisaMeta));
    } else if (isInserting) {
      context.missing(_totalPriceInPaisaMeta);
    }
    if (data.containsKey('is_deal')) {
      context.handle(_isDealMeta,
          isDeal.isAcceptableOrUnknown(data['is_deal']!, _isDealMeta));
    }
    if (data.containsKey('line_details')) {
      context.handle(
          _lineDetailsMeta,
          lineDetails.isAcceptableOrUnknown(
              data['line_details']!, _lineDetailsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id']),
      dealId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deal_id']),
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unitPriceInPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_price_in_paisa'])!,
      totalPriceInPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_price_in_paisa'])!,
      isDeal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deal'])!,
      lineDetails: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_details']),
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final int? productId;
  final int? dealId;
  final String itemName;
  final int quantity;
  final int unitPriceInPaisa;
  final int totalPriceInPaisa;
  final bool isDeal;
  final String? lineDetails;
  const OrderItem(
      {required this.id,
      required this.orderId,
      this.productId,
      this.dealId,
      required this.itemName,
      required this.quantity,
      required this.unitPriceInPaisa,
      required this.totalPriceInPaisa,
      required this.isDeal,
      this.lineDetails});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    if (!nullToAbsent || dealId != null) {
      map['deal_id'] = Variable<int>(dealId);
    }
    map['item_name'] = Variable<String>(itemName);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_in_paisa'] = Variable<int>(unitPriceInPaisa);
    map['total_price_in_paisa'] = Variable<int>(totalPriceInPaisa);
    map['is_deal'] = Variable<bool>(isDeal);
    if (!nullToAbsent || lineDetails != null) {
      map['line_details'] = Variable<String>(lineDetails);
    }
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      dealId:
          dealId == null && nullToAbsent ? const Value.absent() : Value(dealId),
      itemName: Value(itemName),
      quantity: Value(quantity),
      unitPriceInPaisa: Value(unitPriceInPaisa),
      totalPriceInPaisa: Value(totalPriceInPaisa),
      isDeal: Value(isDeal),
      lineDetails: lineDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(lineDetails),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      productId: serializer.fromJson<int?>(json['productId']),
      dealId: serializer.fromJson<int?>(json['dealId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceInPaisa: serializer.fromJson<int>(json['unitPriceInPaisa']),
      totalPriceInPaisa: serializer.fromJson<int>(json['totalPriceInPaisa']),
      isDeal: serializer.fromJson<bool>(json['isDeal']),
      lineDetails: serializer.fromJson<String?>(json['lineDetails']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'productId': serializer.toJson<int?>(productId),
      'dealId': serializer.toJson<int?>(dealId),
      'itemName': serializer.toJson<String>(itemName),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceInPaisa': serializer.toJson<int>(unitPriceInPaisa),
      'totalPriceInPaisa': serializer.toJson<int>(totalPriceInPaisa),
      'isDeal': serializer.toJson<bool>(isDeal),
      'lineDetails': serializer.toJson<String?>(lineDetails),
    };
  }

  OrderItem copyWith(
          {int? id,
          int? orderId,
          Value<int?> productId = const Value.absent(),
          Value<int?> dealId = const Value.absent(),
          String? itemName,
          int? quantity,
          int? unitPriceInPaisa,
          int? totalPriceInPaisa,
          bool? isDeal,
          Value<String?> lineDetails = const Value.absent()}) =>
      OrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId.present ? productId.value : this.productId,
        dealId: dealId.present ? dealId.value : this.dealId,
        itemName: itemName ?? this.itemName,
        quantity: quantity ?? this.quantity,
        unitPriceInPaisa: unitPriceInPaisa ?? this.unitPriceInPaisa,
        totalPriceInPaisa: totalPriceInPaisa ?? this.totalPriceInPaisa,
        isDeal: isDeal ?? this.isDeal,
        lineDetails: lineDetails.present ? lineDetails.value : this.lineDetails,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      dealId: data.dealId.present ? data.dealId.value : this.dealId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceInPaisa: data.unitPriceInPaisa.present
          ? data.unitPriceInPaisa.value
          : this.unitPriceInPaisa,
      totalPriceInPaisa: data.totalPriceInPaisa.present
          ? data.totalPriceInPaisa.value
          : this.totalPriceInPaisa,
      isDeal: data.isDeal.present ? data.isDeal.value : this.isDeal,
      lineDetails:
          data.lineDetails.present ? data.lineDetails.value : this.lineDetails,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('dealId: $dealId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceInPaisa: $unitPriceInPaisa, ')
          ..write('totalPriceInPaisa: $totalPriceInPaisa, ')
          ..write('isDeal: $isDeal, ')
          ..write('lineDetails: $lineDetails')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, productId, dealId, itemName,
      quantity, unitPriceInPaisa, totalPriceInPaisa, isDeal, lineDetails);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.dealId == this.dealId &&
          other.itemName == this.itemName &&
          other.quantity == this.quantity &&
          other.unitPriceInPaisa == this.unitPriceInPaisa &&
          other.totalPriceInPaisa == this.totalPriceInPaisa &&
          other.isDeal == this.isDeal &&
          other.lineDetails == this.lineDetails);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int?> productId;
  final Value<int?> dealId;
  final Value<String> itemName;
  final Value<int> quantity;
  final Value<int> unitPriceInPaisa;
  final Value<int> totalPriceInPaisa;
  final Value<bool> isDeal;
  final Value<String?> lineDetails;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.dealId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceInPaisa = const Value.absent(),
    this.totalPriceInPaisa = const Value.absent(),
    this.isDeal = const Value.absent(),
    this.lineDetails = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    this.productId = const Value.absent(),
    this.dealId = const Value.absent(),
    required String itemName,
    required int quantity,
    required int unitPriceInPaisa,
    required int totalPriceInPaisa,
    this.isDeal = const Value.absent(),
    this.lineDetails = const Value.absent(),
  })  : orderId = Value(orderId),
        itemName = Value(itemName),
        quantity = Value(quantity),
        unitPriceInPaisa = Value(unitPriceInPaisa),
        totalPriceInPaisa = Value(totalPriceInPaisa);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? productId,
    Expression<int>? dealId,
    Expression<String>? itemName,
    Expression<int>? quantity,
    Expression<int>? unitPriceInPaisa,
    Expression<int>? totalPriceInPaisa,
    Expression<bool>? isDeal,
    Expression<String>? lineDetails,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (dealId != null) 'deal_id': dealId,
      if (itemName != null) 'item_name': itemName,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceInPaisa != null) 'unit_price_in_paisa': unitPriceInPaisa,
      if (totalPriceInPaisa != null) 'total_price_in_paisa': totalPriceInPaisa,
      if (isDeal != null) 'is_deal': isDeal,
      if (lineDetails != null) 'line_details': lineDetails,
    });
  }

  OrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int?>? productId,
      Value<int?>? dealId,
      Value<String>? itemName,
      Value<int>? quantity,
      Value<int>? unitPriceInPaisa,
      Value<int>? totalPriceInPaisa,
      Value<bool>? isDeal,
      Value<String?>? lineDetails}) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      dealId: dealId ?? this.dealId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unitPriceInPaisa: unitPriceInPaisa ?? this.unitPriceInPaisa,
      totalPriceInPaisa: totalPriceInPaisa ?? this.totalPriceInPaisa,
      isDeal: isDeal ?? this.isDeal,
      lineDetails: lineDetails ?? this.lineDetails,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (dealId.present) {
      map['deal_id'] = Variable<int>(dealId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceInPaisa.present) {
      map['unit_price_in_paisa'] = Variable<int>(unitPriceInPaisa.value);
    }
    if (totalPriceInPaisa.present) {
      map['total_price_in_paisa'] = Variable<int>(totalPriceInPaisa.value);
    }
    if (isDeal.present) {
      map['is_deal'] = Variable<bool>(isDeal.value);
    }
    if (lineDetails.present) {
      map['line_details'] = Variable<String>(lineDetails.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('dealId: $dealId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceInPaisa: $unitPriceInPaisa, ')
          ..write('totalPriceInPaisa: $totalPriceInPaisa, ')
          ..write('isDeal: $isDeal, ')
          ..write('lineDetails: $lineDetails')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductVariantsTable productVariants =
      $ProductVariantsTable(this);
  late final $DealsTable deals = $DealsTable(this);
  late final $DealItemsTable dealItems = $DealItemsTable(this);
  late final $RestaurantTablesTable restaurantTables =
      $RestaurantTablesTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final ProductsDao productsDao = ProductsDao(this as AppDatabase);
  late final ProductVariantsDao productVariantsDao =
      ProductVariantsDao(this as AppDatabase);
  late final DealsDao dealsDao = DealsDao(this as AppDatabase);
  late final OrdersDao ordersDao = OrdersDao(this as AppDatabase);
  late final TablesDao tablesDao = TablesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        products,
        productVariants,
        deals,
        dealItems,
        restaurantTables,
        orders,
        orderItems
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('products',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('product_variants', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('product_variants',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('deal_items', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<String> color,
  Value<String> icon,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> color,
  Value<String> icon,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.products,
          aliasName:
              $_aliasNameGenerator(db.categories.id, db.products.categoryId));

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> productsRefs(
      Expression<bool> Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
      Expression<T> Function($$ProductsTableAnnotationComposer a) f) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool productsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            color: color,
            icon: icon,
            sortOrder: sortOrder,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> color = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            color: color,
            icon: icon,
            sortOrder: sortOrder,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            Product>(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._productsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .productsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool productsRefs})>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required int priceInPaisa,
  required int categoryId,
  Value<String?> imagePath,
  Value<bool> isAvailable,
  Value<bool> isDeal,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<int> priceInPaisa,
  Value<int> categoryId,
  Value<String?> imagePath,
  Value<bool> isAvailable,
  Value<bool> isDeal,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.products.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductVariantsTable, List<ProductVariant>>
      _productVariantsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productVariants,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.productVariants.productId));

  $$ProductVariantsTableProcessedTableManager get productVariantsRefs {
    final manager =
        $$ProductVariantsTableTableManager($_db, $_db.productVariants)
            .filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_productVariantsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DealItemsTable, List<DealItem>>
      _dealItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dealItems,
              aliasName:
                  $_aliasNameGenerator(db.products.id, db.dealItems.productId));

  $$DealItemsTableProcessedTableManager get dealItemsRefs {
    final manager = $$DealItemsTableTableManager($_db, $_db.dealItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dealItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName:
              $_aliasNameGenerator(db.products.id, db.orderItems.productId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeal => $composableBuilder(
      column: $table.isDeal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productVariantsRefs(
      Expression<bool> Function($$ProductVariantsTableFilterComposer f) f) {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productVariants,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductVariantsTableFilterComposer(
              $db: $db,
              $table: $db.productVariants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> dealItemsRefs(
      Expression<bool> Function($$DealItemsTableFilterComposer f) f) {
    final $$DealItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dealItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealItemsTableFilterComposer(
              $db: $db,
              $table: $db.dealItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeal => $composableBuilder(
      column: $table.isDeal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<bool> get isDeal =>
      $composableBuilder(column: $table.isDeal, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productVariantsRefs<T extends Object>(
      Expression<T> Function($$ProductVariantsTableAnnotationComposer a) f) {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productVariants,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductVariantsTableAnnotationComposer(
              $db: $db,
              $table: $db.productVariants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> dealItemsRefs<T extends Object>(
      Expression<T> Function($$DealItemsTableAnnotationComposer a) f) {
    final $$DealItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dealItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.dealItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool categoryId,
        bool productVariantsRefs,
        bool dealItemsRefs,
        bool orderItemsRefs})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> priceInPaisa = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<bool> isDeal = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            description: description,
            priceInPaisa: priceInPaisa,
            categoryId: categoryId,
            imagePath: imagePath,
            isAvailable: isAvailable,
            isDeal: isDeal,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required int priceInPaisa,
            required int categoryId,
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<bool> isDeal = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            description: description,
            priceInPaisa: priceInPaisa,
            categoryId: categoryId,
            imagePath: imagePath,
            isAvailable: isAvailable,
            isDeal: isDeal,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              productVariantsRefs = false,
              dealItemsRefs = false,
              orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productVariantsRefs) db.productVariants,
                if (dealItemsRefs) db.dealItems,
                if (orderItemsRefs) db.orderItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ProductsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ProductsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productVariantsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductVariant>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productVariantsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productVariantsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (dealItemsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            DealItem>(
                        currentTable: table,
                        referencedTable:
                            $$ProductsTableReferences._dealItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .dealItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$ProductsTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool categoryId,
        bool productVariantsRefs,
        bool dealItemsRefs,
        bool orderItemsRefs})>;
typedef $$ProductVariantsTableCreateCompanionBuilder = ProductVariantsCompanion
    Function({
  Value<int> id,
  required int productId,
  required String name,
  required int priceInPaisa,
  Value<bool> isAvailable,
  Value<int> sortOrder,
});
typedef $$ProductVariantsTableUpdateCompanionBuilder = ProductVariantsCompanion
    Function({
  Value<int> id,
  Value<int> productId,
  Value<String> name,
  Value<int> priceInPaisa,
  Value<bool> isAvailable,
  Value<int> sortOrder,
});

final class $$ProductVariantsTableReferences extends BaseReferences<
    _$AppDatabase, $ProductVariantsTable, ProductVariant> {
  $$ProductVariantsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.productVariants.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DealItemsTable, List<DealItem>>
      _dealItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dealItems,
              aliasName: $_aliasNameGenerator(
                  db.productVariants.id, db.dealItems.variantId));

  $$DealItemsTableProcessedTableManager get dealItemsRefs {
    final manager = $$DealItemsTableTableManager($_db, $_db.dealItems)
        .filter((f) => f.variantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dealItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductVariantsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> dealItemsRefs(
      Expression<bool> Function($$DealItemsTableFilterComposer f) f) {
    final $$DealItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dealItems,
        getReferencedColumn: (t) => t.variantId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealItemsTableFilterComposer(
              $db: $db,
              $table: $db.dealItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductVariantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductVariantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> dealItemsRefs<T extends Object>(
      Expression<T> Function($$DealItemsTableAnnotationComposer a) f) {
    final $$DealItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dealItems,
        getReferencedColumn: (t) => t.variantId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.dealItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductVariantsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductVariantsTable,
    ProductVariant,
    $$ProductVariantsTableFilterComposer,
    $$ProductVariantsTableOrderingComposer,
    $$ProductVariantsTableAnnotationComposer,
    $$ProductVariantsTableCreateCompanionBuilder,
    $$ProductVariantsTableUpdateCompanionBuilder,
    (ProductVariant, $$ProductVariantsTableReferences),
    ProductVariant,
    PrefetchHooks Function({bool productId, bool dealItemsRefs})> {
  $$ProductVariantsTableTableManager(
      _$AppDatabase db, $ProductVariantsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductVariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductVariantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductVariantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> priceInPaisa = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              ProductVariantsCompanion(
            id: id,
            productId: productId,
            name: name,
            priceInPaisa: priceInPaisa,
            isAvailable: isAvailable,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productId,
            required String name,
            required int priceInPaisa,
            Value<bool> isAvailable = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              ProductVariantsCompanion.insert(
            id: id,
            productId: productId,
            name: name,
            priceInPaisa: priceInPaisa,
            isAvailable: isAvailable,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductVariantsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false, dealItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dealItemsRefs) db.dealItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ProductVariantsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$ProductVariantsTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dealItemsRefs)
                    await $_getPrefetchedData<ProductVariant,
                            $ProductVariantsTable, DealItem>(
                        currentTable: table,
                        referencedTable: $$ProductVariantsTableReferences
                            ._dealItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductVariantsTableReferences(db, table, p0)
                                .dealItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.variantId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductVariantsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductVariantsTable,
    ProductVariant,
    $$ProductVariantsTableFilterComposer,
    $$ProductVariantsTableOrderingComposer,
    $$ProductVariantsTableAnnotationComposer,
    $$ProductVariantsTableCreateCompanionBuilder,
    $$ProductVariantsTableUpdateCompanionBuilder,
    (ProductVariant, $$ProductVariantsTableReferences),
    ProductVariant,
    PrefetchHooks Function({bool productId, bool dealItemsRefs})>;
typedef $$DealsTableCreateCompanionBuilder = DealsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required int priceInPaisa,
  Value<String?> imagePath,
  Value<bool> isAvailable,
  Value<DateTime> createdAt,
});
typedef $$DealsTableUpdateCompanionBuilder = DealsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<int> priceInPaisa,
  Value<String?> imagePath,
  Value<bool> isAvailable,
  Value<DateTime> createdAt,
});

final class $$DealsTableReferences
    extends BaseReferences<_$AppDatabase, $DealsTable, Deal> {
  $$DealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DealItemsTable, List<DealItem>>
      _dealItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.dealItems,
          aliasName: $_aliasNameGenerator(db.deals.id, db.dealItems.dealId));

  $$DealItemsTableProcessedTableManager get dealItemsRefs {
    final manager = $$DealItemsTableTableManager($_db, $_db.dealItems)
        .filter((f) => f.dealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dealItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName: $_aliasNameGenerator(db.deals.id, db.orderItems.dealId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.dealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DealsTableFilterComposer extends Composer<_$AppDatabase, $DealsTable> {
  $$DealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> dealItemsRefs(
      Expression<bool> Function($$DealItemsTableFilterComposer f) f) {
    final $$DealItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dealItems,
        getReferencedColumn: (t) => t.dealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealItemsTableFilterComposer(
              $db: $db,
              $table: $db.dealItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.dealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DealsTableOrderingComposer
    extends Composer<_$AppDatabase, $DealsTable> {
  $$DealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DealsTable> {
  $$DealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get priceInPaisa => $composableBuilder(
      column: $table.priceInPaisa, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> dealItemsRefs<T extends Object>(
      Expression<T> Function($$DealItemsTableAnnotationComposer a) f) {
    final $$DealItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dealItems,
        getReferencedColumn: (t) => t.dealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.dealItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.dealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DealsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DealsTable,
    Deal,
    $$DealsTableFilterComposer,
    $$DealsTableOrderingComposer,
    $$DealsTableAnnotationComposer,
    $$DealsTableCreateCompanionBuilder,
    $$DealsTableUpdateCompanionBuilder,
    (Deal, $$DealsTableReferences),
    Deal,
    PrefetchHooks Function({bool dealItemsRefs, bool orderItemsRefs})> {
  $$DealsTableTableManager(_$AppDatabase db, $DealsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> priceInPaisa = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DealsCompanion(
            id: id,
            name: name,
            description: description,
            priceInPaisa: priceInPaisa,
            imagePath: imagePath,
            isAvailable: isAvailable,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required int priceInPaisa,
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DealsCompanion.insert(
            id: id,
            name: name,
            description: description,
            priceInPaisa: priceInPaisa,
            imagePath: imagePath,
            isAvailable: isAvailable,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DealsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {dealItemsRefs = false, orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dealItemsRefs) db.dealItems,
                if (orderItemsRefs) db.orderItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dealItemsRefs)
                    await $_getPrefetchedData<Deal, $DealsTable, DealItem>(
                        currentTable: table,
                        referencedTable:
                            $$DealsTableReferences._dealItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DealsTableReferences(db, table, p0).dealItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.dealId == item.id),
                        typedResults: items),
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Deal, $DealsTable, OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$DealsTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DealsTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.dealId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DealsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DealsTable,
    Deal,
    $$DealsTableFilterComposer,
    $$DealsTableOrderingComposer,
    $$DealsTableAnnotationComposer,
    $$DealsTableCreateCompanionBuilder,
    $$DealsTableUpdateCompanionBuilder,
    (Deal, $$DealsTableReferences),
    Deal,
    PrefetchHooks Function({bool dealItemsRefs, bool orderItemsRefs})>;
typedef $$DealItemsTableCreateCompanionBuilder = DealItemsCompanion Function({
  Value<int> id,
  required int dealId,
  required int productId,
  Value<int?> variantId,
  Value<int> quantity,
});
typedef $$DealItemsTableUpdateCompanionBuilder = DealItemsCompanion Function({
  Value<int> id,
  Value<int> dealId,
  Value<int> productId,
  Value<int?> variantId,
  Value<int> quantity,
});

final class $$DealItemsTableReferences
    extends BaseReferences<_$AppDatabase, $DealItemsTable, DealItem> {
  $$DealItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DealsTable _dealIdTable(_$AppDatabase db) => db.deals
      .createAlias($_aliasNameGenerator(db.dealItems.dealId, db.deals.id));

  $$DealsTableProcessedTableManager get dealId {
    final $_column = $_itemColumn<int>('deal_id')!;

    final manager = $$DealsTableTableManager($_db, $_db.deals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.dealItems.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductVariantsTable _variantIdTable(_$AppDatabase db) =>
      db.productVariants.createAlias(
          $_aliasNameGenerator(db.dealItems.variantId, db.productVariants.id));

  $$ProductVariantsTableProcessedTableManager? get variantId {
    final $_column = $_itemColumn<int>('variant_id');
    if ($_column == null) return null;
    final manager =
        $$ProductVariantsTableTableManager($_db, $_db.productVariants)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DealItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DealItemsTable> {
  $$DealItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  $$DealsTableFilterComposer get dealId {
    final $$DealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dealId,
        referencedTable: $db.deals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealsTableFilterComposer(
              $db: $db,
              $table: $db.deals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductVariantsTableFilterComposer get variantId {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.variantId,
        referencedTable: $db.productVariants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductVariantsTableFilterComposer(
              $db: $db,
              $table: $db.productVariants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DealItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DealItemsTable> {
  $$DealItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  $$DealsTableOrderingComposer get dealId {
    final $$DealsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dealId,
        referencedTable: $db.deals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealsTableOrderingComposer(
              $db: $db,
              $table: $db.deals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get variantId {
    final $$ProductVariantsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.variantId,
        referencedTable: $db.productVariants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductVariantsTableOrderingComposer(
              $db: $db,
              $table: $db.productVariants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DealItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DealItemsTable> {
  $$DealItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$DealsTableAnnotationComposer get dealId {
    final $$DealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dealId,
        referencedTable: $db.deals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealsTableAnnotationComposer(
              $db: $db,
              $table: $db.deals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductVariantsTableAnnotationComposer get variantId {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.variantId,
        referencedTable: $db.productVariants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductVariantsTableAnnotationComposer(
              $db: $db,
              $table: $db.productVariants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DealItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DealItemsTable,
    DealItem,
    $$DealItemsTableFilterComposer,
    $$DealItemsTableOrderingComposer,
    $$DealItemsTableAnnotationComposer,
    $$DealItemsTableCreateCompanionBuilder,
    $$DealItemsTableUpdateCompanionBuilder,
    (DealItem, $$DealItemsTableReferences),
    DealItem,
    PrefetchHooks Function({bool dealId, bool productId, bool variantId})> {
  $$DealItemsTableTableManager(_$AppDatabase db, $DealItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DealItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DealItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DealItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> dealId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int?> variantId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
          }) =>
              DealItemsCompanion(
            id: id,
            dealId: dealId,
            productId: productId,
            variantId: variantId,
            quantity: quantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int dealId,
            required int productId,
            Value<int?> variantId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
          }) =>
              DealItemsCompanion.insert(
            id: id,
            dealId: dealId,
            productId: productId,
            variantId: variantId,
            quantity: quantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DealItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {dealId = false, productId = false, variantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dealId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dealId,
                    referencedTable:
                        $$DealItemsTableReferences._dealIdTable(db),
                    referencedColumn:
                        $$DealItemsTableReferences._dealIdTable(db).id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$DealItemsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$DealItemsTableReferences._productIdTable(db).id,
                  ) as T;
                }
                if (variantId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.variantId,
                    referencedTable:
                        $$DealItemsTableReferences._variantIdTable(db),
                    referencedColumn:
                        $$DealItemsTableReferences._variantIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DealItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DealItemsTable,
    DealItem,
    $$DealItemsTableFilterComposer,
    $$DealItemsTableOrderingComposer,
    $$DealItemsTableAnnotationComposer,
    $$DealItemsTableCreateCompanionBuilder,
    $$DealItemsTableUpdateCompanionBuilder,
    (DealItem, $$DealItemsTableReferences),
    DealItem,
    PrefetchHooks Function({bool dealId, bool productId, bool variantId})>;
typedef $$RestaurantTablesTableCreateCompanionBuilder
    = RestaurantTablesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> capacity,
  Value<bool> isActive,
});
typedef $$RestaurantTablesTableUpdateCompanionBuilder
    = RestaurantTablesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> capacity,
  Value<bool> isActive,
});

final class $$RestaurantTablesTableReferences extends BaseReferences<
    _$AppDatabase, $RestaurantTablesTable, RestaurantTable> {
  $$RestaurantTablesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.orders,
          aliasName:
              $_aliasNameGenerator(db.restaurantTables.id, db.orders.tableId));

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.tableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RestaurantTablesTableFilterComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> ordersRefs(
      Expression<bool> Function($$OrdersTableFilterComposer f) f) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.tableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RestaurantTablesTableOrderingComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$RestaurantTablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> ordersRefs<T extends Object>(
      Expression<T> Function($$OrdersTableAnnotationComposer a) f) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.tableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RestaurantTablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RestaurantTablesTable,
    RestaurantTable,
    $$RestaurantTablesTableFilterComposer,
    $$RestaurantTablesTableOrderingComposer,
    $$RestaurantTablesTableAnnotationComposer,
    $$RestaurantTablesTableCreateCompanionBuilder,
    $$RestaurantTablesTableUpdateCompanionBuilder,
    (RestaurantTable, $$RestaurantTablesTableReferences),
    RestaurantTable,
    PrefetchHooks Function({bool ordersRefs})> {
  $$RestaurantTablesTableTableManager(
      _$AppDatabase db, $RestaurantTablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestaurantTablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestaurantTablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestaurantTablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              RestaurantTablesCompanion(
            id: id,
            name: name,
            capacity: capacity,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> capacity = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              RestaurantTablesCompanion.insert(
            id: id,
            name: name,
            capacity: capacity,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RestaurantTablesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersRefs) db.orders],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersRefs)
                    await $_getPrefetchedData<RestaurantTable,
                            $RestaurantTablesTable, Order>(
                        currentTable: table,
                        referencedTable: $$RestaurantTablesTableReferences
                            ._ordersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RestaurantTablesTableReferences(db, table, p0)
                                .ordersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tableId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RestaurantTablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RestaurantTablesTable,
    RestaurantTable,
    $$RestaurantTablesTableFilterComposer,
    $$RestaurantTablesTableOrderingComposer,
    $$RestaurantTablesTableAnnotationComposer,
    $$RestaurantTablesTableCreateCompanionBuilder,
    $$RestaurantTablesTableUpdateCompanionBuilder,
    (RestaurantTable, $$RestaurantTablesTableReferences),
    RestaurantTable,
    PrefetchHooks Function({bool ordersRefs})>;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  required String orderNumber,
  required String orderType,
  Value<int?> tableId,
  Value<String?> customerName,
  Value<String?> customerContact,
  Value<String?> deliveryAddress,
  required int subtotalInPaisa,
  Value<int> taxInPaisa,
  Value<int> discountInPaisa,
  required int totalInPaisa,
  Value<String> orderStatus,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<String> orderNumber,
  Value<String> orderType,
  Value<int?> tableId,
  Value<String?> customerName,
  Value<String?> customerContact,
  Value<String?> deliveryAddress,
  Value<int> subtotalInPaisa,
  Value<int> taxInPaisa,
  Value<int> discountInPaisa,
  Value<int> totalInPaisa,
  Value<String> orderStatus,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RestaurantTablesTable _tableIdTable(_$AppDatabase db) =>
      db.restaurantTables.createAlias(
          $_aliasNameGenerator(db.orders.tableId, db.restaurantTables.id));

  $$RestaurantTablesTableProcessedTableManager? get tableId {
    final $_column = $_itemColumn<int>('table_id');
    if ($_column == null) return null;
    final manager =
        $$RestaurantTablesTableTableManager($_db, $_db.restaurantTables)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerContact => $composableBuilder(
      column: $table.customerContact,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deliveryAddress => $composableBuilder(
      column: $table.deliveryAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subtotalInPaisa => $composableBuilder(
      column: $table.subtotalInPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxInPaisa => $composableBuilder(
      column: $table.taxInPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountInPaisa => $composableBuilder(
      column: $table.discountInPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalInPaisa => $composableBuilder(
      column: $table.totalInPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderStatus => $composableBuilder(
      column: $table.orderStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$RestaurantTablesTableFilterComposer get tableId {
    final $$RestaurantTablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.restaurantTables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RestaurantTablesTableFilterComposer(
              $db: $db,
              $table: $db.restaurantTables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerContact => $composableBuilder(
      column: $table.customerContact,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deliveryAddress => $composableBuilder(
      column: $table.deliveryAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subtotalInPaisa => $composableBuilder(
      column: $table.subtotalInPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxInPaisa => $composableBuilder(
      column: $table.taxInPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountInPaisa => $composableBuilder(
      column: $table.discountInPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalInPaisa => $composableBuilder(
      column: $table.totalInPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderStatus => $composableBuilder(
      column: $table.orderStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$RestaurantTablesTableOrderingComposer get tableId {
    final $$RestaurantTablesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.restaurantTables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RestaurantTablesTableOrderingComposer(
              $db: $db,
              $table: $db.restaurantTables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerContact => $composableBuilder(
      column: $table.customerContact, builder: (column) => column);

  GeneratedColumn<String> get deliveryAddress => $composableBuilder(
      column: $table.deliveryAddress, builder: (column) => column);

  GeneratedColumn<int> get subtotalInPaisa => $composableBuilder(
      column: $table.subtotalInPaisa, builder: (column) => column);

  GeneratedColumn<int> get taxInPaisa => $composableBuilder(
      column: $table.taxInPaisa, builder: (column) => column);

  GeneratedColumn<int> get discountInPaisa => $composableBuilder(
      column: $table.discountInPaisa, builder: (column) => column);

  GeneratedColumn<int> get totalInPaisa => $composableBuilder(
      column: $table.totalInPaisa, builder: (column) => column);

  GeneratedColumn<String> get orderStatus => $composableBuilder(
      column: $table.orderStatus, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RestaurantTablesTableAnnotationComposer get tableId {
    final $$RestaurantTablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.restaurantTables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RestaurantTablesTableAnnotationComposer(
              $db: $db,
              $table: $db.restaurantTables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function({bool tableId, bool orderItemsRefs})> {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> orderNumber = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<int?> tableId = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String?> customerContact = const Value.absent(),
            Value<String?> deliveryAddress = const Value.absent(),
            Value<int> subtotalInPaisa = const Value.absent(),
            Value<int> taxInPaisa = const Value.absent(),
            Value<int> discountInPaisa = const Value.absent(),
            Value<int> totalInPaisa = const Value.absent(),
            Value<String> orderStatus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OrdersCompanion(
            id: id,
            orderNumber: orderNumber,
            orderType: orderType,
            tableId: tableId,
            customerName: customerName,
            customerContact: customerContact,
            deliveryAddress: deliveryAddress,
            subtotalInPaisa: subtotalInPaisa,
            taxInPaisa: taxInPaisa,
            discountInPaisa: discountInPaisa,
            totalInPaisa: totalInPaisa,
            orderStatus: orderStatus,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String orderNumber,
            required String orderType,
            Value<int?> tableId = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String?> customerContact = const Value.absent(),
            Value<String?> deliveryAddress = const Value.absent(),
            required int subtotalInPaisa,
            Value<int> taxInPaisa = const Value.absent(),
            Value<int> discountInPaisa = const Value.absent(),
            required int totalInPaisa,
            Value<String> orderStatus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OrdersCompanion.insert(
            id: id,
            orderNumber: orderNumber,
            orderType: orderType,
            tableId: tableId,
            customerName: customerName,
            customerContact: customerContact,
            deliveryAddress: deliveryAddress,
            subtotalInPaisa: subtotalInPaisa,
            taxInPaisa: taxInPaisa,
            discountInPaisa: discountInPaisa,
            totalInPaisa: totalInPaisa,
            orderStatus: orderStatus,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$OrdersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({tableId = false, orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tableId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tableId,
                    referencedTable: $$OrdersTableReferences._tableIdTable(db),
                    referencedColumn:
                        $$OrdersTableReferences._tableIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function({bool tableId, bool orderItemsRefs})>;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  Value<int?> productId,
  Value<int?> dealId,
  required String itemName,
  required int quantity,
  required int unitPriceInPaisa,
  required int totalPriceInPaisa,
  Value<bool> isDeal,
  Value<String?> lineDetails,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int?> productId,
  Value<int?> dealId,
  Value<String> itemName,
  Value<int> quantity,
  Value<int> unitPriceInPaisa,
  Value<int> totalPriceInPaisa,
  Value<bool> isDeal,
  Value<String?> lineDetails,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.orderItems.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.orderItems.productId, db.products.id));

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<int>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DealsTable _dealIdTable(_$AppDatabase db) => db.deals
      .createAlias($_aliasNameGenerator(db.orderItems.dealId, db.deals.id));

  $$DealsTableProcessedTableManager? get dealId {
    final $_column = $_itemColumn<int>('deal_id');
    if ($_column == null) return null;
    final manager = $$DealsTableTableManager($_db, $_db.deals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitPriceInPaisa => $composableBuilder(
      column: $table.unitPriceInPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalPriceInPaisa => $composableBuilder(
      column: $table.totalPriceInPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeal => $composableBuilder(
      column: $table.isDeal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lineDetails => $composableBuilder(
      column: $table.lineDetails, builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DealsTableFilterComposer get dealId {
    final $$DealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dealId,
        referencedTable: $db.deals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealsTableFilterComposer(
              $db: $db,
              $table: $db.deals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitPriceInPaisa => $composableBuilder(
      column: $table.unitPriceInPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalPriceInPaisa => $composableBuilder(
      column: $table.totalPriceInPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeal => $composableBuilder(
      column: $table.isDeal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lineDetails => $composableBuilder(
      column: $table.lineDetails, builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DealsTableOrderingComposer get dealId {
    final $$DealsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dealId,
        referencedTable: $db.deals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealsTableOrderingComposer(
              $db: $db,
              $table: $db.deals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceInPaisa => $composableBuilder(
      column: $table.unitPriceInPaisa, builder: (column) => column);

  GeneratedColumn<int> get totalPriceInPaisa => $composableBuilder(
      column: $table.totalPriceInPaisa, builder: (column) => column);

  GeneratedColumn<bool> get isDeal =>
      $composableBuilder(column: $table.isDeal, builder: (column) => column);

  GeneratedColumn<String> get lineDetails => $composableBuilder(
      column: $table.lineDetails, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DealsTableAnnotationComposer get dealId {
    final $$DealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dealId,
        referencedTable: $db.deals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DealsTableAnnotationComposer(
              $db: $db,
              $table: $db.deals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId, bool productId, bool dealId})> {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int?> productId = const Value.absent(),
            Value<int?> dealId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> unitPriceInPaisa = const Value.absent(),
            Value<int> totalPriceInPaisa = const Value.absent(),
            Value<bool> isDeal = const Value.absent(),
            Value<String?> lineDetails = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            orderId: orderId,
            productId: productId,
            dealId: dealId,
            itemName: itemName,
            quantity: quantity,
            unitPriceInPaisa: unitPriceInPaisa,
            totalPriceInPaisa: totalPriceInPaisa,
            isDeal: isDeal,
            lineDetails: lineDetails,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            Value<int?> productId = const Value.absent(),
            Value<int?> dealId = const Value.absent(),
            required String itemName,
            required int quantity,
            required int unitPriceInPaisa,
            required int totalPriceInPaisa,
            Value<bool> isDeal = const Value.absent(),
            Value<String?> lineDetails = const Value.absent(),
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            productId: productId,
            dealId: dealId,
            itemName: itemName,
            quantity: quantity,
            unitPriceInPaisa: unitPriceInPaisa,
            totalPriceInPaisa: totalPriceInPaisa,
            isDeal: isDeal,
            lineDetails: lineDetails,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {orderId = false, productId = false, dealId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OrderItemsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._orderIdTable(db).id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$OrderItemsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._productIdTable(db).id,
                  ) as T;
                }
                if (dealId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dealId,
                    referencedTable:
                        $$OrderItemsTableReferences._dealIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._dealIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId, bool productId, bool dealId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductVariantsTableTableManager get productVariants =>
      $$ProductVariantsTableTableManager(_db, _db.productVariants);
  $$DealsTableTableManager get deals =>
      $$DealsTableTableManager(_db, _db.deals);
  $$DealItemsTableTableManager get dealItems =>
      $$DealItemsTableTableManager(_db, _db.dealItems);
  $$RestaurantTablesTableTableManager get restaurantTables =>
      $$RestaurantTablesTableTableManager(_db, _db.restaurantTables);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
}
