import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/screens/auth/login.dart';
import 'package:progress_app/services/account.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({ Key? key }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String name = "", email = "", profileUrl = "";

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    var user = await Account().getAuthUser();

    setState(() {
      name = user.name;
      email = user.email;
      profileUrl = user.profileUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profileUrl == "")
                  Icon(Icons.person_outlined, size: 30,)
                else
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(profileUrl),
                  ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ]
            )
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard_outlined,
            press: () {
              Navigator.pushReplacementNamed(
                context,
                '/dashboard'
              );
            },
          ),
          DrawerListTile(
            title: "Projects",
            icon: Icons.poll_outlined,
            press: () {
              Navigator.pushNamed(
                context,
                '/projects'
              );
            },
          ),
          DrawerListTile(
            title: "Notification",
            icon: Icons.notifications_outlined,
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            icon: Icons.person_outline,
            press: () => Navigator.pushNamed(
                context,
                '/profile'
              ),
          ),
          DrawerListTile(
            title: "Account & Security",
            icon: Icons.security,
            press: () => {},
          ),
          Divider(),
          DrawerListTile(
            title: 'Logout',
            icon: Icons.logout_outlined,
            isDanger: true,
            press: () => _logout(),
          )
        ],
      ),
    );
  }

  void _logout() async {
    var result = await Account().logout();

    if (result['success'] == true) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => const LoginScreen()
        ),
      );
    }
  }
}

class DrawerListTile extends StatelessWidget {

  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    this.icon = Icons.circle_outlined,
    this.isDanger = false,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: isDanger ? Colors.red : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDanger ? Colors.red : Colors.black54
        ),
      ),
    );
  }
}