import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:recipe_app/blocs/user_bloc/user_state.dart';
import 'package:recipe_app/ui/screens/edit_profile_page.dart';
import 'package:recipe_app/ui/screens/tabs/liked.dart';
import 'package:recipe_app/ui/screens/tabs/posts.dart';
import 'package:recipe_app/ui/screens/tabs/saved.dart';
import 'package:recipe_app/utils/current_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<UserBloc>()
        .add(GetUserEvent(CurrentUser.currentUser!.localId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.login))],
        leading: const SizedBox(),
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserStateLoaded) {
          final user = state.userModel;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: user.imageUrl.trim().isNotEmpty
                                  ? NetworkImage(user.imageUrl)
                                  : null,
                              backgroundColor: Colors.deepOrange,
                              radius: 40,
                              child: user.imageUrl.trim().isEmpty
                                  ? Text(
                                      user.name.isEmpty
                                          ? 'U'
                                          : user.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name.isEmpty ? 'User' : user.name,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(user.email.isEmpty
                                      ? CurrentUser.currentUser?.email ??
                                          "Your email"
                                      : user.email),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (cxt) =>
                                              EditProfilePage(user: user),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      if (user.bio.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Biography",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  user.bio.isEmpty ? 'Your Bio' : user.bio,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 25),
                    ],
                  ),
                )
              ];
            },
            body: const DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: TabBar(tabs: [
                      Text("Posts"),
                      Text("Saved"),
                      Text("Liked"),
                    ]),
                  ),
                  Expanded(
                    flex: 25,
                    child: TabBarView(children: [
                      PostsTab(),
                      SavedTab(),
                      LikedTab(),
                    ]),
                  )
                ],
              ),
            ),
          );
        } else if (state is UserStateError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('No user data available'));
        }
      },
    );
  }
}
