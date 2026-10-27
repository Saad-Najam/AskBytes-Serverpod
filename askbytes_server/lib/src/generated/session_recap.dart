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
import 'package:askbytes_server/src/generated/protocol.dart' as _i904v5el;
import 'package:serverpod/serverpod.dart' as _is;

abstract class SessionRecap
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SessionRecap._({
    this.id,
    required this.sessionId,
    required this.summaryMarkdown,
    required this.keyThemes,
    required this.topQuestions,
    required this.unanswered,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  factory SessionRecap({
    int? id,
    required int sessionId,
    required String summaryMarkdown,
    required List<String> keyThemes,
    required String topQuestions,
    required List<String> unanswered,
    DateTime? generatedAt,
  }) = _SessionRecapImpl;

  factory SessionRecap.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionRecap(
      id: jsonSerialization['id'] as int?,
      sessionId: jsonSerialization['sessionId'] as int,
      summaryMarkdown: jsonSerialization['summaryMarkdown'] as String,
      keyThemes: _i904v5el.Protocol().deserialize<List<String>>(
        jsonSerialization['keyThemes'],
      ),
      topQuestions: jsonSerialization['topQuestions'] as String,
      unanswered: _i904v5el.Protocol().deserialize<List<String>>(
        jsonSerialization['unanswered'],
      ),
      generatedAt: jsonSerialization['generatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['generatedAt'],
            ),
    );
  }

  static final t = SessionRecapTable();

  static const db = SessionRecapRepository._();

  @override
  int? id;

  int sessionId;

  String summaryMarkdown;

  List<String> keyThemes;

  String topQuestions;

  List<String> unanswered;

  DateTime generatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SessionRecap]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionRecap copyWith({
    int? id,
    int? sessionId,
    String? summaryMarkdown,
    List<String>? keyThemes,
    String? topQuestions,
    List<String>? unanswered,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionRecap',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'summaryMarkdown': summaryMarkdown,
      'keyThemes': keyThemes.toJson(),
      'topQuestions': topQuestions,
      'unanswered': unanswered.toJson(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionRecap',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'summaryMarkdown': summaryMarkdown,
      'keyThemes': keyThemes.toJson(),
      'topQuestions': topQuestions,
      'unanswered': unanswered.toJson(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  static SessionRecapInclude include() {
    return SessionRecapInclude._();
  }

  static SessionRecapIncludeList includeList({
    _is.WhereExpressionBuilder<SessionRecapTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionRecapTable>? orderBy,
    _is.OrderByListBuilder<SessionRecapTable>? orderByList,
    SessionRecapInclude? include,
  }) {
    return SessionRecapIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionRecap.t),
      orderByList: orderByList?.call(SessionRecap.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionRecapImpl extends SessionRecap {
  _SessionRecapImpl({
    int? id,
    required int sessionId,
    required String summaryMarkdown,
    required List<String> keyThemes,
    required String topQuestions,
    required List<String> unanswered,
    DateTime? generatedAt,
  }) : super._(
         id: id,
         sessionId: sessionId,
         summaryMarkdown: summaryMarkdown,
         keyThemes: keyThemes,
         topQuestions: topQuestions,
         unanswered: unanswered,
         generatedAt: generatedAt,
       );

  /// Returns a shallow copy of this [SessionRecap]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionRecap copyWith({
    Object? id = _Undefined,
    int? sessionId,
    String? summaryMarkdown,
    List<String>? keyThemes,
    String? topQuestions,
    List<String>? unanswered,
    DateTime? generatedAt,
  }) {
    return SessionRecap(
      id: id is int? ? id : this.id,
      sessionId: sessionId ?? this.sessionId,
      summaryMarkdown: summaryMarkdown ?? this.summaryMarkdown,
      keyThemes: keyThemes ?? this.keyThemes.map((e0) => e0).toList(),
      topQuestions: topQuestions ?? this.topQuestions,
      unanswered: unanswered ?? this.unanswered.map((e0) => e0).toList(),
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}

class SessionRecapUpdateTable extends _is.UpdateTable<SessionRecapTable> {
  SessionRecapUpdateTable(super.table);

  _is.ColumnValue<int, int> sessionId(int value) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<String, String> summaryMarkdown(String value) =>
      _is.ColumnValue(
        table.summaryMarkdown,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> keyThemes(List<String> value) =>
      _is.ColumnValue(
        table.keyThemes,
        value,
      );

  _is.ColumnValue<String, String> topQuestions(String value) => _is.ColumnValue(
    table.topQuestions,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> unanswered(List<String> value) =>
      _is.ColumnValue(
        table.unanswered,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> generatedAt(DateTime value) =>
      _is.ColumnValue(
        table.generatedAt,
        value,
      );
}

class SessionRecapTable extends _is.Table<int?> {
  SessionRecapTable({super.tableRelation}) : super(tableName: 'session_recap') {
    updateTable = SessionRecapUpdateTable(this);
    sessionId = _is.ColumnInt(
      'sessionId',
      this,
    );
    summaryMarkdown = _is.ColumnString(
      'summaryMarkdown',
      this,
    );
    keyThemes = _is.ColumnSerializable<List<String>>(
      'keyThemes',
      this,
    );
    topQuestions = _is.ColumnString(
      'topQuestions',
      this,
    );
    unanswered = _is.ColumnSerializable<List<String>>(
      'unanswered',
      this,
    );
    generatedAt = _is.ColumnDateTime(
      'generatedAt',
      this,
      hasDefault: true,
    );
  }

  late final SessionRecapUpdateTable updateTable;

  late final _is.ColumnInt sessionId;

  late final _is.ColumnString summaryMarkdown;

  late final _is.ColumnSerializable<List<String>> keyThemes;

  late final _is.ColumnString topQuestions;

  late final _is.ColumnSerializable<List<String>> unanswered;

  late final _is.ColumnDateTime generatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    sessionId,
    summaryMarkdown,
    keyThemes,
    topQuestions,
    unanswered,
    generatedAt,
  ];
}

class SessionRecapInclude extends _is.IncludeObject {
  SessionRecapInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SessionRecap.t;
}

class SessionRecapIncludeList extends _is.IncludeList {
  SessionRecapIncludeList._({
    _is.WhereExpressionBuilder<SessionRecapTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SessionRecap.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SessionRecap.t;
}

class SessionRecapRepository {
  const SessionRecapRepository._();

  /// Returns a list of [SessionRecap]s matching the given query parameters.
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
  Future<List<SessionRecap>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionRecapTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionRecapTable>? orderBy,
    _is.OrderByListBuilder<SessionRecapTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SessionRecap>(
      where: where?.call(SessionRecap.t),
      orderBy: orderBy?.call(SessionRecap.t),
      orderByList: orderByList?.call(SessionRecap.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SessionRecap] matching the given query parameters.
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
  Future<SessionRecap?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionRecapTable>? where,
    int? offset,
    _is.OrderByBuilder<SessionRecapTable>? orderBy,
    _is.OrderByListBuilder<SessionRecapTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SessionRecap>(
      where: where?.call(SessionRecap.t),
      orderBy: orderBy?.call(SessionRecap.t),
      orderByList: orderByList?.call(SessionRecap.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SessionRecap] by its [id] or null if no such row exists.
  Future<SessionRecap?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SessionRecap>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SessionRecap]s in the list and returns the inserted rows.
  ///
  /// The returned [SessionRecap]s will have their `id` fields set.
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
  Future<List<SessionRecap>> insert(
    _is.DatabaseSession session,
    List<SessionRecap> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SessionRecap>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SessionRecap] and returns the inserted row.
  ///
  /// The returned [SessionRecap] will have its `id` field set.
  Future<SessionRecap> insertRow(
    _is.DatabaseSession session,
    SessionRecap row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SessionRecap>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SessionRecap]s in the list and returns the resulting rows.
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
  /// The returned [SessionRecap]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionRecap>> upsert(
    _is.DatabaseSession session,
    List<SessionRecap> rows, {
    required _is.ColumnSelections<SessionRecapTable> conflictColumns,
    _is.ColumnSelections<SessionRecapTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionRecapTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SessionRecap>(
      rows,
      conflictColumns: conflictColumns(SessionRecap.t),
      updateColumns: updateColumns?.call(SessionRecap.t),
      updateWhere: updateWhere?.call(SessionRecap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SessionRecap] and returns the resulting row.
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
  /// The returned [SessionRecap] will have its `id` field set.
  Future<SessionRecap?> upsertRow(
    _is.DatabaseSession session,
    SessionRecap row, {
    required _is.ColumnSelections<SessionRecapTable> conflictColumns,
    _is.ColumnSelections<SessionRecapTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionRecapTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SessionRecap>(
      row,
      conflictColumns: conflictColumns(SessionRecap.t),
      updateColumns: updateColumns?.call(SessionRecap.t),
      updateWhere: updateWhere?.call(SessionRecap.t),
      transaction: transaction,
    );
  }

  /// Updates all [SessionRecap]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionRecap>> update(
    _is.DatabaseSession session,
    List<SessionRecap> rows, {
    _is.ColumnSelections<SessionRecapTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SessionRecap>(
      rows,
      columns: columns?.call(SessionRecap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SessionRecap]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SessionRecap> updateRow(
    _is.DatabaseSession session,
    SessionRecap row, {
    _is.ColumnSelections<SessionRecapTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SessionRecap>(
      row,
      columns: columns?.call(SessionRecap.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SessionRecap] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SessionRecap?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SessionRecapUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SessionRecap>(
      id,
      columnValues: columnValues(SessionRecap.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SessionRecap]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionRecap>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SessionRecapUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SessionRecapTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionRecapTable>? orderBy,
    _is.OrderByListBuilder<SessionRecapTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SessionRecap>(
      columnValues: columnValues(SessionRecap.t.updateTable),
      where: where(SessionRecap.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionRecap.t),
      orderByList: orderByList?.call(SessionRecap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SessionRecap]s in the list and returns the deleted rows.
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
  Future<List<SessionRecap>> delete(
    _is.DatabaseSession session,
    List<SessionRecap> rows, {
    _is.OrderByBuilder<SessionRecapTable>? orderBy,
    _is.OrderByListBuilder<SessionRecapTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SessionRecap>(
      rows,
      orderBy: orderBy?.call(SessionRecap.t),
      orderByList: orderByList?.call(SessionRecap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SessionRecap].
  Future<SessionRecap> deleteRow(
    _is.DatabaseSession session,
    SessionRecap row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SessionRecap>(
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
  Future<List<SessionRecap>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionRecapTable> where,
    _is.OrderByBuilder<SessionRecapTable>? orderBy,
    _is.OrderByListBuilder<SessionRecapTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SessionRecap>(
      where: where(SessionRecap.t),
      orderBy: orderBy?.call(SessionRecap.t),
      orderByList: orderByList?.call(SessionRecap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionRecapTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SessionRecap>(
      where: where?.call(SessionRecap.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SessionRecap] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionRecapTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SessionRecap>(
      where: where(SessionRecap.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
