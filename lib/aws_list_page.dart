import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hipsterassignment/graph_ql_service.dart';
import 'package:hipsterassignment/services/chime_service.dart';
import 'package:hipsterassignment/state/user_state.dart';
import 'package:hipsterassignment/videocall/video_call_page.dart';
import 'event/user_bloc.dart';
import 'event/user_event.dart';

class AwsListScreen extends StatefulWidget {
  const AwsListScreen({super.key});

  @override
  State<AwsListScreen> createState() => _AwsListScreenState();
}

class _AwsListScreenState extends State<AwsListScreen> {
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
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              return Column(
                children: [
                  const Divider(height: 1),
                  Expanded(
                    child:  ListView.builder(
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
                                      callerId: user.id=="2"?"1":"2",
                                      attendeeId: user.id
                                  );

                                  Get.to( () => VideoCallPage(meeting: meeting['Meeting'],atendee:meeting['Attendees']));
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
                    )
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
