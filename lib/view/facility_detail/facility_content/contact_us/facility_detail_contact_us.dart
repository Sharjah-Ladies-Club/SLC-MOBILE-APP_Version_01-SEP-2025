import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/utils/integer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/utils.dart';

// ignore: must_be_immutable
class FacilityDetailContactUs extends StatelessWidget {
  List<ContactList> contactList;
  String colorCode;

  FacilityDetailContactUs(this.contactList, this.colorCode);

  @override
  Widget build(BuildContext context) {
    return ContactUs(contactList, colorCode);
  }
}

// ignore: must_be_immutable
class ContactUs extends StatefulWidget {
  List<ContactList> contactList;
  String colorCode;

  ContactUs(this.contactList, this.colorCode);

  @override
  State<StatefulWidget> createState() {
    return ContactUsState();
  }
}

class ContactUsState extends State<ContactUs> {
  Utils util = Utils();

  @override
  Widget build(BuildContext context) {
    return getContactInfoScreen(widget.contactList);
  }

  Widget getContactInfoScreen(List<ContactList> list) {
    return list.length > 0
        ? Card(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                      child: GestureDetector(
                    child: list[index].contactTypeId == Integer.phone1 ||
                            list[index].contactTypeId == Integer.phone2
                        ? ListTile(
                            trailing: Container(
                              decoration: BoxDecoration(
//                                  color: Color.fromRGBO(14, 150, 119, 1),
                                  color: ColorData.toColor(widget.colorCode),
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  PhoneCustomIcon.local_phone,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: Text(
                              list[index].contactValue,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: tr("currFontFamilyEnglishOnly"),
                                  color: ColorData.primaryTextColor),
                            ),
                          )
                        : list[index].contactTypeId == Integer.mail1 ||
                                list[index].contactTypeId == Integer.mail2
                            ? ListTile(
                                trailing: Container(
                                  decoration: BoxDecoration(
//                                      color: Color.fromRGBO(14, 150, 119, 1),
                                      color:
                                          ColorData.toColor(widget.colorCode),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(CommonIcons.mail,
                                        size: 18, color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  list[index].contactValue,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily:
                                          tr("currFontFamilyEnglishOnly"),
                                      color: ColorData.primaryTextColor),
                                ),
                              )
                            : list[index].contactTypeId == Integer.whatsApp
                                ? ListTile(
                                    trailing: Container(
                                      decoration: BoxDecoration(
//                                      color: Color.fromRGBO(14, 150, 119, 1),
                                          color: ColorData.toColor(
                                              widget.colorCode),
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(WhatsAppIcon.whatsapp,
                                            size: 18, color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      list[index].contactValue,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily:
                                              tr("currFontFamilyEnglishOnly"),
                                          color: ColorData.primaryTextColor),
                                    ),
                                  )
                                : ListTile(
                                    // trailing: Icon(
                                    //   Icons.location_city,
                                    //   color: Color.fromRGBO(14, 150, 119, 1),
                                    // ),
                                    title: Text(
                                      list[index].contactValue,
                                      style: TextStyle(
                                          color: ColorData.primaryTextColor),
                                    ),
                                  ),
                    onTap: () {
                      list[index].contactTypeId == Integer.phone1 ||
                              list[index].contactTypeId == Integer.phone2
                          ? launch("tel://" + list[index].contactValue)
                          : list[index].contactTypeId == Integer.mail1 ||
                                  list[index].contactTypeId == Integer.mail2
                              ? send(list[index].contactValue, context)
                              : list[index].contactTypeId == Integer.whatsApp
                                  ? goToWhatsApp(Constants.whatsAppURL(
                                      list[index].contactValue,
                                      list[index].defaultText))
                                  // ignore: unnecessary_statements
                                  : "";
                    },
                  )),
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
            ),
          )
        : Center(
            child: Text(tr("noDataFound"),
                style: TextStyle(
                    color: ColorData.primaryTextColor,
                    fontFamily: tr("currFontFamily"))),
          );
  }

  Future<void> send(String mailId, BuildContext context) async {
    final Email email = Email(
      recipients: [mailId],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorData.accentColor,
        content: Text(
          tr("emailClientNotFoundError"),
        ),
      ));
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: ColorData.accentColor,
      //     content: Text(
      //       tr("emailClientNotFoundError"),
      //     ),
      //   ),
      // );
      print(error);
    }
  }

  Future<void> goToWhatsApp(whatsAppURL) async {
    debugPrint(whatsAppURL);
    await canLaunch(whatsAppURL)
        ? launch(whatsAppURL)
        : util.customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("whatsAppNotInstalled"), context);
  }
}
