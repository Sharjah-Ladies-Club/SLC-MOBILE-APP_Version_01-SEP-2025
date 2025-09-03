import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../common/colors.dart';
import '../../../../common/custom_city_select_component.dart';
import '../../../../common/custom_eventtype_select_component.dart';
import '../../../../common/custom_time_select_component.dart';
import '../../../../common/custome_upload_doc_select_component.dart';
import '../../../../customcomponentfields/custom_event_date_component.dart';
import '../../../../customcomponentfields/loginregcustomcomponents/loginpagefiledwhite.dart';
import '../../../../gmcore/model/Meta.dart';
import '../../../../gmcore/storage/SPUtils.dart';
import '../../../../model/booking_timetable.dart';
import '../../../../model/facility_detail_response.dart';
import '../../../../model/facility_item.dart';
import '../../../../model/knooz_response_dto.dart';
import '../../../../model/partyhall_response.dart';
import '../../../../model/payment_terms_response.dart';
import '../../../../model/terms_condition.dart';
import '../../../../repo/facility_detail_repository.dart';
import '../../../../theme/customIcons.dart';
import '../../../../theme/styles.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/datetime_utils.dart';
import '../../../../utils/flutter_masked_text.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/textinputtypefile.dart';
import '../../../../utils/url_utils.dart';
import '../../../../utils/utils.dart';
import '../../../partyhall/partyhall_confirmation_alert.dart';
import '../../facility_detail.dart';
import 'bloc/new_facility_hall_bloc.dart';
import 'bloc/new_facility_hall_event.dart';
import 'bloc/new_facility_hall_state.dart';

class HallBookingView extends StatelessWidget {
  final int facilityId;
  final int facilityItemId;
  final String colorCode;
  final bool isHall;
  final int bookingMode;
  final List<CateringType> cateringTypeList;
  final bool isPickup;
  const HallBookingView(
      {this.facilityId = 6,
      @required this.facilityItemId,
      @required this.colorCode,
      @required this.isHall,
      @required this.bookingMode,
      @required this.cateringTypeList,
      this.isPickup = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewFacilityHallBloc>(
      create: (context) => NewFacilityHallBloc(partyHallBloc: null)
        ..add(NewFacilityHallTermsData(
            facilityId: 6,
            facilityItemId: facilityItemId,
            partyHallDetailId: 0))
        ..add(GetFacilityPaymentTerms(facilityId: 6))
        ..add(NewFacilityHallKunoozEvent(bookingId: 0))
        ..add(NewFacilityHallDeliveryEvent(itemGroup: bookingMode))
        ..add(NewFacilityDocumentTypeEvent()),
      child: HallBookingPage(
        facilityId: facilityId,
        facilityItemId: facilityItemId,
        colorCode: colorCode,
        isHall: isHall,
        bookingMode: bookingMode,
        cateringTypeList: cateringTypeList,
        isPickup: isPickup,
      ),
    );
  }
}

class HallBookingPage extends StatefulWidget {
  final int facilityId;
  final int facilityItemId;
  final String colorCode;
  final bool isHall;
  final int bookingMode;
  final List<CateringType> cateringTypeList;
  final bool isPickup;
  const HallBookingPage(
      {@required this.facilityId,
      @required this.facilityItemId,
      @required this.colorCode,
      @required this.isHall,
      @required this.bookingMode,
      @required this.cateringTypeList,
      @required this.isPickup});

  @override
  State<HallBookingPage> createState() => _HallBookingPageState();
}

class _HallBookingPageState extends State<HallBookingPage> {
  Utils util = Utils();
  String colorCode;
  List<FacilityItem> hallList = [];

  String currentMenu = 'event_details';
  EventType _eventType = new EventType();
  DocumentType _docType = new DocumentType();
  PartyHallResponse partyHallDetail = new PartyHallResponse();
  PaymentTerms paymentTerms = new PaymentTerms();
  DeliveryCharges selectedDeliveryCharges = new DeliveryCharges();

  var serverReceiverPath = URLUtils().getImageFacilityUploadUrl();
  var serverTestPath = URLUtils().getImageResultUrl();

  bool showAddress = false;
  bool load = false;

  // MaskedTextController _textVenueControllers =
  //     new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController _textEventTypeControllers =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController _textDocTypeControllers =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  TextEditingController _customEventController = new TextEditingController();
  TextEditingController _customStartTimeController =
      new TextEditingController();
  // TextEditingController _customEndTimeController = new TextEditingController();
  // TextEditingController _customStartController = new TextEditingController();
  TextEditingController _customGuestsController = new TextEditingController();
  MaskedTextController _fEmiratesIdController =
      new MaskedTextController(mask: Strings.maskEmiratesIdValidationStr);
  MaskedTextController _commentController =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  MaskedTextController _streetName =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  MaskedTextController _landmark =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  MaskedTextController _city =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController _contactNo =
      new MaskedTextController(mask: Strings.maskMobileValidationStr);

  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();

  List<CateringType> cateringTypeList = [];
  List<RetailOrderItems> menuList;
  List<FacilityItem> facilityItems = [];
  List<EventType> eventTypes = [];
  List<PartyHallDocumentsDto> documents = [];
  List<RetailOrderItems> orderMenuList = [];
  List<TermsCondition> termsList = [];
  List<TermsCondition> importantTerms = [];
  List<FacilityBeachRequest> menuItems = [];
  List<Venue> venues = [];
  List<FacilityItem> selectedFacilityItems = [];
  List<DeliveryCharges> deliveryCharges = [];
  List<DocumentType> documentTypes = [];
  // DocumentType selectedDocType = DocumentType();
  RetailOrderItemsCategory orderItems;

  int partyHallEnquiryId = 0;
  int showDetail = 0;
  int screenType = 0;
  int bookingMode = 0;
  int totalItems = 0;
  double total = 0;

  File file;
  String newFileName = "";

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<bool> isExpand = [];

  RetailOrderItems selectedRetailOrderItems = new RetailOrderItems();
  int showItem = 1;

  bool isSubmit = false;
  KunoozBookingDto bookingResponse = KunoozBookingDto();

  String totalMenuAmount = "";

  bool isCateringPickup = false;

