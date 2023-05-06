import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class SettleUpWithFriend extends StatefulWidget {
  const SettleUpWithFriend({super.key});

  @override
  State<SettleUpWithFriend> createState() => _SettleUpWithFriendState();
}

class _SettleUpWithFriendState extends State<SettleUpWithFriend> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double height = MediaQuery.of(context).size.height * 0.01;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(width * 5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: secondary,
            border: Border.all(width: 1, color: green),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Record a payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: green,
                ),
              ),
              SizedBox(height: width * 5),
              Text(
                'Record a payment between you and friendName of amount 200',
                style: TextStyle(color: white),
              ),
              SizedBox(height: width * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: implement edit transaction functionality
                      // ed/itdata();
                      // Navigator.of(context).popUntil(( context, MaterialPageRout));
                      // if(Navigator.canPop(context)) {
                      //   // Navigator.canPop return true if can pop
                      //   Navigator.pop(context);
                      // }
                      // Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>TransactionPage()));
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Confirm'),
                  ),
                  SizedBox(width: width * 2.5),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
