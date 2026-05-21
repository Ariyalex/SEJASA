import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Custom DropdownMenu yang sudah dibungkus dengan styling bawaan aplikasi.
/// Menggunakan Generic [T] agar bisa digunakan untuk Enum atau Model apa saja.
class MyDropdownField<T> extends HookWidget {
  /// Daftar pilihan yang akan ditampilkan di dalam Dropdown
  final List<DropdownMenuEntry<T>> entries;

  /// Nilai awal yang terpilih (opsional)
  final T? initialSelection;

  /// Teks yang muncul saat belum ada yang dipilih
  final String? hintText;

  /// Label di atas Dropdown
  final String? labelText;

  /// Callback ketika pengguna memilih sebuah opsi
  final void Function(T?)? onSelected;

  /// Validasi (opsional)
  final String? Function(T?)? validator;

  /// Ikon di sebelah kiri dropdown (opsional)
  final Widget? leadingIcon;

  /// Jika true, Dropdown akan mengambil seluruh lebar parent-nya
  final bool isExpanded;

  const MyDropdownField({
    super.key,
    required this.entries,
    this.initialSelection,
    this.hintText,
    this.labelText,
    this.onSelected,
    this.validator,
    this.leadingIcon,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Menyimpan state nilai yang sedang dipilih saat ini
    final selectedValue = useState<T?>(initialSelection);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Agar column tidak mengambil space berlebih
          children: [
            // Tampilkan Title di atas Dropdown jika labelText tidak null
            if (labelText != null) ...[
              Text(
                labelText!,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8), // Jarak antara label dan dropdown
            ],
            DropdownMenu<T>(
              // Jika isExpanded true, ambil seluruh lebar dari parent. Jika tidak, sesuaikan dengan isinya.
              width: isExpanded ? constraints.maxWidth : null,
              initialSelection: initialSelection,
              hintText: hintText,
              leadingIcon: leadingIcon,
              dropdownMenuEntries: entries,
              onSelected: (T? value) {
                selectedValue.value = value;
                if (onSelected != null) {
                  onSelected!(value);
                }
              },
              // Input decoration ini untuk membuat tampilannya seragam dengan textfield lain
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.error),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
