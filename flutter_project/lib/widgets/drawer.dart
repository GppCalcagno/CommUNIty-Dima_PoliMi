import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerForNavigation extends StatelessWidget {
  const DrawerForNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: Key("Drawer"),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: const [
          DrawerHead(),
          DrawerBody(),
        ],
      ),
    );
  }
}

class DrawerHead extends StatelessWidget {
  const DrawerHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: DrawerHeader(
        //margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
        ),
        child: Column(children: [
          InkWell(
            onTap: () => context.go("/profile"),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL.toString(),
                    ),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Flexible(
            child: Text(
              FirebaseAuth.instance.currentUser!.displayName.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              FirebaseAuth.instance.currentUser!.email.toString(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
      ),
    );
  }
}

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 4,
      children: [
        ListTile(
          leading: const Icon(Icons.school_outlined, color: Colors.deepOrangeAccent),
          title: const Text(
            'Courses',
            textScaleFactor: 1.1,
          ),
          onTap: () {
            // Update the state of the app
            context.go("/courses");
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.book_outlined, color: Colors.blue),
          title: const Text(
            'Bookshelf',
            textScaleFactor: 1.1,
          ),
          onTap: () {
            // Update the state of the app
            context.go("/booklist");
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.share_location_outlined, color: Colors.green),
          title: const Text(
            'Network',
            textScaleFactor: 1.1,
          ),
          onTap: () {
            // Update the state of the app
            context.go("/positionlist");
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat_outlined, color: Colors.amber),
          title: const Text(
            'Chat',
            textScaleFactor: 1.1,
          ),
          onTap: () {
            // Update the state of the app
            context.go("/groupchatlist");
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings_outlined, color: Colors.grey),
          title: const Text(
            'Settings',
            textScaleFactor: 1.1,
          ),
          onTap: () {
            // Update the state of the app
            context.go("/settings");
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Logout',
            textScaleFactor: 1.1,
          ),
          onTap: () {
            signOut(context);
            // Update the state of the app

            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void signOut(BuildContext context) {
    debugPrint("HomePageScreen: signOut");
    context.go('/login');
    FirebaseAuth.instance.signOut();
  }
}
