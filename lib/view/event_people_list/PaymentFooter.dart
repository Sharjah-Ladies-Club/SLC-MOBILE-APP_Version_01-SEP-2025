import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/theme/styles.dart';

class PaymentFooter extends StatelessWidget {
  final String originalAmt;
  final String subItem;
  final String subItemAmt;

  //final String original;
  //final String finalTxt;
  //final String rateTxt;
  final Function rateTxtOnTap;

  const PaymentFooter(
      {Key key,
      this.originalAmt,
      this.subItem,
      this.subItemAmt,
      // this.original = "Original Amount",
      // this.finalTxt="Final Amount",
      // this.rateTxt="(Final amount Inclusive of VAT and applicable taxes)",
      this.rateTxtOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.70,
          margin: EdgeInsets.only(right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Text(tr("original_Amount"),
                          style: EventDetailPageStyle.eventOriginalStyleWithAr(
                              context))),
                  subItem != ""
                      ? Container(
                          child: Text("" + subItem,
                              style:
                                  EventDetailPageStyle.eventOriginalStyleWithAr(
                                      context)),
                          margin: EdgeInsets.only(top: 12, bottom: 12))
                      : Container(margin: EdgeInsets.only(top: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Text(
                            "AED  ",
                            style: EventDetailPageStyle
                                .eventDetailPageTextStyleWithAr(context),
                          ),
                          Text(
                            " " +
                                double.parse(originalAmt, (e) {
                                  return 0;
                                }).toStringAsFixed(2),
                            style: EventDetailPageStyle
                                .eventDetailPageTextStyleWithAr(context),
                          ),
                        ],
                      )),
                  subItem != ""
                      ? Container(
                          margin: EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              Text(
                                "AED  ",
                                style: EventDetailPageStyle
                                    .eventDetailPageTextStyleWithAr(context),
                              ),
                              Text(
                                " " +
                                    double.parse(originalAmt, (e) {
                                      return 0;
                                    }).toStringAsFixed(2),
                                style: EventDetailPageStyle
                                    .eventDetailPageTextStyleWithAr(context),
                              ),
                            ],
                          ))
                      : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    margin: EdgeInsets.only(top: 12),
                    child: Divider(
                      thickness: 1,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.70,
          margin: EdgeInsets.only(right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      tr("final_Amount"),
                      style:
                          EventDetailPageStyle.eventDetailPageTextStyleWithAr(
                              context),
                    ),
                    margin: EdgeInsets.only(top: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(
                            "AED   ",
                            style: EventDetailPageStyle
                                .eventDetailPageTextStyleWithAr(context),
                          ),
                          Text(
                            "" +
                                (double.parse(originalAmt, (e) {
                                          return 0;
                                        }) -
                                        double.parse(subItemAmt, (e) {
                                          return 0;
                                        }))
                                    .toStringAsFixed(2),
                            style: EventDetailPageStyle
                                .eventDetailPageTextStyleWithAr(context),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            if (rateTxtOnTap != null) rateTxtOnTap();
          },
          highlightColor: Color(0x00000000),
          splashColor: Color(0x00000000),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12, right: 15),
                child: Text(
                  tr("rate_Txt"),
                  style: TextStyle(
                      fontSize: 12,
                      color: (rateTxtOnTap != null)
                          ? Colors.lightBlue
                          : Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
