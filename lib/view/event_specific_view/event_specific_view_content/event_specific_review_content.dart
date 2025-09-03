import 'dart:ui' as prefix;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/custom_raised_button.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/event_review_question_details.dart';
import 'package:slc/model/review_feed_back_request.dart';
import 'package:slc/model/survey_answer_request.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/view/event_specific_view/event_specific_view_content/bloc/bloc.dart';
import 'package:slc/view/question_answer/bloc/bloc.dart';
import 'package:slc/view/question_answer/question_answer.dart';
import 'package:slc/view/question_answer/smily/bloc/bloc.dart';

// ignore: must_be_immutable
class EventSpecificReviewContent extends StatelessWidget {
  int eventId;

  EventSpecificReviewContent(this.eventId);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuestionAnswerBloc>(
          create: (context) {
            return QuestionAnswerBloc(null);
          },
        ),
        BlocProvider<SmilyBloc>(
          create: (context) {
            return SmilyBloc();
          },
        ),
      ],
      child: _EventSpecificReviewContent(eventId),
    );
  }
}

// ignore: must_be_immutable
class _EventSpecificReviewContent extends StatefulWidget {
  int eventId;

  _EventSpecificReviewContent(
    this.eventId,
  );

  @override
  State<StatefulWidget> createState() {
    return _ContentView();
  }
}

bool checked = false;

class _ContentView extends State<_EventSpecificReviewContent> {
  EventReviewQuestion eventReviewQuestion;
  final GlobalKey<FormBuilderState> _surveyFormKey =
      GlobalKey<FormBuilderState>();
  String multiTextValidator = '';

  MaskedTextController _doUHvComment = MaskedTextController(mask: 'MMMM');

  List<int> feedbackArr = [];

