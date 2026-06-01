import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/config/app_config.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';
import 'package:sejasa/domain/entities/user_entity.dart';
import 'package:sejasa/domain/value_objects/gender_type.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';
import 'package:sejasa/core/utils/my_snackbar.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_bloc.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_state.dart';

class UserProfileHeaderWidget extends HookWidget {
  final UserEntity user;

  const UserProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final locationService = context.read<LocationService>();
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
      padding: EdgeInsets.symmetric(vertical: 12.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35.r,
                      backgroundColor: const Color(0xFFD9D9D9),
                      backgroundImage: photoProfile.value,
                      child: photoProfile.value == null
                          ? Icon(Icons.person, color: Colors.white, size: 45.r)
                          : null,
                    ),
                    SizedBox(width: 16.w),
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
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),

                              if (user.gender == GenderType.male)
                                Icon(
                                  LucideIcons.mars,
                                  size: 16.r,
                                  color: Colors.blue,
                                )
                              else if (user.gender == GenderType.female)
                                Icon(
                                  LucideIcons.venus,
                                  size: 16.r,
                                  color: Colors.pink,
                                )
                              else
                                Icon(
                                  LucideIcons.user,
                                  size: 16.r,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                          SizedBox(height: 4.h),
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
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black87,
                                ),
                              );
                            },
                          ),
                          Row(
                            spacing: 6.w,
                            children: [
                              RatingBarIndicator(
                                itemBuilder: (context, index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                                itemCount: 5,
                                rating: user.rating,
                                itemSize: 20.r,
                              ),
                              Text(
                                user.rating.toStringAsFixed(1),
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
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18.r,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        address.value,
                        overflow: TextOverflow.visible,
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
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Text(
              user.description ?? "User malas mengisi bio....",
              style: TextStyle(fontSize: 14.sp),
            ),
          ),

          const Divider(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Keahlian",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isMyProfile)
                      IconButton(
                        icon: Icon(LucideIcons.pencil, size: 16.r),
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
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
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
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Info Kontak",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                if (user.contact != null)
                  Row(
                    children: [
                      Icon(
                        LucideIcons.phone,
                        size: 18.r,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 8.w),
                      Text(user.contact!),
                    ],
                  ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      LucideIcons.mail,
                      size: 18.r,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
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

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _addSkill(BuildContext context) async {
    final name = _skillController.text.trim();
    if (name.isEmpty) return;
    context.read<AuthBloc>().add(AuthSkillAddRequested(name));
    _skillController.clear();
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
                context.read<AuthBloc>().add(
                  AuthSkillEditRequested(skillId, newName),
                );
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
    if (context.mounted) {
      context.read<AuthBloc>().add(AuthSkillDeleteRequested(skillId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = context.watch<AuthBloc>().state;
    final skills = authState.user?.skills ?? [];
    final isLoading = authState.status == AuthStatus.loading;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.message != current.message,
      listener: (context, state) {
        if (state.status == AuthStatus.success &&
            state.message != null &&
            state.message!.contains("Keahlian")) {
          MySnackbar.success(title: "Sukses", message: state.message!);
        } else if (state.status == AuthStatus.error) {
          MySnackbar.error(
            title: "Gagal",
            message: state.message ?? "Terjadi kesalahan.",
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
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
                    fontSize: 18.sp,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: 12.h),
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
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    onSubmitted: (_) => _addSkill(context),
                  ),
                ),
                SizedBox(width: 8.w),
                FilledButton(
                  onPressed: isLoading ? null : () => _addSkill(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.all(12.r),
                    minimumSize: Size(48.w, 48.h),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 18.w,
                          height: 18.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Icon(LucideIcons.plus, size: 20.r),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              "Keahlian Saya (${skills.length})",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            if (skills.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: Text(
                    "Anda belum menambahkan keahlian apapun.",
                    style: TextStyle(color: Colors.grey, fontSize: 13.sp),
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
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              skill.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  LucideIcons.pencil,
                                  size: 16.r,
                                  color: colorScheme.primary,
                                ),
                                onPressed: isLoading
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
                                icon: Icon(
                                  LucideIcons.trash2,
                                  size: 16.r,
                                  color: Colors.red,
                                ),
                                onPressed: isLoading
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
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
