import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hipsterassignment/GraphQLService.dart';
import 'package:hipsterassignment/services/ChimeService.dart';
import 'package:hipsterassignment/state/user_state.dart';
import 'package:hipsterassignment/videocall/VideoCallPage.dart';
import 'event/user_bloc.dart';
import 'event/user_event.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = GraphQLService.initClient().value;
    return BlocProvider(
      create: (_) => UserBloc(client)..add(FetchUsers()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
          actions: [
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<UserBloc>().add(FetchUsers());
              },
            ),
          ],
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter name to add',
                              prefixIcon: const Icon(Icons.person_add_alt),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2575FC),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final name = nameController.text.trim();
                              if (name.isNotEmpty) {
                                context
                                    .read<UserBloc>()
                                    .add(AddUserByName(name));
                                nameController.clear();
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2575FC),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<UserBloc>().add(FetchUsers());
                        await Future.delayed(
                            const Duration(milliseconds: 400));
                      },
                      child: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.avatar),
                            ),
                            title: Text(user.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.videocam_outlined),
                              tooltip: 'Start video call',
                              onPressed: () async {
                                try {
                                  final meeting = await ChimeService.initiateCall(
                                    name:"amil",
                                    attendeeId: user.id
                                  );
                                  Get.to( () => VideoCallPage(meeting: meeting));
                                } catch (e) {
                                  Get.snackbar(
                                    'Call failed',
                                    e.toString(),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is UserError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const Center(child: Text("Press button to fetch users"));
          },
        ),
      ),
    );
  }
}
