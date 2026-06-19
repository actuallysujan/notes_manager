import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_manager/core/app_colors.dart';
import 'package:notes_manager/core/common_utils.dart';
import 'package:notes_manager/core/custom_textstyles.dart';
import 'package:notes_manager/core/dilogs.dart';
import 'package:notes_manager/models/notes_model.dart';
import 'package:notes_manager/services/auth_service.dart';
import 'package:notes_manager/views/notes/note_form_view.dart';
import 'package:toastification/toastification.dart';
import '../../viewmodels/notes_viewmodel.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String? userName = FirebaseAuth.instance.currentUser?.displayName;
  final NotesViewModel _notesViewModel = NotesViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showWelcomeToast();
    });
  }

  void showWelcomeToast() {
    // final args = ModalRoute.of(context)?.settings.arguments;
    // final name = (args is String && args.isNotEmpty) ? args : "there";

    toastification.show(
      context: context,
      type: ToastificationType.success,
      alignment: Alignment.topRight,
      title: const Text("Welcome back!"),
      description: Text("Glad to see you, $userName 👋"),
      autoCloseDuration: const Duration(seconds: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;

    int crossAxisCount = 1;
    if (screenWidth > 900) {
      crossAxisCount = 3;
    } else if (screenWidth > 600) {
      crossAxisCount = 2;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        titleSpacing: 20,
        title: StreamBuilder<List<NoteModel>>(
          stream: _notesViewModel.notesStream(userId),
          builder: (context, snapshot) {
            final count = snapshot.data?.length ?? 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),

                Text('All Notes', style: CustomTextstyles.b24Bold),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9A227),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      count == 0
                          ? "No notes yet"
                          : "$count ${count == 1 ? 'note' : 'notes'}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        letterSpacing: 0.6,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              // Profile header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.blackColor,
                      child: Text(
                        (user?.displayName?.isNotEmpty == true
                                ? user!.displayName![0]
                                : user?.email?[0] ?? '?')
                            .toUpperCase(),
                        style: CustomTextstyles.w24Bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.displayName?.isNotEmpty == true
                          ? user!.displayName!
                          : 'No name set',
                      style: CustomTextstyles.b18Bold,
                    ),
                    const SizedBox(height: 4),
                    Text(user?.email ?? '', style: CustomTextstyles.g12400),
                  ],
                ),
              ),
              const Divider(height: 1),

              // StreamBuilder<List<NoteModel>>(
              //   stream: _notesViewModel.notesStream(userId),
              //   builder: (context, snapshot) {
              //     final count = snapshot.data?.length ?? 0;
              //     return ListTile(
              //       leading: const Icon(Icons.note_outlined),
              //       title: const Text('Total Notes'),
              //       trailing: Text('$count', style: CustomTextstyles.b18Bold),
              //     );
              //   },
              // ),
              const Spacer(),
              const Divider(height: 1),

              // Logout
              ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                  color: AppColors.redColor,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.redColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await AuthService.instance.logout();

                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: appBackground(
        child: StreamBuilder<List<NoteModel>>(
          stream: _notesViewModel.notesStream(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.blackColor),
              );
            }

            final notes = snapshot.data ?? [];

            if (notes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_add_outlined,
                        size: 80,
                        color: const Color.fromARGB(255, 145, 143, 143),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No notes yet',
                        style: CustomTextstyles.b18Bold,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the plus button below to create your first note.',
                        textAlign: TextAlign.center,
                        style: CustomTextstyles.g12400,
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 124,
              ),
              itemCount: notes.length,
              itemBuilder: (context, i) {
                final note = notes[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Card(
                        color: AppColors.whiteColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[200]!, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteFormView(note: note),
                              ),
                            );
                            setState(() {});
                          },
                          child: Center(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[50],
                                child: const Icon(
                                  Icons.description,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              title: Text(
                                note.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextstyles.b18Bold,
                              ),
                              subtitle: Text(
                                note.description.isNotEmpty
                                    ? note.description
                                    : "No additional text",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextstyles.g12400,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red[300],
                                ),
                                onPressed: () async {
                                  final ok = await showConfirmDialog(
                                    context,
                                    'Delete note?',
                                  );
                                  if (ok == true) {
                                    await _notesViewModel.deleteNote(note.id);
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(
                        'Created ${DateFormatter.instance.formatDate(note.createdAt)}',
                        style: CustomTextstyles.g10400,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blackColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteFormView()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
    );
  }
}
