import 'package:sejasa/modules/auth/view/register_screen.dart';

/// Jenis akun yang dipilih user saat register.
/// Dipakai juga sebagai parameter ke [RegisterScreen].
enum AccountType {
  personal('personal', 'Personal'),
  organization('organization', 'Organisasi');

  final String jsonValue;
  final String display;
  const AccountType(this.jsonValue, this.display);

  static AccountType fromJson(String value) {
    return AccountType.values.firstWhere(
      (element) => element.jsonValue == value,
      orElse: () => throw Exception('Tipe akun tidak diketahui: $value'),
    );
  }
}
