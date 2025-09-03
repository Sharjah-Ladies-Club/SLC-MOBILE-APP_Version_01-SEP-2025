import 'package:flutter/material.dart';
import 'package:slc/theme/images.dart';

// ignore: must_be_immutable
class LoginPageImage extends StatelessWidget {
  String title;

  LoginPageImage(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      width: MediaQuery.of(context).size.width / 3.0,
      decoration: BoxDecoration(),
      child: title == "register"
          ? Image.asset(
              ImageData.otp_img,
              // height: MediaQuery.of(context).size.height / 8,
            )
          : Image.asset(
              ImageData.loginLogoImgPath,
            ),
      // child: Image.asset(ImageData.loginLogoImgPath,height: 120.0,width: 120.0)
    );
  }
}

class NotificationAppBarImage extends StatelessWidget {
  const NotificationAppBarImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageData.loginLogoImgPath),
          fit: BoxFit.none,
//              colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
        ),
      ),
      // child: Image.asset(ImageData.loginLogoImgPath,height: 120.0,width: 120.0)
    );
  }
}
