import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_app_bar/bloc/bloc.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/utils/booleans.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({Key key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomAppBarBloc, CustomAppBarState>(
        builder: (context, state) {
      if (state is UpdateNotificationBadge) {
        Booleans.isChecked = false;
        if (state.isShowBadge) {
          return Stack(
            children: <Widget>[
              Icon(CustomIcons.notification, size: 25, color: Colors.grey),
              Positioned(
                right: 1,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 10,
                    minHeight: 10,
                  ),
                  child: new Container(
                    padding: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      color: ColorData.colorBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
              )
            ],
          );
        } else {
          return Icon(CustomIcons.notification, size: 25, color: Colors.grey);
        }
      }
      return Icon(CustomIcons.notification, size: 25, color: Colors.grey);
    });
  }
}
