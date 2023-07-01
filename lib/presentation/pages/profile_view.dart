import 'package:flutter/material.dart';
import 'package:minwell/commons/commons.dart';


class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: background, child: const Center(child: Text('Page 1')));;
  }
}