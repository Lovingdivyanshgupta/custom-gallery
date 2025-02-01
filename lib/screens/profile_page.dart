import 'package:flutter/material.dart';

// final GlobalKey keyTwo = GlobalKey();
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen(
      {Key? key, this.userDataInMap, this.logoutUserOnPressed})
      : super(key: key);
  final Map<String, dynamic>? userDataInMap;
  final VoidCallback? logoutUserOnPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: logoutUserOnPressed,
              icon: const Icon(Icons.logout),
            ),
            Container(
              color: Colors.blue,
              child: (userDataInMap!['picture'] == null)
                  ? const Text("No profile pic available")
                  : Image.network(
                userDataInMap!['picture']['data']['url'],
                width: 30,
                height: 30,
              ),
            ),
            Text(userDataInMap!['name']),
            Text(userDataInMap!['email']),
            Container(
              color: Colors.white,
              height: 400,
              width: 400,
              child: Text(
                userDataInMap.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
