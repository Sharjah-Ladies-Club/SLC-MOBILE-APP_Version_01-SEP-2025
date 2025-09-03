import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/survey_question_request.dart';
import 'package:slc/theme/styles.dart';

import 'bloc/bloc.dart';
import 'radio_widget/radio_widget.dart';
import 'smily_widget/smily_widget.dart';

// ignore: must_be_immutable
class Smiley extends StatelessWidget {
  Key key;
  SurveyQuestionRequest surveySaveRequest;
  int cardPosition;
  bool isSelected = false;
  String feedBackType;

  Smiley({this.surveySaveRequest, this.cardPosition, this.feedBackType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SmilyBloc>(
      create: (context) => SmilyBloc()
        ..add(SmilyCardCreateEvent(
            cardListValue: surveySaveRequest, cardPosition: cardPosition)),
      child: _Smiley(
        isSelected: isSelected,
        feedBackType: feedBackType,
      ),
    );
  }
}

// ignore: must_be_immutable
class _Smiley extends StatefulWidget {
  bool isSelected;
  SurveyQuestionRequest surveySaveRequest;
  String feedBackType;

  _Smiley({this.isSelected, this.surveySaveRequest, this.feedBackType});

  State<StatefulWidget> createState() {
    return _SmileyCard();
  }
}

class _SmileyCard extends State<_Smiley> {
  SurveyQuestionRequest cardListValue = SurveyQuestionRequest();
  int cardPosition;

  Widget build(BuildContext context) {
    return BlocListener<SmilyBloc, SmilyState>(
      listener: (context, state) {
        //debugPrint("jjjjjjjjjjjjjjjjjjjjjjjjjj");
      },
      child: BlocBuilder<SmilyBloc, SmilyState>(
        builder: (context, state) {
          if (state is SmilyCardCreateNewState) {
            //  debugPrint("coming inside the cardddddd ");
            cardListValue = state.cardListValue;
            cardPosition = state.cardPosition;
          } else if (state is CardAnimationState) {
            //   debugPrint("coming inside the card anim");
            state.isAnimate != null
                ? widget.isSelected = state.isAnimate
                : widget.isSelected = false;
          } else if (state is RefreshSmilyState) {
            //debugPrint("coming inside the card refresh ");
            cardListValue = state.cardListValue;
            cardPosition = state.cardPosition;
            widget.isSelected = state.isAnimate;
          }
          return mainUi();
        },
      ),
    );
  }

  Widget mainUi() {
    // debugPrint("surveySaveRequestList kkkkkkkkkkkkkkkkkkkkkkkkkkkk" +
    //     ((cardListValue != null && cardListValue.question != null)
    //         ? cardListValue.question
    //         : ''));
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
        elevation: widget.isSelected ? 5 : 0,
        color: widget.isSelected ? Colors.white : ColorData.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.all(7.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: Center(
                    child: Text(
                      (cardListValue != null && cardListValue.question != null)
                          ? cardListValue.question
                          : '',
                      style: PackageListHead.textFieldStyles(context, false),
                    ),
                  ),
                ),
              ),
              (cardListValue != null && cardListValue.answerViews != null)
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: bindData())),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> bindData() {
    debugPrint("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    //              Container(
//                height: MediaQuery.of(context).size.height * (10.0 / 100.0),
//                alignment: Alignment.center,
//                margin: EdgeInsets.only(bottom: 15.0, top: 15.0),
//                child: ListView.builder(
//                    scrollDirection: Axis.horizontal,
//                    itemCount: (cardListValue != null &&
//                            cardListValue.answerViews != null)
//                        ? 1
//                        : 0,
//                    itemBuilder: (context, i) {
//                      if (cardListValue.questionTypeId == 2) {
//                        return SmilyWidget(
//                          answerList: cardListValue.answerViews,
//                          cardPosition: cardPosition,
//                          selectedPosition: -1,
//                          feedbackType: widget.feedBackType,
//                        );
//                      } else if (cardListValue.questionTypeId == 1) {
//                        return RadioWidget(
//                          answerList: cardListValue.answerViews,
//                          cardPosition: cardPosition,
//                          selectedPosition: -1,
//                          feedbackType: widget.feedBackType,
//                        );
//                      }
//                    }),
//              ),

    List<Widget> view = [];
    debugPrint(
        "sdfkjndsfjkdnsjkgnsdgjknsgjksngksjngdgjnfdkjgndfgnsdgnjdgkjdngkdngdsngdnkg" +
            cardPosition.toString());

    view.add((cardListValue.questionTypeId == 2)
        ? SmileyWidget(
            answerList: cardListValue.answerViews,
            cardPosition: cardPosition,
            selectedPosition: -1,
            feedbackType: widget.feedBackType,
          )
        : RadioWidget(
            answerList: cardListValue.answerViews,
            cardPosition: cardPosition,
            selectedPosition: -1,
            feedbackType: widget.feedBackType,
          ));

    return view;
  }
}
