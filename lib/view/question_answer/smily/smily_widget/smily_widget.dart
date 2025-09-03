import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/model/survey_answer.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/view/event_specific_view/event_specific_view_content/bloc/bloc.dart';
import 'package:slc/view/question_answer/smily/bloc/bloc.dart';
import 'package:slc/view/question_answer/smily/smily_widget/bloc/bloc.dart';
import 'package:slc/view/survey/survey_question/bloc/bloc.dart';

// ignore: must_be_immutable
class SmileyWidget extends StatelessWidget {
  final List<SurveyAnswer> answerList;
  final int cardPosition;
  int selectedPosition;
  String feedbackType;

  SmileyWidget(
      {this.answerList,
      this.cardPosition,
      this.selectedPosition,
      this.feedbackType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SmilyWidgetBloc()
          ..add(CreateSmilyWidgetEvent(
              answerList: answerList,
              cardPosition: cardPosition,
              selectedPosition: selectedPosition,
              feedbackType: feedbackType));
      },
      child: _SmileyWidget(),
    );
  }
}

class _SmileyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<_SmileyWidget> {
  int _value = -1;
  String feedbackType;
  SilentNotificationHandler silentNotificationHandler =
      SilentNotificationHandler.instance;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SmilyWidgetBloc, SmilyWidgetState>(
      listener: (context, state) {},
      child: BlocBuilder<SmilyWidgetBloc, SmilyWidgetState>(
        builder: (context, state) {
          debugPrint("create widget");
          if (state is CreateNewSmilyWidgetState) {
            debugPrint("create widget1");
            feedbackType = state.feedbackType;
            return mainUi(state.answerList, state.cardPosition);
          }
          return Container();
        },
      ),
    );
  }

  Widget mainUi(List<SurveyAnswer> answerList, int cardPosition) {
    return Container(
      child: Row(
        children: buildImageRow(answerList, cardPosition),
      ),
    );
  }

  List<Widget> buildImageRow(List<SurveyAnswer> answerList, int cardPosition) {
    List<Widget> widgetList = [];
    for (int i = 0; i < answerList.length; i++) {
      widgetList.add(MaterialButton(
        onPressed: () {
          BlocProvider.of<SmilyBloc>(context)
            ..add(CardAnimationEvent(isAnimate: true));
          setState(() {
            if (feedbackType == Constants.FEEDBACK_TYPE_EVENT) {
              silentNotificationHandler.updateData(
                  {Constants.NOTIFICATION_KEY: Constants.KEYBOARD_HIDE_REVIEW});
              BlocProvider.of<EventReviewWriteContentBloc>(context)
                ..add(SelectedReviewDetailsQuestionEvent(
                    smilyPosition: answerList[i].answerId,
                    cardPosition: cardPosition));
            } else if (feedbackType == Constants.FEEDBACK_TYPE_SURVEY) {
              silentNotificationHandler.updateData(
                  {Constants.NOTIFICATION_KEY: Constants.KEYBOARD_HIDE_SURVEY});
              BlocProvider.of<SurveyQuestionBloc>(context)
                ..add(SelectedSmilyDetailsEvent(
                    smilyPosition: answerList[i].answerId,
                    cardPosition: cardPosition));
            }
            _value = i;
          });
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              (_value == i)
                  ? CachedNetworkImage(
                      height: 20,
                      imageUrl: answerList[i].imageUrlActive,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                            height: 15.0,
                            width: 15.0,
                            child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : CachedNetworkImage(
                      height: 20,
                      imageUrl: answerList[i].imageUrlInActive,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                            height: 15.0,
                            width: 15.0,
                            child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(answerList[i].answer,
                    style: PackageListHead.textFieldStyles(context, false)),
              ),
            ],
          ),
        ),
      ));
    }
    return widgetList;
  }
}
