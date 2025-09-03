import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/customcomponentfields/custom_raised_button.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/survey_answer_request.dart';
import 'package:slc/model/survey_question_request.dart';
import 'package:slc/model/survey_save_request.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/question_answer/bloc/bloc.dart';
import 'package:slc/view/question_answer/question_answer.dart';
import 'package:slc/view/question_answer/smily/bloc/bloc.dart';
import 'package:slc/view/survey/survey_question/bloc/bloc.dart';

class SurveyQuestions extends StatelessWidget {
  final double questionViewHeight;

  const SurveyQuestions({this.questionViewHeight});

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
      child: _SurveyQuestionsList(
        questionViewHeight: questionViewHeight,
      ),
    );
  }
}

class _SurveyQuestionsList extends StatefulWidget {
  final double questionViewHeight;

  const _SurveyQuestionsList({this.questionViewHeight});

  @override
  State<StatefulWidget> createState() {
    return _SurveyQuestions();
  }
}

List<SurveyQuestionRequest> surveySaveRequestList = [];
var cardIndex = -1;
int selectedFacilityId = 0;
int faciliyId = 0;
final listKey = const Key('__statsLoadingIndicator__');
String multiTextValidator = '';

String engValidate = 'MMMM';

class _SurveyQuestions extends State<_SurveyQuestionsList> {
  final GlobalKey<FormBuilderState> _surveyFormKey =
      GlobalKey<FormBuilderState>();

  String oldText = "";
  String updatedText = "";

  bool showSubmitBtn = false;
  List<int> feedbackArr = [];

  final _doUHvComment = TextEditingController();

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
    return BlocListener<SurveyQuestionBloc, SurveyQuestionState>(
      listener: (context, state) {
        if (state is UpdateSurveyQuestionListState) {
          BlocProvider.of<QuestionAnswerBloc>(context)
            ..add(PopulateQAListEvent(
                surveySaveRequestList: state.surveySaveRequestList,
                id: state.facilityId));
        } else if (state is SelectedSmilyDetailsState) {
          feedbackArr[state.cardPosition] = state.smilyPosition;
        }
      },
      child: BlocBuilder<SurveyQuestionBloc, SurveyQuestionState>(
        builder: (context, state) {
          if (state is UpdateSurveyQuestionListState) {
            feedbackArr.clear();
            _doUHvComment.clear();
            surveySaveRequestList = state.surveySaveRequestList;
            surveySaveRequestList.forEach((f) {
              feedbackArr.add(-1);
            });
            faciliyId = state.facilityId;
          } else if (state is RefreshSurveyQuestionListState) {
            BlocProvider.of<SurveyQuestionBloc>(context)
              ..add(GetSurveyQuestionListEvent(id: faciliyId));
            _doUHvComment.clear();
          }
          return mainUI();
        },
      ),
    );
  }

  Widget showTempView() {
    return Container();
  }

  Widget mainUI() {
    return Container(
      child: Column(
        children: <Widget>[
          QuestionAnswer(
            feedBackType: Constants.FEEDBACK_TYPE_SURVEY,
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
                  style: PackageListHead.textFieldStyles(context, false))),

          FormBuilder(
            key: _surveyFormKey,
            child: Container(
              margin: EdgeInsets.all(8.0),
              // hack textfield height
              padding: EdgeInsets.only(bottom: 40.0),
              child: FormBuilderTextField(
                inputFormatters: [
                  // WhitelistingTextInputFormatter(
                  //     new RegExp(r'[A-Za-z0-9 ,+.\n]'))
                  FilteringTextInputFormatter.allow(
                      new RegExp(r'[A-Za-z0-9 ,+.\n]')),
                ],
                enableInteractiveSelection: false,
                // keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                controller: _doUHvComment,
                maxLines: 4,
                maxLength: 3500,
                name: tr("do_hv_comment"),
                style: PackageListHead.textFieldStylesSurvey(context, false),

                decoration: InputDecoration(
                  // hintText: "Comment!",
                  border: OutlineInputBorder(),
                  labelStyle: PackageListHead.textFieldStyles(context, false),
                ),
              ),
            ),
          ),
          // if (showSubmitBtn)
          CustomRaisedButton(
              tr("submit"),
              () => {
                    submitBtnClick(),
                  }),
        ],
      ),
    );
  }

  submitBtnClick() {
    /*To reset the facility id from notification navigation*/
    SPUtil.remove(Constants.SELECTED_FACILITY_ID);
    /*To reset the facility id from notification navigation*/

    if (_surveyFormKey.currentState.saveAndValidate()) {
      print(_surveyFormKey.currentState.value);
      bool isAllSelected = true;
      for (var i = 0; i < surveySaveRequestList.length; i++) {
        if (feedbackArr[i] == -1) {
          isAllSelected = false;
          Utils().customGetSnackBarWithOutActionButton(
              tr('error_caps'),
              tr("txt_please_select") + " " + surveySaveRequestList[i].question,
              context);

          break;
        }
      }
      if (isAllSelected) {
        SurveySaveRequest request = SurveySaveRequest();
        List<SurveyAnswerRequest> answerRequest = [];
//        request.facilityId = selectedFacilityId;
        request.facilityId = faciliyId;
        request.userId = SPUtil.getInt(Constants.USERID);
        request.comments = _doUHvComment.text.toString();

        for (int i = 0; i < surveySaveRequestList.length; i++) {
          SurveyAnswerRequest r = SurveyAnswerRequest();
          List<int> answerIds = [];

          r.questionId = surveySaveRequestList[i].questionId;
          answerIds.add(feedbackArr[i]);

          r.answerId = answerIds;
          answerRequest.add(r);
        }
        request.answerList = answerRequest;
        BlocProvider.of<SurveyQuestionBloc>(context)
          ..add(SurveySaveBtnPressed(request: request));
      }
    }
  }

  feedBckSmiliClick(btnIndex, cardIndex) {
    setState(() {
      feedbackArr[cardIndex] = btnIndex;
      showSubmitBtn = true;
    });
  }
}
