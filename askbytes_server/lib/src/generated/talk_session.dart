/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class TalkSession
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TalkSession._({
    this.id,
    this.eventId,
    required this.title,
    required this.speakerName,
    this.description,
    this.durationMinutes,
    required this.speakerId,
    required this.joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    this.endedAt,
  }) : status = status ?? 'active',
       questionCount = questionCount ?? 0,
       autoEndScheduled = autoEndScheduled ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory TalkSession({
    int? id,
    int? eventId,
    required String title,
    required String speakerName,
    String? description,
    int? durationMinutes,
    required _is.UuidValue speakerId,
    required String joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    DateTime? endedAt,
  }) = _TalkSessionImpl;

  factory TalkSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return TalkSession(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int?,
      title: jsonSerialization['title'] as String,
      speakerName: jsonSerialization['speakerName'] as String,
      description: jsonSerialization['description'] as String?,
      durationMinutes: jsonSerialization['durationMinutes'] as int?,
      speakerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['speakerId'],
      ),
      joinCode: jsonSerialization['joinCode'] as String,
      status: jsonSerialization['status'] as String?,
      questionCount: jsonSerialization['questionCount'] as int?,
      autoEndScheduled: jsonSerialization['autoEndScheduled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['autoEndScheduled'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
    );
  }

  static final t = TalkSessionTable();

  static const db = TalkSessionRepository._();

  @override
  int? id;

  int? eventId;

  String title;

  String speakerName;

  String? description;

  int? durationMinutes;

  _is.UuidValue speakerId;

  String joinCode;

  String status;

  int questionCount;

  bool autoEndScheduled;

  DateTime createdAt;

  DateTime? endedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TalkSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TalkSession copyWith({
    int? id,
    int? eventId,
    String? title,
    String? speakerName,
    String? description,
    int? durationMinutes,
    _is.UuidValue? speakerId,
    String? joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    DateTime? endedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TalkSession',
      if (id != null) 'id': id,
      if (eventId != null) 'eventId': eventId,
      'title': title,
      'speakerName': speakerName,
      if (description != null) 'description': description,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      'speakerId': speakerId.toJson(),
      'joinCode': joinCode,
      'status': status,
      'questionCount': questionCount,
      'autoEndScheduled': autoEndScheduled,
      'createdAt': createdAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TalkSession',
      if (id != null) 'id': id,
      if (eventId != null) 'eventId': eventId,
      'title': title,
      'speakerName': speakerName,
      if (description != null) 'description': description,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      'speakerId': speakerId.toJson(),
      'joinCode': joinCode,
      'status': status,
      'questionCount': questionCount,
      'autoEndScheduled': autoEndScheduled,
      'createdAt': createdAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  static TalkSessionInclude include() {
    return TalkSessionInclude._();
  }

  static TalkSessionIncludeList includeList({
    _is.WhereExpressionBuilder<TalkSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TalkSessionTable>? orderBy,
    _is.OrderByListBuilder<TalkSessionTable>? orderByList,
    TalkSessionInclude? include,
  }) {
    return TalkSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TalkSession.t),
      orderByList: orderByList?.call(TalkSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TalkSessionImpl extends TalkSession {
  _TalkSessionImpl({
    int? id,
    int? eventId,
    required String title,
    required String speakerName,
    String? description,
    int? durationMinutes,
    required _is.UuidValue speakerId,
    required String joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    DateTime? endedAt,
  }) : super._(
         id: id,
         eventId: eventId,
         title: title,
         speakerName: speakerName,
         description: description,
         durationMinutes: durationMinutes,
         speakerId: speakerId,
         joinCode: joinCode,
         status: status,
         questionCount: questionCount,
         autoEndScheduled: autoEndScheduled,
         createdAt: createdAt,
         endedAt: endedAt,
       );

  /// Returns a shallow copy of this [TalkSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TalkSession copyWith({
    Object? id = _Undefined,
    Object? eventId = _Undefined,
    String? title,
    String? speakerName,
    Object? description = _Undefined,
    Object? durationMinutes = _Undefined,
    _is.UuidValue? speakerId,
    String? joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    Object? endedAt = _Undefined,
  }) {
    return TalkSession(
      id: id is int? ? id : this.id,
      eventId: eventId is int? ? eventId : this.eventId,
      title: title ?? this.title,
      speakerName: speakerName ?? this.speakerName,
      description: description is String? ? description : this.description,
      durationMinutes: durationMinutes is int?
          ? durationMinutes
          : this.durationMinutes,
      speakerId: speakerId ?? this.speakerId,
      joinCode: joinCode ?? this.joinCode,
      status: status ?? this.status,
      questionCount: questionCount ?? this.questionCount,
      autoEndScheduled: autoEndScheduled ?? this.autoEndScheduled,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
    );
  }
}

class TalkSessionUpdateTable extends _is.UpdateTable<TalkSessionTable> {
  TalkSessionUpdateTable(super.table);

  _is.ColumnValue<int, int> eventId(int? value) => _is.ColumnValue(
    table.eventId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> speakerName(String value) => _is.ColumnValue(
    table.speakerName,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<int, int> durationMinutes(int? value) => _is.ColumnValue(
    table.durationMinutes,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> speakerId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.speakerId,
    value,
  );

  _is.ColumnValue<String, String> joinCode(String value) => _is.ColumnValue(
    table.joinCode,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endedAt(DateTime? value) =>
      _is.ColumnValue(
        table.endedAt,
        value,
      );
}

class TalkSessionTable extends _is.Table<int?> {
  TalkSessionTable({super.tableRelation}) : super(tableName: 'talk_session') {
    updateTable = TalkSessionUpdateTable(this);
    eventId = _is.ColumnInt(
      'eventId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    speakerName = _is.ColumnString(
      'speakerName',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    durationMinutes = _is.ColumnInt(
      'durationMinutes',
      this,
    );
    speakerId = _is.ColumnUuid(
      'speakerId',
      this,
    );
    joinCode = _is.ColumnString(
      'joinCode',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    endedAt = _is.ColumnDateTime(
      'endedAt',
      this,
    );
  }

  late final TalkSessionUpdateTable updateTable;

  late final _is.ColumnInt eventId;

  late final _is.ColumnString title;

  late final _is.ColumnString speakerName;

  late final _is.ColumnString description;

  late final _is.ColumnInt durationMinutes;

  late final _is.ColumnUuid speakerId;

  late final _is.ColumnString joinCode;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime endedAt;

  @override
  List<_is.Column> get columns => [
    id,
    eventId,
    title,
    speakerName,
    description,
    durationMinutes,
    speakerId,
    joinCode,
    status,
    createdAt,
    endedAt,
  ];
}

class TalkSessionInclude extends _is.IncludeObject {
  TalkSessionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TalkSession.t;
}

class TalkSessionIncludeList extends _is.IncludeList {
  TalkSessionIncludeList._({
    _is.WhereExpressionBuilder<TalkSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TalkSession.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TalkSession.t;
}

class TalkSessionRepository {
  const TalkSessionRepository._();

  /// Returns a list of [TalkSession]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<TalkSession>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TalkSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TalkSessionTable>? orderBy,
    _is.OrderByListBuilder<TalkSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TalkSession>(
      where: where?.call(TalkSession.t),
      orderBy: orderBy?.call(TalkSession.t),
      orderByList: orderByList?.call(TalkSession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TalkSession] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<TalkSession?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TalkSessionTable>? where,
    int? offset,
    _is.OrderByBuilder<TalkSessionTable>? orderBy,
    _is.OrderByListBuilder<TalkSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TalkSession>(
      where: where?.call(TalkSession.t),
      orderBy: orderBy?.call(TalkSession.t),
      orderByList: orderByList?.call(TalkSession.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TalkSession] by its [id] or null if no such row exists.
  Future<TalkSession?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TalkSession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TalkSession]s in the list and returns the inserted rows.
  ///
  /// The returned [TalkSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TalkSession>> insert(
    _is.DatabaseSession session,
    List<TalkSession> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TalkSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TalkSession] and returns the inserted row.
  ///
  /// The returned [TalkSession] will have its `id` field set.
  Future<TalkSession> insertRow(
    _is.DatabaseSession session,
    TalkSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TalkSession>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TalkSession]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [TalkSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TalkSession>> upsert(
    _is.DatabaseSession session,
    List<TalkSession> rows, {
    required _is.ColumnSelections<TalkSessionTable> conflictColumns,
    _is.ColumnSelections<TalkSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<TalkSessionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TalkSession>(
      rows,
      conflictColumns: conflictColumns(TalkSession.t),
      updateColumns: updateColumns?.call(TalkSession.t),
      updateWhere: updateWhere?.call(TalkSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TalkSession] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [TalkSession] will have its `id` field set.
  Future<TalkSession?> upsertRow(
    _is.DatabaseSession session,
    TalkSession row, {
    required _is.ColumnSelections<TalkSessionTable> conflictColumns,
    _is.ColumnSelections<TalkSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<TalkSessionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TalkSession>(
      row,
      conflictColumns: conflictColumns(TalkSession.t),
      updateColumns: updateColumns?.call(TalkSession.t),
      updateWhere: updateWhere?.call(TalkSession.t),
      transaction: transaction,
    );
  }

  /// Updates all [TalkSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TalkSession>> update(
    _is.DatabaseSession session,
    List<TalkSession> rows, {
    _is.ColumnSelections<TalkSessionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TalkSession>(
      rows,
      columns: columns?.call(TalkSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TalkSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TalkSession> updateRow(
    _is.DatabaseSession session,
    TalkSession row, {
    _is.ColumnSelections<TalkSessionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TalkSession>(
      row,
      columns: columns?.call(TalkSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TalkSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TalkSession?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TalkSessionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TalkSession>(
      id,
      columnValues: columnValues(TalkSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TalkSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TalkSession>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TalkSessionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TalkSessionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TalkSessionTable>? orderBy,
    _is.OrderByListBuilder<TalkSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TalkSession>(
      columnValues: columnValues(TalkSession.t.updateTable),
      where: where(TalkSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TalkSession.t),
      orderByList: orderByList?.call(TalkSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TalkSession]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TalkSession>> delete(
    _is.DatabaseSession session,
    List<TalkSession> rows, {
    _is.OrderByBuilder<TalkSessionTable>? orderBy,
    _is.OrderByListBuilder<TalkSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TalkSession>(
      rows,
      orderBy: orderBy?.call(TalkSession.t),
      orderByList: orderByList?.call(TalkSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TalkSession].
  Future<TalkSession> deleteRow(
    _is.DatabaseSession session,
    TalkSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TalkSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TalkSession>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TalkSessionTable> where,
    _is.OrderByBuilder<TalkSessionTable>? orderBy,
    _is.OrderByListBuilder<TalkSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TalkSession>(
      where: where(TalkSession.t),
      orderBy: orderBy?.call(TalkSession.t),
      orderByList: orderByList?.call(TalkSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TalkSessionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TalkSession>(
      where: where?.call(TalkSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TalkSession] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TalkSessionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TalkSession>(
      where: where(TalkSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
