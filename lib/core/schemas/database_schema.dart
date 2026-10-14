class DatabaseSchema {
  DatabaseSchema._();

  static const String databaseName = 'marga_mulya.db';
  static const int databaseVersion = 1;

  // Tables
  static const String tableUsers = 'users';
  static const String tableSettings = 'settings';
  static const String tableSyncQueue = 'sync_queue';

  // Users Table Columns
  static const String colUserId = 'id';
  static const String colUserName = 'name';
  static const String colUserEmail = 'email';
  static const String colUserRole = 'role';
  static const String colUserAvatar = 'avatar_url';
  static const String colUserCreatedAt = 'created_at';
  static const String colUserUpdatedAt = 'updated_at';

  // Settings Table Columns
  static const String colSettingKey = 'key';
  static const String colSettingValue = 'value';

  // Sync Table Columns
  static const String colSyncId = 'id';
  static const String colSyncEndpoint = 'endpoint';
  static const String colSyncPayload = 'payload';
  static const String colSyncMethod = 'method';
  static const String colSyncStatus = 'status'; // pending, success, failed
  static const String colSyncCreatedAt = 'created_at';

  // Table Creation DDLs
  static const String createUsersTable = '''
    CREATE TABLE $tableUsers (
      $colUserId TEXT PRIMARY KEY,
      $colUserName TEXT NOT NULL,
      $colUserEmail TEXT NOT NULL,
      $colUserRole TEXT,
      $colUserAvatar TEXT,
      $colUserCreatedAt TEXT,
      $colUserUpdatedAt TEXT
    )
  ''';

  static const String createSettingsTable = '''
    CREATE TABLE $tableSettings (
      $colSettingKey TEXT PRIMARY KEY,
      $colSettingValue TEXT NOT NULL
    )
  ''';

  static const String createSyncQueueTable = '''
    CREATE TABLE $tableSyncQueue (
      $colSyncId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colSyncEndpoint TEXT NOT NULL,
      $colSyncPayload TEXT NOT NULL,
      $colSyncMethod TEXT NOT NULL,
      $colSyncStatus TEXT NOT NULL,
      $colSyncCreatedAt TEXT NOT NULL
    )
  ''';
}
