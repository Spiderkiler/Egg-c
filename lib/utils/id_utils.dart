/// ID生成工具类
/// 使用UUID生成全局唯一标识
import 'package:uuid/uuid.dart';

class IdUtils {
  static const Uuid _uuid = Uuid();

  /// 生成唯一ID（短格式，取UUID前8位）
  static String generateId() {
    return _uuid.v4().substring(0, 8);
  }

  /// 生成完整UUID
  static String generateUuid() {
    return _uuid.v4();
  }
}
