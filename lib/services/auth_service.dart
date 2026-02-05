import 'package:flutter_pos/utils/extensions.dart';
import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/repositories/pos_repository.dart';
import 'package:flutter_pos/utils/security.dart';

class AuthService {
  final PosRepository repo;
  AuthService(this.repo);

  AppUser? _session;
  AppUser? get session => _session;

  AppUser login(String pin) {
    if (pin.length != 6) {
      throw Exception('PIN harus 6 digit');
    }
    final pinHash = hashPin(pin);
    final user = repo.users.where((u) => u.pinHash == pinHash).firstOrNull;
    if (user == null) throw Exception('PIN tidak valid');
    _session = user;
    return user;
  }

  void logout() => _session = null;
}
