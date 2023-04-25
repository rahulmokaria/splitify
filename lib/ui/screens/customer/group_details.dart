import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/colors.dart';
import 'split_bills.dart';

class GroupDetails extends StatefulWidget {
  Group group;
  GroupDetails({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_width * 10),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width * 0.1),
            ),
            color: secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              MediaQuery.of(context).size.width * 0.1),
                          topRight: Radius.circular(
                              MediaQuery.of(context).size.width * 0.1),
                          // bottomLeft: Radius.circular(
                          // MediaQuery.of(context).size.width * 0.1),
                          // bottomRight: Radius.circular(
                          // MediaQuery.of(context).size.width * 0.1),
                        ),
                        child: Image.asset(
                          // widget.cUser.backCoverImg
                          'assets/greenbg.jpg',
                          height: _width * 50,
                          width: _width * 100,
                          fit: BoxFit.cover,
                        ),
                        // Image.network(
                        // widget.cUser.backCoverImg
                        // 'https://www.google.com/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fgreen-pattern&psig=AOvVaw3AJls4ZmJ5xErylYVzwYPx&ust=1682516876441000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCPjhkfiVxf4CFQAAAAAdAAAAABAJ',
                        // height: _width * 50,
                        // width: _width * 100,
                        // fit: BoxFit.cover,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.3,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.25),
                      child: Container(
                        color: secondary,
                        height: MediaQuery.of(context).size.width * 0.44,
                        width: MediaQuery.of(context).size.width * 0.44,
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.32,
                    left: MediaQuery.of(context).size.width * 0.07,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.2),
                      child: Container(
                        color: secondary,
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Image.network(
                          widget.group.profilePicUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                widget.group.groupName,
                textScaleFactor: 1.5,
                style: const TextStyle(
                  color: white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
