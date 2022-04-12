import 'package:flutter/material.dart';

class myAppBar extends StatelessWidget with PreferredSizeWidget {
  var title;

  myAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.red[400],
      elevation: 0,
      title: Text("$title",
          style: TextStyle(fontSize: 23, letterSpacing: 2, fontFamily: 'Lato')),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
