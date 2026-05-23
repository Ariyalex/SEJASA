import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/config/app_config.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';
import 'package:sejasa/domain/entities/user_entity.dart';
import 'package:sejasa/domain/value_objects/gender_type.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/core/utils/my_snackbar.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_bloc.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_state.dart';

class UserProfileHeaderWidget extends HookWidget {
  final UserEntity user;

  const UserProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final locationService = getIt<LocationService>();
    final address = useState<String>('');
    final currentUser = context.watch<AuthBloc>().state.user;
    final isMyProfile = currentUser != null && currentUser.id == user.id;
    useEffect(() {
      if (user.address == null) {
        locationService
            .getAddressFromLatLng(LatLng(user.latitude, user.longitude))
            .then((value) {
              address.value = value;
            });
      } else {
        address.value = user.address!;
      }
      return null;
    }, [user]);

    final photoProfile = useState<ImageProvider?>(null);

    useEffect(() {
      if (user.profilePicture != null) {
        photoProfile.value = NetworkImage(
          AppConfig.baseUrl + user.profilePicture!,
        );
      }
      return null;
    }, [user]);

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFFD9D9D9),
                      backgroundImage: photoProfile.value,
                      child: Icon(Icons.person, color: Colors.white, size: 45),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),

                              if (user.gender == GenderType.male)
                                const Icon(
                                  LucideIcons.mars,
                                  size: 16,
                                  color: Colors.blue,
                                )
                              else if (user.gender == GenderType.female)
                                const Icon(
                                  LucideIcons.venus,
                                  size: 16,
                                  color: Colors.pink,
                                )
                              else
                                const Icon(
                                  LucideIcons.user,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          BlocBuilder<ProfilProjectBloc, ProfilProjectState>(
                            builder: (context, state) {
                              final createdProjects =
                                  state.uploadedProjects.length;
                              final completedProjects = state.takenProjects
                                  .where(
                                    (project) =>
                                        project.status ==
                                        ProjectStatus.completed,
                                  )
                                  .length;
                              return Text(
                                "$completedProjects diselesaikan - $createdProjects dibuat",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              );
                            },
                          ),
                          Row(
                            spacing: 6,
                            children: [
                              RatingBarIndicator(
                                itemBuilder: (context, index) {
                                  return Icon(Icons.star, color: Colors.amber);
                                },
                                itemCount: 5,
                                rating: user.rating,
                                itemSize: 20,
                              ),
                              Text(
                                user.rating.toString(),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address.value,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // Bagian 2: Deskripsi / Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              user.description ?? "User malas mengisi bio....",
              style: const TextStyle(fontSize: 14),
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Keahlian",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isMyProfile)
                      IconButton(
                        icon: const Icon(LucideIcons.pencil, size: 16),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                const _SkillManagementBottomSheet(),
                          );
                        },
                        visualDensity: VisualDensity.compact,
                        tooltip: "Kelola Keahlian",
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (user.skills == null || user.skills!.isEmpty)
                      const Text(
                        "User sangat malas hingga tidak punya skill...",
                      )
                    else
                      ...user.skills!.map(
                        (skill) => MyVisualChip(
                          title: skill.name,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          textColor: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Info Kontak",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (user.contact != null)
                  Row(
                    children: [
                      Icon(
                        LucideIcons.phone,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(user.contact!),
                    ],
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      LucideIcons.mail,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(user.email),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillManagementBottomSheet extends StatefulWidget {
  const _SkillManagementBottomSheet();

  @override
  State<_SkillManagementBottomSheet> createState() =>
      _SkillManagementBottomSheetState();
}

class _SkillManagementBottomSheetState
    extends State<_SkillManagementBottomSheet> {
  final TextEditingController _skillController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _addSkill(BuildContext context) async {
    final name = _skillController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final userProvider = getIt<RemoteUserProvider>();
      await userProvider.addMySkill(name);
      _skillController.clear();
      if (mounted) {
        context.read<AuthBloc>().add(AuthProfileRefreshed());
        MySnackbar.success(
          title: "Sukses",
          message: "Keahlian baru berhasil ditambahkan",
        );
      }
    } catch (e) {
      MySnackbar.error(
        title: "Gagal Menambahkan",
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _editSkill(
    BuildContext context,
    String skillId,
    String oldName,
  ) async {
    final editController = TextEditingController(text: oldName);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Edit Keahlian",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: "Nama keahlian...",
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                final newName = editController.text.trim();
                if (newName.isEmpty || newName == oldName) {
                  Navigator.pop(dialogContext);
                  return;
                }
                Navigator.pop(dialogContext);

                setState(() => _isLoading = true);
                try {
                  final userProvider = getIt<RemoteUserProvider>();
                  await userProvider.editMySkill(skillId, newName);
                  if (mounted) {
                    context.read<AuthBloc>().add(AuthProfileRefreshed());
                    MySnackbar.success(
                      title: "Sukses",
                      message: "Keahlian berhasil diperbarui",
                    );
                  }
                } catch (e) {
                  MySnackbar.error(
                    title: "Gagal Mengedit",
                    message: e.toString().replaceAll("Exception:", "").trim(),
                  );
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              child: const Text(
                "Simpan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSkill(BuildContext context, String skillId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Hapus Keahlian",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Apakah Anda yakin ingin menghapus keahlian ini?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                "Hapus",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final userProvider = getIt<RemoteUserProvider>();
      await userProvider.deleteMySkill(skillId);
      if (mounted) {
        context.read<AuthBloc>().add(AuthProfileRefreshed());
        MySnackbar.success(
          title: "Sukses",
          message: "Keahlian berhasil dihapus",
        );
      }
    } catch (e) {
      MySnackbar.error(
        title: "Gagal Menghapus",
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = context.watch<AuthBloc>().state;
    final skills = authState.user?.skills ?? [];

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kelola Keahlian",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillController,
                  decoration: InputDecoration(
                    hintText: "Tambah keahlian baru...",
                    filled: true,
                    fillColor: const Color(0xFFEEEEEE),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _addSkill(context),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _isLoading ? null : () => _addSkill(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  minimumSize: const Size(48, 48),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(LucideIcons.plus, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Keahlian Saya (${skills.length})",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (skills.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "Anda belum menambahkan keahlian apapun.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  final skill = skills[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            skill.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                LucideIcons.pencil,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () => _editSkill(
                                      context,
                                      skill.id.toString(),
                                      skill.name,
                                    ),
                              visualDensity: VisualDensity.compact,
                              tooltip: "Ubah keahlian",
                            ),
                            IconButton(
                              icon: const Icon(
                                LucideIcons.trash2,
                                size: 16,
                                color: Colors.red,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () => _deleteSkill(
                                      context,
                                      skill.id.toString(),
                                    ),
                              visualDensity: VisualDensity.compact,
                              tooltip: "Hapus keahlian",
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
