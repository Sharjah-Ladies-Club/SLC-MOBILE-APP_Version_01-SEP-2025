import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/customcomponentfields/custom_radio_button_group/custom_check_box_group.dart';
import 'package:slc/model/survey_answer.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/view/event_specific_view/event_specific_view_content/bloc/bloc.dart';
import 'package:slc/view/question_answer/smily/bloc/bloc.dart';
import 'package:slc/view/survey/survey_question/bloc/bloc.dart';

import 'bloc/bloc.dart';

// ignore: must_be_immutable
class RadioWidget extends StatelessWidget {
  final List<SurveyAnswer> answerList;
  final int cardPosition;
  int selectedPosition;
  String feedbackType;
  Key key;

  RadioWidget(
      {this.key,
      this.answerList,
      this.cardPosition,
      this.selectedPosition,
      this.feedbackType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return RadioWidgetBloc(null)
          ..add(CreateRadioWidgetEvent(
              answerList: answerList,
              cardPosition: cardPosition,
              selectedPosition: selectedPosition,
              feedbackType: feedbackType));
      },
      child: _RadioWidget(),
    );
  }
}

class _RadioWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<_RadioWidget> {
  String feedbackType;
  SilentNotificationHandler silentNotificationHandler =
      SilentNotificationHandler.instance;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RadioWidgetBloc, RadioWidgetState>(
      listener: (context, state) {},
      child: BlocBuilder<RadioWidgetBloc, RadioWidgetState>(
        builder: (context, state) {
          if (state is CreateNewRadioWidgetState) {
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
        alignment: Alignment.topLeft,
        child: CheckboxGroup(
          activeColor: Theme.of(context).primaryColor,
          labelStyle: PackageListHead.textFieldStyles(context, false),
          labels: answerList,
          onChange: (bool isChecked, int eventAnswerId, int index) {
            if (feedbackType == Constants.FEEDBACK_TYPE_EVENT) {
              silentNotificationHandler.updateData(
                  {Constants.NOTIFICATION_KEY: Constants.KEYBOARD_HIDE_REVIEW});
              BlocProvider.of<EventReviewWriteContentBloc>(context)
                ..add(SelectedReviewDetailsQuestionEvent(
                    smilyPosition: eventAnswerId, cardPosition: cardPosition));
            } else if (feedbackType == Constants.FEEDBACK_TYPE_SURVEY) {
              silentNotificationHandler.updateData(
                  {Constants.NOTIFICATION_KEY: Constants.KEYBOARD_HIDE_SURVEY});
              BlocProvider.of<SmilyBloc>(context)
                ..add(CardAnimationEvent(isAnimate: true));
              BlocProvider.of<SurveyQuestionBloc>(context)
                ..add(SelectedSmilyDetailsEvent(
                    smilyPosition: eventAnswerId, cardPosition: cardPosition));
            }
          },
        ));
  }
}
