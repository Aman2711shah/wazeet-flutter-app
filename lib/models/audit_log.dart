class AuditLog {
  final String id; 
  final String? actorId; 
  final String action; 
  final String? target; 
  final DateTime createdAt;
  AuditLog({
    required this.id,
    this.actorId,
    required this.action,
    this.target,
    required this.createdAt,
  });
  factory AuditLog.fromJson(Map<String, dynamic> j) => AuditLog(
    id: j['id'] as String,
    actorId: j['actor_id'] as String?,
    action: j['action'] as String,
    target: j['target'] as String?,
    createdAt: DateTime.parse(j['created_at'] as String),
  );
}