  @override
  void initState() {
    setState(() {
      for (var i = 0; i < 3500; i++) {
        multiTextValidator = multiTextValidator + 'M';
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _doUHvComment.updateMask(multiTextValidator);
    return BlocListener<EventReviewWriteContentBloc,
        EventReviewWriteContentState>(
      listener: (context, state) {
        if (state is OnQuestionLoadSuccess) {
          BlocProvider.of<QuestionAnswerBloc>(context)
            ..add(PopulateQAListEvent(
                surveySaveRequestList: state.eventReviewQuestion.question,
                id: 0));
        } else if (state is SelectedReviewDetailsQuestionState) {
          feedbackArr[state.cardPosition] = state.smilyPosition;
          SPUtil.putBool('reviewed', true);
          SPUtil.putIntegerList("FeedBackSelectedList", feedbackArr);
        }
      },
      child: BlocBuilder<EventReviewWriteContentBloc,
          EventReviewWriteContentState>(
        builder: (context, state) {
          if (state is OnQuestionLoadSuccess) {
            if (!SPUtil.getBool('reviewed')) {
              feedbackArr.clear();
              eventReviewQuestion = state.eventReviewQuestion;
              eventReviewQuestion.question.forEach((f) {
                feedbackArr.add(-1);
              });
            }
          }

          return getManiUI(eventReviewQuestion);
        },
      ),
    );
  }

  @override
  void dispose() {
    _doUHvComment.dispose();
    super.dispose();
  }

  getManiUI(EventReviewQuestion eventReviewQuestion) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                    eventReviewQuestion != null
                        ? eventReviewQuestion.eventBasic.name != null
                            ? eventReviewQuestion.eventBasic.name
                            : ""
                        : "",
                    style: TextStyle(
                        color: ColorData.colorBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontFamily: tr('currFontFamily')))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(CommonIcons.location,
                        color: Colors.black45, size: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 5.0),
                      child: Text(
                        eventReviewQuestion != null
                            ? eventReviewQuestion.eventBasic.venue != null
                                ? eventReviewQuestion.eventBasic.venue
                                : ""
                            : "",
                        style: TextStyle(
                            color: ColorData.primaryTextColor,
                            fontSize: 14.0,
                            fontFamily: tr('currFontFamily')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(CommonIcons.calendar_border,
                    size: 15, color: ColorData.primaryTextColor),
                Padding(
                    padding:
                        Localizations.localeOf(context).languageCode == "en"
                            ? EdgeInsets.only(left: 5.0, top: 4.0)
                            : EdgeInsets.only(right: 5.0, top: 4.0),
                    child: new Text(
                      eventReviewQuestion != null
                          ? eventReviewQuestion.eventBasic.dateRange != null
                              ? eventReviewQuestion.eventBasic.dateRange
                              : ""
                          : "",
                      textDirection: prefix.TextDirection.ltr,
                      style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: 14.0,
                        fontFamily: tr('currFontFamilyEnglishOnly'),
                      ),
                    ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(CommonIcons.time_half,
                    size: 15, color: ColorData.primaryTextColor),
                Padding(
                  padding: Localizations.localeOf(context).languageCode == "en"
                      ? EdgeInsets.only(left: 5.0, top: 4.0)
                      : EdgeInsets.only(right: 5.0, top: 4.0),
                  child: Text(
                      eventReviewQuestion != null
                          ? eventReviewQuestion.eventBasic.timeRange != null
                              ? eventReviewQuestion.eventBasic.timeRange
                              : ""
                          : "",
                      textDirection: prefix.TextDirection.ltr,
                      style: TextStyle(
                          color: ColorData.primaryTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: "HelveticaNeue")),
                )
              ],
            ),
          ),
          QuestionAnswer(
            feedBackType: Constants.FEEDBACK_TYPE_EVENT,
          ),
          Container(
              alignment: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                      Constants.LANGUAGE_ARABIC
                  ? Alignment.topRight
                  : Alignment.topLeft,
              margin: SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
                      Constants.LANGUAGE_ARABIC
                  ? EdgeInsets.only(top: 15.0, right: 10.0)
                  : EdgeInsets.only(top: 15.0, left: 10.0),
              child: Text(tr("do_hv_comment"),
                  style: TextStyle(
                    color: ColorData.primaryTextColor,
                    fontFamily: tr("currFontFamily"),
                  ))),
          FormBuilder(
            key: _surveyFormKey,
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.only(bottom: 40.0),
              child: FormBuilderTextField(
                enableInteractiveSelection: false,
                textInputAction: TextInputAction.done,
                controller: _doUHvComment,
                maxLines: 4,
                maxLength: 3500,
                name: tr("do_hv_comment"),
                style: PackageListHead.textFieldStyles(context, false),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: PackageListHead.textFieldStyles(context, false),
                ),
              ),
            ),
          ),
          CustomRaisedButton(tr("submit"), () {
            //HideKeyboard
            FocusScope.of(context).requestFocus(new FocusNode());
            submitBtnClick(context);
          }),
          //   )
        ],
      ),
    );
  }

  submitBtnClick(BuildContext context) {
    List<int> selectedList =
        SPUtil.getIntegerList("FeedBackSelectedList", feedbackArr.length);
    if (eventReviewQuestion != null) {
      if (eventReviewQuestion.question != null) {
        bool isAllSelected = true;
        for (var i = 0; i < eventReviewQuestion.question.length; i++) {
          if (selectedList[i] < 0) {
            isAllSelected = false;
            Get.snackbar(tr("txt_please_select"),
                eventReviewQuestion.question[i].question);
            break;
          }
        }
        if (isAllSelected) {
          ReviewFeedBackRequest reviewFeedBackRequest =
              new ReviewFeedBackRequest();
          reviewFeedBackRequest.eventId =
              eventReviewQuestion.eventBasic.eventId;
          reviewFeedBackRequest.userId = SPUtil.getInt(Constants.USERID);
          reviewFeedBackRequest.comments = _doUHvComment.text;

          List<SurveyAnswerRequest> answerRequest = [];

          for (int i = 0; i < eventReviewQuestion.question.length; i++) {
            SurveyAnswerRequest r = SurveyAnswerRequest();
            List<int> answerIds = [];
            r.questionId = eventReviewQuestion.question[i].questionId;
            answerIds.add(selectedList[i]);
            r.answerId = answerIds;
            answerRequest.add(r);
          }
          reviewFeedBackRequest.answerList = answerRequest;

          BlocProvider.of<EventReviewWriteContentBloc>(context).add(
              EventSaveWriteReview(
                  reviewFeedBackRequest: reviewFeedBackRequest));
        }
      }
    }
  }
}
