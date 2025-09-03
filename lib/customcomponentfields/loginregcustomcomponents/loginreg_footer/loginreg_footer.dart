import 'package:flutter/material.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_text_span/loginreg_text_span.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/utils/constant.dart';

// ignore: must_be_immutable
class LoginRegFooter extends StatelessWidget {
  String btnTitle;
  String navigationPagetitle;

  LoginRegFooter(this.btnTitle, this.navigationPagetitle);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: !Constants.iSEditClickedInProfile
            ? LoginRegTextSpan(btnTitle)
            : Container(),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 6.4,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageData.bottom_img),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
