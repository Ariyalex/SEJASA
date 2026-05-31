import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sejasa/core/utils/my_snackbar.dart';
import 'package:sejasa/domain/entities/list_chat_item_entity.dart';

class ReviewBottomSheetContent extends StatefulWidget {
  final ListChatItemEntity chat;
  final String projectId;
  final Function(
    double rating,
    String review,
    void Function(String? error) onComplete,
  )
  onSubmit;

  const ReviewBottomSheetContent({
    super.key,
    required this.chat,
    required this.projectId,
    required this.onSubmit,
  });

  @override
  State<ReviewBottomSheetContent> createState() =>
      _ReviewBottomSheetContentState();
}

class _ReviewBottomSheetContentState extends State<ReviewBottomSheetContent> {
  late final TextEditingController _reviewController;
  double _currentRating = 5.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Rating Pelamar Proyek",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Beri penilaian untuk pelamar: ${widget.chat.title}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star_rounded, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _currentRating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${_currentRating.toInt()} dari 5 Bintang",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Tulis Ulasan Anda",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    "Berikan ulasan Anda mengenai kinerja pelamar pada proyek ini...",
                hintStyle: TextStyle(fontSize: 14, color: theme.hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_reviewController.text.trim().isEmpty) {
                          MySnackbar.warning(
                            message:
                                "Silakan masukkan ulasan Anda terlebih dahulu",
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        widget.onSubmit(
                          _currentRating,
                          _reviewController.text.trim(),
                          (error) {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                            if (error == null) {
                              Navigator.pop(context);
                              MySnackbar.success(
                                message: "Ulasan pelamar berhasil dikirim",
                              );
                            } else {
                              MySnackbar.error(
                                title: "Gagal Mengirim Ulasan",
                                message: error,
                              );
                            }
                          },
                        );
                      },
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : const Text(
                        "Kirim Penilaian",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewAllBottomSheetContent extends StatefulWidget {
  final String projectId;
  final Function(
    double rating,
    String review,
    void Function(String? error) onComplete,
  )
  onSubmit;

  const ReviewAllBottomSheetContent({
    super.key,
    required this.projectId,
    required this.onSubmit,
  });

  @override
  State<ReviewAllBottomSheetContent> createState() =>
      _ReviewAllBottomSheetContentState();
}

class _ReviewAllBottomSheetContentState
    extends State<ReviewAllBottomSheetContent> {
  late final TextEditingController _reviewController;
  double _currentRating = 5.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Rating Semua Pelamar Proyek",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Beri penilaian untuk seluruh pelamar yang berstatus Diterima sekaligus",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star_rounded, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _currentRating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${_currentRating.toInt()} dari 5 Bintang",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Tulis Ulasan Anda",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    "Berikan ulasan kolektif untuk seluruh pelamar yang diterima pada proyek ini...",
                hintStyle: TextStyle(fontSize: 14, color: theme.hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_reviewController.text.trim().isEmpty) {
                          MySnackbar.warning(
                            message:
                                "Silakan masukkan ulasan Anda terlebih dahulu",
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        widget.onSubmit(
                          _currentRating,
                          _reviewController.text.trim(),
                          (error) {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                            if (error == null) {
                              Navigator.pop(context);
                              MySnackbar.success(
                                message:
                                    "Penilaian semua pelamar berhasil dikirim",
                              );
                            } else {
                              MySnackbar.error(
                                title: "Gagal Mengirim Ulasan",
                                message: error,
                              );
                            }
                          },
                        );
                      },
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : const Text(
                        "Kirim Penilaian Semua",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