  int selectedMenuIndex = -1;
  @override
  Widget build(BuildContext context) {
    bookingMode = widget.bookingMode;
    cateringTypeList = widget.cateringTypeList;

    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    return BlocListener<NewFacilityHallBloc, NewFacilityHallState>(
      listener: (context, state) async {
        if (state is NewFacilityHallShowImageState) {
          if (state.file != null) {
            file = state.file;
            newFileName = state.file.path?.split("/")?.last;
            uploadImage(state.file.path);
          } else {
            debugPrint("File not found");
          }
        } else if (state is NewFacilityHallShowImageCameraState) {
          if (state.file != null) {
            file = state.file;
            newFileName = state.file.path?.split("/")?.last;
            uploadImage(state.file.path);
          } else {
            debugPrint("File not found");
          }
        } else if (state is NewFacilityHallImageState) {
          debugPrint(jsonEncode(state.documents).toString());
          // documents = state.documents;
          List<PartyHallDocumentsDto> tempDocuments = state.documents;
          for (int i = 0; i < tempDocuments.length; i++) {
            if (documents.any((e) =>
                e.supportDocumentId == tempDocuments[i].supportDocumentId)) {
            } else {
              documents.add(tempDocuments[i]);
            }
          }
          setState(() {});
        } else if (state is NewFacilityHallSaveState) {
          if (state.error == "Success") {
            if (isSubmit) {
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacilityDetailsPage(
                          facilityId: 6,
                          menuId: 8,
                        )),
              );
              customGetSnackBarWithOutActionButton(
                  tr("kunooz"), tr('submitted_for_review'), context);
            } else {
              KunoozBookingDto resp = KunoozBookingDto.fromJson(
                  jsonDecode(state.message)['response']);
              partyHallEnquiryId = resp.bookingId;
              setState(() {
                currentMenu = "upload_doc";
              });
            }
          } else {
            customGetSnackBarWithOutActionButton(
                tr("kunooz"), state.error, context);
          }
        } else if (state is NewFacilityHallEditState) {
          if (state.error == "Success") {
            BlocProvider.of<NewFacilityHallBloc>(context).add(
                NewFacilityHallReloadEvent(
                    partyHallDetailId: partyHallDetail.partyHallBookingId));
          } else {
            customGetSnackBarWithOutActionButton(
                tr("kunooz"), state.error, context);
          }
        } else if (state is NewFacilityHallCancelState) {
          if (state.error == "Success") {
            customGetSnackBarWithOutActionButton(
                tr("kunooz"), "PartyHall Cancelled successfully", context);
            Navigator.pop(context);
          } else {
            customGetSnackBarWithOutActionButton(
                tr("kunooz"), state.error, context);
          }
        } else if (state is NewFacilityHallTermsState) {
          // if (state.facilityDetail != null) {
          setState(() {
            termsList = state.termsList;
            importantTerms =
                termsList.where((element) => element.isImportant).toList();
            partyHallDetail = state.partyHallDetail;
            // widget.facilityDetail = state.facilityDetail;
            //  widget.facilityItems = state.menuItemList;
            menuItems = state.partyHallDetail.selectedMenuItems;
            colorCode = state.facilityDetail.colorCode;
            eventTypes = state.eventTypeList;
            venues = state.venueList;
            orderItems = state.orderItems;
            hallList = state.orderItems.retailCategoryItems
                    .where((x) => x.categoryId == 8)
                    .first
                    .facilityItems ??
                [];
            menuList = state.orderItems.retailCategoryItems
                    .where((x) => x.categoryId == 2)
                    .toList() ??
                [];
            orderMenuList = [];
            if (bookingMode == 1) {
              for (RetailOrderItems r in menuList) {
                List<FacilityItem> filtered =
                    r.facilityItems.where((x) => x.isBanquet).toList();
                if (filtered.length > 0) {
                  orderMenuList.add(r);
                }
              }
            } else if (bookingMode == 2) {
              for (RetailOrderItems r in menuList) {
                List<FacilityItem> filtered =
                    r.facilityItems.where((x) => x.isCatering).toList();
                if (filtered.length > 0) {
                  orderMenuList.add(r);
                  // if (facilityItems.length == 0) {
                  //   facilityItems.addAll(filtered);
                  // }
                }
              }
            } else {
              for (RetailOrderItems r in menuList) {
                List<FacilityItem> filtered =
                    r.facilityItems.where((x) => x.isPickup).toList();
                if (filtered.length > 0) {
                  orderMenuList.add(r);
                  // if (facilityItems.length == 0) {
                  //   facilityItems.addAll(filtered);
                  // }
                }
              }
            }
            getTotal();
          });
          // setState(() {
          //   load = true;
          // });
        } else if (state is NewFacilityHallReloadState) {
          if (state.partyHallResponse != null) {
            if (state.partyHallResponse.partyHallStatusId ==
                Constants.Work_Flow_UploadDocuments) {
              screenType = Constants.Screen_Upload_Document;
            }
            if (state.partyHallResponse.partyHallStatusId ==
                Constants.Work_Flow_Completed) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PartyHallConfirmationAlert(
                          enquiryId:
                              partyHallDetail.partyHallBookingId.toString(),
                          facilityId: widget.facilityId,
                        )),
              );
            }
            setState(() {
              partyHallDetail = state.partyHallResponse;
            });
          }
        } else if (state is GetFacilityPaymentTermsResult) {
          paymentTerms = state.paymentTerms;
          setState(() {});
        } else if (state is NewFacilityHallKunoozState) {
          bookingResponse = state.bookingResponse;
          if (bookingResponse.emiratesId != null &&
              bookingResponse.emiratesId.isNotEmpty) {
            _fEmiratesIdController.text = bookingResponse.emiratesId;
          }
          documents = bookingResponse.partyHallDocumentsDto ?? [];
        } else if (state is NewFacilityHallDeliveryState) {
          deliveryCharges = state.deliveryCharges;
          setState(() {});
        } else if (state is NewFacilityHallDocumentTypeState) {
          documentTypes = state.documentTypes;
          if (documentTypes.isNotEmpty) {
            _textDocTypeControllers.text = documentTypes.first.otherMemberName;
            _docType = documentTypes.first;
          }
          setState(() {
            load = true;
          });
        }
      },
      child: Scaffold(
        key: _drawerKey,
        backgroundColor: ColorData.backgroundColor,
        endDrawer: getItemCategoryList(),
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          automaticallyImplyLeading: true,
          title: Text(tr("kunooz_booking"),
              style: TextStyle(color: Colors.blue[200])),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.blue[200],
            onPressed: () {
              if (currentMenu == 'event_details') {
                if (partyHallEnquiryId == 0) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              } else if (currentMenu == 'event_menu_details') {
                setState(() {
                  totalMenuAmount = getMenuTotal().toString();
                  currentMenu = 'event_details';
                });
              } else if (currentMenu == 'upload_doc') {
                setState(() {
                  currentMenu = 'event_details';
                });
              }
            },
          ),
          actions: [
            Visibility(
              visible: currentMenu == 'event_menu_details' ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        selectedMenuIndex = -1;
                        print("open drawer" + _drawerKey.toString());
                        _drawerKey?.currentState?.openEndDrawer();
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: ColorData.toColor(widget.colorCode),
                      ))
                ],
              ),
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   // margin: EdgeInsets.only(top: 4),
              //   padding: EdgeInsets.only(top: 4, bottom: 4),
              //   width: sWidth,
              //   color: Colors.white,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text(
              //           currentMenu != "event_menu_details"
              //               ? tr(currentMenu)
              //               : widget.isHall
              //                   ? tr('hall_menu')
              //                   : tr('catering_menu'),
              //           style: TextStyle(
              //               fontSize: Styles.textSizesizteen,
              //               color: ColorData.toColor(widget.colorCode),
              //               fontFamily: "Muli")),
              //     ],
              //   ),
              // ),
              Container(
                height: sHeight * 0.77,
                width: sWidth,
                color: Colors.white,
                padding: EdgeInsets.only(top: 20),
                child: load
                    ? SingleChildScrollView(
                        child: currentMenu == 'event_details'
                            ? eventDetailPage(sWidth, sHeight)
                            : currentMenu == 'event_menu_details'
                                ? menuDetailPage(sWidth, sHeight)
                                : summaryPage(sWidth, sHeight),
                      )
                    : Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: true,
          // visible: currentMenu == 'event_details' ? true : false,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  width: sWidth * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (currentMenu == 'event_details') {
                        if (selectedFacilityItems.isEmpty) {
                          customGetSnackBarWithOutActionButton(
                              tr("kunooz"), tr('select_menus'), context);
                          return;
                        }
                        if (documents.isEmpty) {
                          customGetSnackBarWithOutActionButton(
                              tr("kunooz"), tr('upload_doc'), context);
                          return;
                        }
                        setState(() {
                          isSubmit = true;
                        });
                        KunoozBookingDto request = getPartyHall();
                        BlocProvider.of<NewFacilityHallBloc>(context).add(
                            NewPartyHallSaveEvent(kunoozResponse: request));
                      } else if (currentMenu == 'event_menu_details') {
                        setState(() {
                          totalMenuAmount = getMenuTotal().toString();
                          currentMenu = 'event_details';
                        });
                      } else if (currentMenu == 'upload_doc') {
                        setState(() {
                          currentMenu = 'event_details';
                        });
                      }
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColorData.toColor(widget.colorCode)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        )))),
                    child: Text(
                        currentMenu == 'event_details'
                            ? tr('submit')
                            : tr('next'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: "Muli")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  eventDetailPage(double sWidth, double sHeight) {
    String facilityName = "";
    if (widget.isHall) {
      final selectFacility =
          hallList.where((e) => e.facilityItemId == widget.facilityItemId);
      facilityName =
          selectFacility != null ? selectFacility.single.facilityItemName : "";
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isHall
                  ? Text(
                      facilityName,
                      style: TextStyle(
                        color: ColorData.toColor(widget.colorCode),
                        fontSize: Styles.textSizesizteen,
                        fontFamily: "currFontFamily",
                      ),
                    )
                  : Text(
                      widget.isPickup ? tr('pick_up') : tr('delivery'),
                      style: TextStyle(
                        color: ColorData.toColor(widget.colorCode),
                        fontSize: Styles.textSizesizteen,
                        fontFamily: "currFontFamily",
                      ),
                    ),
              Text(bookingResponse.creditCustomer ?? "",
                  style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontSize: Styles.textSizesizteen,
                      fontFamily: "currFontFamily")),
            ],
          ),
        ),
        Visibility(
          visible: !widget.isHall && widget.isPickup,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isCateringPickup = false;
                  });
                  for (RetailOrderItems r in menuList) {
                    List<FacilityItem> filtered =
                        r.facilityItems.where((x) => x.isCatering).toList();
                    if (filtered.length > 0) {
                      orderMenuList.add(r);
                      // if (facilityItems.length == 0) {
                      //   facilityItems.addAll(filtered);
                      // }
                    }
                  }
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(sWidth * 0.3, sHeight * 0.04)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        !isCateringPickup
                            ? ColorData.toColor(widget.colorCode)
                            : Colors.grey[200]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )))),
                child: Text(tr('delivery_address'),
                    style: TextStyle(
                        color: !isCateringPickup
                            ? Colors.white
                            : ColorData.primaryTextColor,
                        fontSize: Styles.loginBtnFontSize,
                        fontFamily: "Muli")),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isCateringPickup = true;
                  });
                  orderMenuList = [];
                  for (RetailOrderItems r in menuList) {
                    List<FacilityItem> filtered =
                        r.facilityItems.where((x) => x.isPickup).toList();
                    if (filtered.length > 0) {
                      orderMenuList.add(r);
                      // if (facilityItems.length == 0) {
                      //   facilityItems.addAll(filtered);
                      // }
                    }
                  }
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(sWidth * 0.32, sHeight * 0.04)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        isCateringPickup
                            ? ColorData.toColor(widget.colorCode)
                            : Colors.grey[200]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )))),
                child: Text(tr('pickup'),
                    style: TextStyle(
                        color: isCateringPickup
                            ? Colors.white
                            : ColorData.primaryTextColor,
                        fontSize: Styles.loginBtnFontSize,
                        fontFamily: "Muli")),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
          child: CustomEventTypeWithIconComponent(
            selectedFunction: _onChangeEventDropdown,
            eventTypeController: _textEventTypeControllers,
            isEditBtnEnabled: Strings.ProfileCallState,
            eventTypeResponse: eventTypes,
            label: tr('select_event_type'),
            imagePath: 'assets/images/event_type.png',
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
          child: CustomEventDateWithIconComponent(
            isEditBtnEnabled: Strings.ProfileCallState,
            selectedFunction: (val) => {
              _customEventController.text = val,
            },
            dobController: _customEventController,
            isAddPeople: false,
            isFutureDate: true,
            captionText: tr("event_date"),
            imagePath: 'assets/images/event_date.png',
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
          child: CustomTimeWithIconComponent(
            isEditBtnEnabled: Strings.ProfileCallState,
            selectedFunction: (val) => {
              _customStartTimeController.text = val,
            },
            timerController: _customStartTimeController,
            timeselResponse: [
              '12:00 AM',
              '01:00 AM',
              '02:00 AM',
              '03:00 AM',
              '04:00 AM',
              '05:00 AM',
              '06:00 AM',
              '07:00 AM',
              '08:00 AM',
              '09:00 AM',
              '10:00 AM',
              '11:00 AM',
              '12:00 PM',
              '01:00 PM',
              '02:00 PM',
              '03:00 PM',
              '04:00 PM',
              '05:00 PM',
              '06:00 PM',
              '07:00 PM',
              '08:00 PM',
              '09:00 PM',
              '10:00 PM',
              '11:00 PM'
            ],
            label: tr("event_start_time"),
            imagePath: 'assets/images/event_time.png',
          ),
        ),
        // Container(
        //   padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
        //   child: CustomTimeComponent(
        //     isEditBtnEnabled: Strings.ProfileCallState,
        //     selectedFunction: (val) => {
        //       _customEndTimeController.text = val,
        //     },
        //     timerController: _customEndTimeController,
        //     timeselResponse: eventAlteredEndTime,
        //     label: tr("event_end_time"),
        //   ),
        // ),
        // Container(
        //   padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
        //   child: CustomDOBComponent(
        //       isEditBtnEnabled: Strings.ProfileCallState,
        //       selectedFunction: (val) => {
        //             _customStartController.text = val,
        //           },
        //       dobController: _customStartController,
        //       isAddPeople: false,
        //       isFutureDate: true,
        //       captionText: tr("setup_date")),
        // ),
        Container(
          padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
          child: LoginPageFieldWithIconWhite(
            _customGuestsController,
            tr("guest_count"),
            Strings.countryCodeForNonMobileField,
            CommonIcons.account,
            TextInputTypeFile.textInputTypeMobile,
            TextInputAction.done,
            () => {},
            () => {},
            maxLines: 1,
            imagePath: "assets/images/guest_count.png",
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
          child: LoginPageFieldWhite(
            _fEmiratesIdController,
            tr("emirates_id"),
            Strings.countryCodeForNonMobileField,
            CommonIcons.woman,
            TextInputTypeFile.textInputTypeName,
            TextInputAction.done,
            () => {},
            () => {},
            readOnly: false,
            // readOnly: (bookingResponse.emiratesId == null ||
            //         bookingResponse.emiratesId == '')
            //     ? false
            //     : true,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
          child: LoginPageFieldWithIconWhite(
            _commentController,
            tr("notes"),
            Strings.countryCodeForNonMobileField,
            CommonIcons.review,
            TextInputTypeFile.textInputTypeName,
            TextInputAction.done,
            () => {},
            () => {},
            maxLines: 2,
            imagePath: "assets/images/notes.png",
          ),
        ),
        Visibility(
            visible: !isCateringPickup && !widget.isHall,
            child: Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                _streetName,
                tr('street_name'),
                Strings.countryCodeForNonMobileField,
                CommonIcons.account,
                TextInputTypeFile.textInputTypeName,
                TextInputAction.done,
                () => {},
                () => {},
              ),
            )),
        Visibility(
            visible: !isCateringPickup && !widget.isHall,
            child: Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                _landmark,
                tr('landmark'),
                Strings.countryCodeForNonMobileField,
                CommonIcons.location,
                TextInputTypeFile.textInputTypeName,
                TextInputAction.done,
                () => {},
                () => {},
              ),
            )),
        Visibility(
            visible: !isCateringPickup && !widget.isHall,
            child: Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: CustomDeliveryChargesComponent(
                  selectedFunction: _onChangeChargesOptionDropdown,
                  deliveryController: _city,
                  isEditBtnEnabled: Strings.ProfileCallState,
                  deliveryResponse:
                      deliveryCharges == null ? [] : deliveryCharges,
                  label: tr('city')),
            )),
        Visibility(
            visible: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                _contactNo,
                tr('phone'),
                Strings.countryCodeForNonMobileField,
                CommonIcons.phone,
                TextInputTypeFile.textInputTypeName,
                TextInputAction.done,
                () => {},
                () => {},
              ),
            )),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: ElevatedButton(
            onPressed: () {
              if (_textEventTypeControllers.text.isEmpty) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('event_type'), context);
                return;
              }
              if (_customEventController.text.isEmpty) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('select_event_date'), context);
                return;
              }
              if (_customStartTimeController.text.isEmpty) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('select_event_start_time'), context);
                return;
              }
              if (_customGuestsController.text.isEmpty) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('enter_guest_count'), context);
                return;
              }
              if (_fEmiratesIdController.text.isEmpty) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('enter_emiratesid'), context);
                return;
              }
              if (_fEmiratesIdController.text.length < 15) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('incorrect_id'), context);
                return;
              }
              if (int.parse(_customGuestsController.text) < 1) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('guest_count_alert'), context);
                return;
              }
              if (_fEmiratesIdController.text.isEmpty) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('enter_emirates_id'), context);
                return;
              }
              if (widget.isPickup && !isCateringPickup && _city.text.isEmpty) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('select_city'), context);
                return;
              }
              menuCtrl.text = _customGuestsController.text;
              selectedMenuIndex = -1;
              setState(() {
                currentMenu = "event_menu_details";
                _drawerKey?.currentState?.openEndDrawer();
              });
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: Size(sWidth, sHeight * 0.06),
                backgroundColor: ColorData.loginBackgroundColor),
            child: Padding(
              padding: EdgeInsets.only(left: 6, right: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/select_menu.png", width: 30),
                  Padding(
                    padding:
                        Localizations.localeOf(context).languageCode == "en"
                            ? EdgeInsets.only(left: 16)
                            : EdgeInsets.only(right: 16),
                    child: Text(
                        selectedFacilityItems.isEmpty
                            ? tr('click_to_menu')
                            : tr('menu_selected') +
                                "\t\t\t-\t" +
                                totalMenuAmount +
                                "\t AED",
                        style: TextStyle(
                            color: selectedFacilityItems.isEmpty
                                ? ColorData.primaryTextColor
                                : ColorData.toColor(widget.colorCode),
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: "Muli")),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: ElevatedButton(
            onPressed: () {
              if (selectedFacilityItems.isEmpty) {
                customGetSnackBarWithOutActionButton(
                    tr("kunooz"), tr('select_menus'), context);
                return;
              }
              KunoozBookingDto request = getPartyHall();
              BlocProvider.of<NewFacilityHallBloc>(context)
                  .add(NewPartyHallSaveEvent(kunoozResponse: request));
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: Size(sWidth, sHeight * 0.06),
                backgroundColor: ColorData.loginBackgroundColor),
            child: Padding(
              padding: EdgeInsets.only(left: 6, right: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/upload_doc.png", width: 30),
                  Padding(
                    padding:
                        Localizations.localeOf(context).languageCode == "en"
                            ? EdgeInsets.only(left: 16)
                            : EdgeInsets.only(right: 16),
                    child: Text(
                      documents.isEmpty
                          ? tr('click_to_upload')
                          : tr('doc_uploaded') +
                              "\t\t\t-\t" +
                              documents.length.toString(),
                      style: TextStyle(
                          color: documents.isEmpty
                              ? ColorData.primaryTextColor
                              : ColorData.toColor(widget.colorCode),
                          fontSize: Styles.loginBtnFontSize,
                          fontFamily: "Muli"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextEditingController menuCtrl = TextEditingController();

  menuDetailPage(double sWidth, double sHeight) {
    return Container(
      height: sHeight * 0.72,
      margin: EdgeInsets.only(top: 0),
      child: facilityItems.isNotEmpty
          ? ListView.separated(
              itemCount: facilityItems.length,
              padding: EdgeInsets.only(left: 4),
              itemBuilder: (BuildContext context, index) {
                isExpand.add(false);
                // if (itemCounts[facilityItems[index].facilityItemId] == null) {
                //   itemCounts[facilityItems[index].facilityItemId] =
                //       new FacilityBeachRequest();
                // }
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: sWidth * 0.26,
                              height: sHeight * 0.1,
                              // height: MediaQuery.of(context).size.height * .17,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200]),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8)),
                                child: Image.network(
                                    serverTestPath +
                                        "UploadDocument/FacilityItem/" +
                                        facilityItems[index].imageUrl,
                                    fit: BoxFit.cover),
                              )),
                          Container(
                            width: (sWidth - (sWidth * 0.26)) * 0.9,
                            margin: EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(facilityItems[index].facilityItemName,
                                    style: TextStyle(
                                        fontSize: Styles.textSizesizteen,
                                        color:
                                            ColorData.toColor(widget.colorCode),
                                        fontFamily: "Muli")),
                                Visibility(
                                  visible: facilityItems[index].isDiscountable
                                      ? true
                                      : false,
                                  child: Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(tr("discountable"),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Styles.reviewTextSize,
                                              //fontStyle: FontStyle.italic,
                                              backgroundColor:
                                                  ColorData.toColor(
                                                      widget.colorCode),
                                              fontFamily: "Muli"))),
                                ),
                                ConstrainedBox(
                                  constraints: isExpand[index]
                                      ? new BoxConstraints()
                                      : new BoxConstraints(
                                          maxHeight: sHeight * 0.14),
                                  child: InkWell(
                                    onTap: () {
                                      if (isExpand[index] == false) {
                                        for (int i = 0;
                                            i < isExpand.length;
                                            i++) {
                                          isExpand[i] = false;
                                        }
                                      }
                                      isExpand[index]
                                          ? isExpand[index] = false
                                          : isExpand[index] = true;
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              (sWidth - (sWidth * 0.26)) * 0.74,
                                          child: Html(
                                            style: {
                                              "body": Style(
                                                padding: EdgeInsets.all(0),
                                                margin: Margins.all(0),
                                                color:
                                                    ColorData.primaryTextColor,
                                              ),
                                              "p": Style(
                                                fontWeight: FontWeight.normal,
                                                padding: EdgeInsets.all(0),
                                                margin: Margins.all(0),
                                              ),
                                              "span": Style(
                                                fontWeight: FontWeight.normal,
                                                padding: EdgeInsets.all(0),
                                                margin: Margins.all(0),
                                              ),
                                              "h6": Style(
                                                fontWeight: FontWeight.normal,
                                                fontSize: FontSize(
                                                    Styles.textSizeSmall),
                                                fontFamily: tr(
                                                    'currFontFamilyEnglishOnly'),
                                                padding: EdgeInsets.all(0),
                                                margin: Margins.all(0),
                                              ),
                                            },
                                            data: facilityItems[index]
                                                        .description !=
                                                    null
                                                ? "<html><body>" +
                                                    facilityItems[index]
                                                        .description +
                                                    "</body></html>"
                                                : tr('noDataFound'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          if (isExpand[index] == false) {
                                            for (int i = 0;
                                                i < isExpand.length;
                                                i++) {
                                              isExpand[i] = false;
                                            }
                                          }
                                          isExpand[index]
                                              ? isExpand[index] = false
                                              : isExpand[index] = true;
                                          setState(() {});
                                        },
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero),
                                        child: Text(
                                            isExpand[index] == true
                                                ? tr('show_less')
                                                : tr('show_more'),
                                            style: TextStyle(
                                                fontSize: Styles.textSiz,
                                                color: ColorData.toColor(
                                                    widget.colorCode),
                                                fontFamily: "Muli")))
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'AED ' +
                                            facilityItems[index]
                                                .price
                                                .toStringAsFixed(2) +
                                            '  ',
                                        style: TextStyle(
                                            fontSize: Styles.textSizesizteen,
                                            color: ColorData.toColor(
                                                widget.colorCode),
                                            fontFamily: "Muli"),
                                      ),
                                      (selectedMenuIndex == index ||
                                              (itemCounts[facilityItems[index]
                                                          .facilityItemId] !=
                                                      null &&
                                                  itemCounts[facilityItems[
                                                                  index]
                                                              .facilityItemId]
                                                          .quantity !=
                                                      null &&
                                                  itemCounts[facilityItems[
                                                                  index]
                                                              .facilityItemId]
                                                          .quantity >
                                                      0))
                                          ? Container(
                                              height: sHeight * 0.032,
                                              width: sWidth * 0.22,
                                              padding: EdgeInsets.only(
                                                  left: 4, right: 4),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorData.backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () => setState(() {
                                                      if (itemCounts[facilityItems[
                                                                  index]
                                                              .facilityItemId] ==
                                                          null) {
                                                        itemCounts[facilityItems[
                                                                    index]
                                                                .facilityItemId] =
                                                            new FacilityBeachRequest();
                                                      }
                                                      if (itemCounts[facilityItems[
                                                                      index]
                                                                  .facilityItemId]
                                                              .quantity >
                                                          0) {
                                                        itemCounts[facilityItems[
                                                                    index]
                                                                .facilityItemId]
                                                            .quantity = itemCounts[
                                                                    facilityItems[
                                                                            index]
                                                                        .facilityItemId]
                                                                .quantity -
                                                            1;
                                                        menuCtrl
                                                            .text = itemCounts[
                                                                facilityItems[
                                                                        index]
                                                                    .facilityItemId]
                                                            .quantity
                                                            .toString();
                                                      }
                                                      setState(() {});
                                                      getTotal();
                                                    }),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 10,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: sWidth * 0.07,
                                                    // color: Colors.red,
                                                    child: TextField(
                                                      controller: menuCtrl,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                      ],
                                                      onSubmitted: (val) {
                                                        if (val.isNotEmpty) {
                                                          itemCounts[facilityItems[
                                                                          index]
                                                                      .facilityItemId]
                                                                  .quantity =
                                                              int.parse(val);
                                                        }
                                                        getTotal();
                                                      },
                                                      decoration:
                                                          new InputDecoration
                                                              .collapsed(),
                                                    ),
                                                  ),
                                                  // Text(
                                                  //     itemCounts[
                                                  //                 facilityItems[
                                                  //                         index]
                                                  //                     .facilityItemId] ==
                                                  //             null
                                                  //         ? "0"
                                                  //         : itemCounts[
                                                  //                 facilityItems[
                                                  //                         index]
                                                  //                     .facilityItemId]
                                                  //             .quantity
                                                  //             .toString(),
                                                  //     style: TextStyle(
                                                  //         fontSize: Styles
                                                  //             .textSizesizteen,
                                                  //         color: ColorData
                                                  //             .toColor(widget
                                                  //                 .colorCode),
                                                  //         fontFamily: "Muli")),
                                                  InkWell(
                                                    onTap: () => setState(() {
                                                      if (itemCounts[facilityItems[
                                                                  index]
                                                              .facilityItemId] ==
                                                          null) {
                                                        itemCounts[facilityItems[
                                                                    index]
                                                                .facilityItemId] =
                                                            new FacilityBeachRequest();
                                                        itemCounts[facilityItems[
                                                                    index]
                                                                .facilityItemId]
                                                            .quantity = 0;
                                                      }

                                                      itemCounts[facilityItems[
                                                                  index]
                                                              .facilityItemId]
                                                          .quantity = itemCounts[
                                                                  facilityItems[
                                                                          index]
                                                                      .facilityItemId]
                                                              .quantity +
                                                          1;
                                                      menuCtrl
                                                          .text = itemCounts[
                                                              facilityItems[
                                                                      index]
                                                                  .facilityItemId]
                                                          .quantity
                                                          .toString();
                                                      setState(() {});
                                                      getTotal();
                                                    }),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 10,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : TextButton(
                                              onPressed: () {
                                                if (selectedMenuIndex != -1) {
                                                  if (itemCounts.containsKey(
                                                      facilityItems[
                                                              selectedMenuIndex]
                                                          .facilityItemId)) {
                                                    itemCounts.remove(
                                                        facilityItems[
                                                                selectedMenuIndex]
                                                            .facilityItemId);
                                                  }
                                                  // itemCounts[facilityItems[
                                                  //             selectedMenuIndex]
                                                  //         .facilityItemId]
                                                  //     .quantity = 0;
                                                  getTotal();
                                                }
                                                selectedMenuIndex = index;
                                                menuCtrl.text =
                                                    _customGuestsController
                                                        .text;
                                                if (!itemCounts.containsKey(
                                                    facilityItems[index]
                                                        .facilityItemId)) {
                                                  itemCounts[
                                                          facilityItems[index]
                                                              .facilityItemId] =
                                                      new FacilityBeachRequest();
                                                }
                                                itemCounts[facilityItems[index]
                                                            .facilityItemId]
                                                        .quantity =
                                                    int.parse(menuCtrl.text);
                                                getTotal();
                                                setState(() {});
                                              },
                                              child: Text("Select Item")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, index) {
                return Divider();
              },
            )
          : Center(
              child: Text(
                "No items found",
                style: TextStyle(
                    color: ColorData.primaryTextColor,
                    fontSize: Styles.textSiz,
                    fontFamily: tr("currFontFamilyEnglishOnly")),
              ),
            ),
    );
  }

  summaryPage(double sWidth, double sHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: sHeight * 0.7,
          width: sWidth,
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: sWidth * 0.6,
                      child: CustomUploadTypeComponent(
                        selectedFunction: _onChangeUploadDropdown,
                        docTypeController: _textDocTypeControllers,
                        isEditBtnEnabled: Strings.ProfileCallState,
                        docTypeResponse: documentTypes,
                        label: tr('select_doc_type'),
                        imagePath: "assets/images/upload_doc.png",
                      ),
                    ),
                  ],
                ),
              ),
              getUpload(context, sWidth, sHeight),
              Container(
                height: sHeight * 0.24,
                width: sWidth,
                margin: EdgeInsets.only(top: 16),
                child: getHallDocuments(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _onChangeEventDropdown(EventType eventType) {
    setState(() {
      _eventType = eventType;
    });
  }

  _onChangeUploadDropdown(DocumentType docType) {
    setState(() {
      _docType = docType;
    });
  }

  _onChangeChargesOptionDropdown(DeliveryCharges charges) {
    setState(() {
      selectedDeliveryCharges = charges;
    });
  }

  Future<String> uploadImage(filename) async {
    debugPrint("1I am here Upload $partyHallEnquiryId");
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(serverReceiverPath +
            "?id=1&eventid=" +
            partyHallEnquiryId.toString() +
            "&eventparticipantid=" +
            SPUtil.getInt(Constants.USERID).toString() +
            "&FileName=" +
            newFileName +
            "&uploadtype=3&docNo=${_fEmiratesIdController.text}&documentType=${_docType.otherMemberShipId}"));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    customGetSnackBarWithOutActionButton(
        tr('document_upload'), tr('file_uploaded_successfully'), context);
    BlocProvider.of<NewFacilityHallBloc>(context)
        .add(NewPartyHallImageEvent(id: partyHallEnquiryId));
    return res.reasonPhrase;
  }

  customGetSnackBarWithOutActionButton(titleMsg, contentMsg, context) {
    return Get.snackbar(
      titleMsg,
      contentMsg,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorData.activeIconColor,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }

  double getTotal() {
    double totalAmt = 0;
    totalItems = 0;
    // if (partyHallDetail != null &&
    //     partyHallDetail.partyHallBookingId != null &&
    //     partyHallDetail.partyHallBookingId != 0) {
    //   total = partyHallDetail.total;
    // } else {
    //   if (partyHallDetail != null &&
    //       partyHallDetail.selectedMenuItems != null &&
    //       partyHallDetail.selectedMenuItems.length > 0) {
    //     for (int i = 0; i < partyHallDetail.selectedMenuItems.length; i++) {
    //       totalAmt = totalAmt +
    //           (partyHallDetail.selectedMenuItems[i].price *
    //               partyHallDetail.selectedMenuItems[i].quantity);
    //     }
    //     totalItems = partyHallDetail.selectedMenuItems.length + 1;
    //   } else {
    List<int> selectedItem = [];
    if (currentMenu == 'event_menu_details') {
      selectedFacilityItems = [];
      for (RetailOrderItems r in menuList) {
        for (int i = 0; i < r.facilityItems.length; i++) {
          if (selectedItem.indexOf(r.facilityItems[i].facilityItemId) == -1) {
            int itemCount =
                itemCounts[r.facilityItems[i].facilityItemId] == null
                    ? 0
                    : itemCounts[r.facilityItems[i].facilityItemId].quantity;
            if (itemCount > 0) {
              selectedItem.add(r.facilityItems[i].facilityItemId);
              selectedFacilityItems.add(r.facilityItems[i]);
              totalItems++;
            }
            totalAmt = totalAmt + (r.facilityItems[i].price * itemCount);
          }
        }
      }
    }
    // else if (currentMenu == 'upload_doc') {
    //   for (int i = 0; i < selectedFacilityItems.length; i++) {
    //     if (selectedItem.indexOf(selectedFacilityItems[i].facilityItemId) ==
    //         -1) {
    //       int itemCount =
    //           itemCounts[selectedFacilityItems[i].facilityItemId] == null
    //               ? 0
    //               : itemCounts[selectedFacilityItems[i].facilityItemId]
    //                   .quantity;
    //       if (itemCount > 0) {
    //         totalItems++;
    //       }
    //       totalAmt =
    //           totalAmt + (selectedFacilityItems[i].price * itemCount);
    //     }
    //   }
    // }
    if (widget.isHall) {
      FacilityItem selectedHall = hallList
          .where((e) => e.facilityItemId == widget.facilityItemId)
          .first;
      totalItems++;
      totalAmt = totalAmt + selectedHall.price;
    }

    // }
    total = totalAmt;
    // total = total + widget.facilityItem.price;
    // }
    return total;
  }

  double getMenuTotal() {
    double totalAmt = 0;
    totalItems = 0;
    List<int> selectedItem = [];
    if (currentMenu == 'event_menu_details') {
      selectedFacilityItems = [];
      for (RetailOrderItems r in menuList) {
        for (int i = 0; i < r.facilityItems.length; i++) {
          if (selectedItem.indexOf(r.facilityItems[i].facilityItemId) == -1) {
            int itemCount =
                itemCounts[r.facilityItems[i].facilityItemId] == null
                    ? 0
                    : itemCounts[r.facilityItems[i].facilityItemId].quantity;
            if (itemCount > 0) {
              selectedItem.add(r.facilityItems[i].facilityItemId);
              selectedFacilityItems.add(r.facilityItems[i]);
              totalItems++;
            }
            totalAmt = totalAmt + (r.facilityItems[i].price * itemCount);
          }
        }
      }
    }
    return totalAmt;
  }

  Widget getItemCategoryList() {
    return Drawer(
      child: Container(
        color: ColorData.backgroundColor,
        child: orderMenuList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: orderMenuList == null ? 0 : orderMenuList.length,
                itemBuilder: (context, j) {
                  return Visibility(
                      visible: orderMenuList[j].facilityItems != null &&
                              orderMenuList[j].facilityItems.length > 0
                          ? true
                          : false,
                      child: Container(
                        margin: EdgeInsets.only(top: 5, left: 4, right: 3),
                        child: Stack(
                          children: [
                            SizedBox(height: 5),
                            InkWell(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .10,
                                width: MediaQuery.of(context).size.width * .75,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  border: Border.all(
                                      color:
                                          ColorData.toColor(widget.colorCode)),
                                  color: orderMenuList[j].menuName ==
                                          selectedRetailOrderItems.menuName
                                      ? Colors
                                          .transparent //Color.fromRGBO(239, 243, 248, 1)
                                      : Colors.white,
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                top: 15.0,
                                                left: 10,
                                                bottom: 10.0)
                                            : EdgeInsets.only(
                                                top: 15.0,
                                                right: 10,
                                                bottom: 10.0),
                                        child: Text(orderMenuList[j].menuName,
                                            style: new TextStyle(
                                                // fontWeight: FontWeight.w600,
                                                color: orderMenuList[j]
                                                            .menuName ==
                                                        selectedRetailOrderItems
                                                            .menuName
                                                    ? ColorData.toColor(
                                                        widget.colorCode)
                                                    : ColorData
                                                        .primaryTextColor,
                                                fontFamily: tr(
                                                    'currFontFamilyEnglishOnly'),
                                                fontSize: 14))),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showItem = 1;
                                  selectedRetailOrderItems = orderMenuList[j];
                                  if (bookingMode == 1) {
                                    facilityItems = selectedRetailOrderItems
                                        .facilityItems
                                        .where((x) => x.isBanquet)
                                        .toList();
                                  } else {
                                    if (!isCateringPickup) {
                                      facilityItems = selectedRetailOrderItems
                                          .facilityItems
                                          .where((x) => x.isCatering)
                                          .toList();
                                    } else {
                                      facilityItems = selectedRetailOrderItems
                                          .facilityItems
                                          .where((x) => x.isPickup)
                                          .toList();
                                    }
                                  }
                                  for (var v in facilityItems) {
                                    if (itemCounts
                                            .containsKey(v.facilityItemId) &&
                                        itemCounts[v.facilityItemId].quantity >
                                            0) {
                                      menuCtrl.text =
                                          itemCounts[v.facilityItemId]
                                              .quantity
                                              .toString();
                                    }
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ));
                })
            : Center(
                child: Text(
                  "No items found",
                  style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontSize: Styles.textSiz,
                      fontFamily: tr("currFontFamilyEnglishOnly")),
                ),
              ),
      ),
    );
  }

  Widget getUpload(BuildContext context, double sWidth, double sHeight) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (documents.length < 2) {
              displayModalBottomSheet(context);
            } else {
              customGetSnackBarWithOutActionButton(
                  tr("kunooz"), tr('cannot_upload_files'), context);
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            height: sHeight * 0.1,
            width: sWidth * 0.4,
            color: Colors.transparent,
            child: Image.asset("assets/images/upload_image.png"),
          ),
        ),
        Container(
          height: sHeight * 0.12,
          width: sWidth * 0.56,
          // padding: EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
              // color: Colors.red,
              border: Border.all(color: ColorData.toColor(widget.colorCode)),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "• ",
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontFamily: tr("currFontFamilyEnglishOnly")),
                  ),
                  Text(
                    tr('emirates_id'),
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontFamily: tr("currFontFamilyEnglishOnly")),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "• ",
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontFamily: tr("currFontFamilyEnglishOnly")),
                  ),
                  Text(
                    tr('upload_discount_card'),
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontFamily: tr("currFontFamilyEnglishOnly")),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "• ",
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontFamily: tr("currFontFamilyEnglishOnly")),
                  ),
                  Text(
                    tr('2_documents_to_upload'),
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontFamily: tr("currFontFamilyEnglishOnly")),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        trailing: new Icon(Icons.photo_library,
                            color: ColorData.colorBlue),
                        title: new Text(tr('photo_library'),
                            style: TextStyle(
                                fontSize: Styles.textSizesizteen,
                                color: ColorData.primaryTextColor,
                                fontFamily: "Muli")),
                        onTap: () {
                          BlocProvider.of<NewFacilityHallBloc>(context)
                              .add(NewFacilityHallShowImageEvent());
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      trailing: new Icon(Icons.photo_camera,
                          color: ColorData.colorBlue),
                      title: new Text(tr('take_photo'),
                          style: TextStyle(
                              fontSize: Styles.textSizesizteen,
                              color: ColorData.primaryTextColor,
                              fontFamily: "Muli")),
                      onTap: () {
                        BlocProvider.of<NewFacilityHallBloc>(context)
                            .add(NewFacilityHallShowImageCameraEvent());
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  Widget getHallDocuments() {
    return ListView.separated(
      key: PageStorageKey("Documents1_PageStorageKey"),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: documents.length,
      itemBuilder: (context, j) {
        String docName = documents[j].documentFileName.split("/").last;
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            docName ?? "",
            style: TextStyle(
              fontSize: Styles.packageExpandTextSiz,
              fontFamily: tr('currFontFamily'),
              color: ColorData.primaryTextColor,
            ),
          ),
          trailing: Visibility(
            visible: true,
            // visible: documents[j].documentTypeId != 1 ? true : false,
            child: IconButton(
              icon: Icon(Icons.delete_forever),
              padding: EdgeInsets.zero,
              iconSize: 24,
              color: Colors.blue[200],
              onPressed: () async {
                Meta m = await (new FacilityDetailRepository())
                    .deleteFacilityUploadedDocument(widget.facilityId,
                        documents[j].supportDocumentId.toString());
                if (m.statusCode == 200) {
                  documents.removeAt(j);
                  customGetSnackBarWithOutActionButton(tr('document_upload'),
                      tr('file_deleted_successfully'), context);
                  setState(() {});
                  // BlocProvider.of<NewFacilityHallBloc>(context).add(
                  //     NewFacilityHallReloadEvent(
                  //         facilityId: widget.facilityId,
                  //         facilityItemId: 0,
                  //         partyHallDetailId: partyHallEnquiryId));
                } else {
                  customGetSnackBarWithOutActionButton(
                      tr("kunooz"), tr('delete_unsuccessful'), context);
                }
              },
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, index) {
        return Divider(color: Colors.grey[400]);
      },
    );
  }

  KunoozBookingDto getPartyHall() {
    double grossAmount = 0.0;
    double taxAmount = 0.0;
    double serviceAmount = 0.0;
    double netAmount = 0.0;
    KunoozBookingDto request = new KunoozBookingDto();
    request.facilityId = widget.facilityId;
    request.bookingId = partyHallEnquiryId;
    request.bookingTypeId = widget.isHall ? 1 : widget.bookingMode;
    request.customerName = "";
    request.mobileNo = "";
    request.userID = SPUtil.getInt(Constants.USERID);
    request.enquiryStatusId = 1;
    request.bookingEventId = _eventType.eventTypeId;
    request.cityId = selectedDeliveryCharges.facilityItemCode ?? 0;
    request.city = _city.text;
    // if (widget.isPickup && !isCateringPickup) {
    //   request.transportation = selectedDeliveryCharges.cityName ?? "";
    //   request.transportationId = selectedDeliveryCharges.facilityItemCode ?? 0;
    // } else {
    //   request.cityId = selectedDeliveryCharges.facilityItemCode ?? 0;
    //   request.city = _city.text;
    // }
    request.streetAddress = _streetName.text;
    request.landmark = _landmark.text;
    request.bookingDate = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(_customEventController.text.toString(),
            DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);
    request.bookingDateStr = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(_customEventController.text.toString(),
            DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);
    request.bookingFromtr = _customStartTimeController.text.toString();
    request.bookingFrom = request.bookingDateStr +
        " " +
        _customStartTimeController.text.toString();
    request.bookingToStr = _customStartTimeController.text.toString();
    request.bookingTo = request.bookingDateStr +
        " " +
        _customStartTimeController.text.toString();
    // request.bookingToStr = _customEndTimeController.text.toString();
    // request.bookingTo =
    //     request.bookingDateStr + " " + _customEndTimeController.text.toString();
    request.setupDate = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(_customEventController.text.toString(),
            DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);
    request.setupDateStr = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(_customEventController.text.toString(),
            DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);
    // request.setupDate = DateTimeUtils().dateToStringFormat(
    //     DateTimeUtils().stringToDate(_customStartController.text.toString(),
    //         DateTimeUtils.DD_MM_YYYY_Format),
    //     DateTimeUtils.dobFormat);
    // request.setupDateStr = DateTimeUtils().dateToStringFormat(
    //     DateTimeUtils().stringToDate(_customStartController.text.toString(),
    //         DateTimeUtils.DD_MM_YYYY_Format),
    //     DateTimeUtils.dobFormat);
    request.gurrantedGuest = int.parse(_customGuestsController.text.toString());
    request.comments = _commentController.text.toString();
    request.isActive = true;
    request.emiratesId = _fEmiratesIdController.text.toString();
    request.advanceAmount = 0;
    request.amendmentId = 0;
    request.amendmentStatusId = 0;
    request.discountAmount = 0;
    request.discountPercent = 0;
    request.payableAmount = total;
    request.servicePercent = 0;
    request.onlineAadvanceRequestAmount = 0;
    request.deliveryInstruction = '';
    request.contactNo = '';
    request.deliveryCharges = 0;
    request.deliveryVat = 0;
    request.isNew = 1;

    // List<int> selectedItems = [];
    List<KunoozBookingItemDto> items = [];
    // new List<FacilityBeachRequest>();
    if (widget.isHall) {
      FacilityItem selectedHall = hallList
          .where((e) => e.facilityItemId == widget.facilityItemId)
          .first;
      KunoozBookingItemDto item = new KunoozBookingItemDto();
      item.itemId = 0;
      item.kunoozBookingId = 0;
      item.facilityItemId = selectedHall.facilityItemId;
      item.qty = 1;
      item.servicePercent = selectedHall.inServicePercentage;
      item.price = selectedHall.rate;
      item.tax = (selectedHall.price - selectedHall.rate) * item.qty;
      item.amount = selectedHall.rate * item.qty;
      if (item.servicePercent > 0) {
        double grossPrice = selectedHall.price * item.qty;
        item.serviceAmount = (grossPrice * (item.servicePercent / 100));
      } else {
        item.serviceAmount = 0;
      }
      item.discount = 0;
      item.discountPercent = 0;
      item.netAmount = item.amount + item.serviceAmount + item.tax;
      item.isHall = true;
      item.isAmended = false;
      item.isActive = true;

      grossAmount = grossAmount + item.amount;
      taxAmount = taxAmount + item.tax;
      serviceAmount = serviceAmount + item.serviceAmount;
      netAmount = netAmount + item.netAmount;
      // item.bookingTypeId = 1;
      items.add(item);
    }
    for (RetailOrderItems r in menuList) {
      for (int i = 0; i < r.facilityItems.length; i++) {
        int itemCount = itemCounts[r.facilityItems[i].facilityItemId] == null
            ? 0
            : itemCounts[r.facilityItems[i].facilityItemId].quantity;
        if (itemCount > 0) {
          KunoozBookingItemDto item = new KunoozBookingItemDto();
          item.itemId = 0;
          item.kunoozBookingId = 0;
          item.facilityItemId = r.facilityItems[i].facilityItemId;
          item.qty = itemCount;

          item.servicePercent = request.bookingTypeId == 1
              ? r.facilityItems[i].inServicePercentage
              : request.bookingTypeId == 2
                  ? r.facilityItems[i].servicePercentage
                  : 0;
          item.price = r.facilityItems[i].rate;
          item.tax =
              (r.facilityItems[i].price - r.facilityItems[i].rate) * item.qty;
          item.amount = r.facilityItems[i].rate * item.qty;
          request.servicePercent = item.servicePercent;
          if (request.servicePercent > 0) {
            double grossPrice = r.facilityItems[i].price * item.qty;
            item.serviceAmount = (grossPrice * (request.servicePercent / 100));
          } else {
            item.serviceAmount = 0;
          }
          item.discount = 0;
          item.discountPercent = 0;
          item.netAmount = item.amount + item.serviceAmount + item.tax;
          item.isHall = false;
          item.isAmended = false;
          item.isActive = true;

          grossAmount = grossAmount + item.amount;
          taxAmount = taxAmount + item.tax;
          serviceAmount = serviceAmount + item.serviceAmount;
          netAmount = netAmount + item.netAmount;
          items.add(item);
        }
      }
    }

    request.vatAmount = taxAmount;
    request.serviceAmount = serviceAmount;
    request.balanceAmount = netAmount;
    request.payableAmount = netAmount;
    request.grossAmount = grossAmount;
    if (selectedDeliveryCharges != null) {
      request.deliveryCharges = selectedDeliveryCharges.price != null
          ? selectedDeliveryCharges.price
          : 0;
    } else {}
    request.kunoozBookingItemDto = items;
    return request;
  }
}
