import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/model/survey_question_request.dart';
import 'package:slc/view/question_answer/smily/bloc/bloc.dart';
import 'package:slc/view/question_answer/smily/smily.dart';

import 'bloc/bloc.dart';

// ignore: must_be_immutable
class QuestionAnswer extends StatelessWidget {
  String feedBackType;

  QuestionAnswer({this.feedBackType});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SmilyBloc>(
          create: (context) {
            return SmilyBloc();
          },
        ),
      ],
      child: _QuestionAnswer(
        feedBackType: feedBackType,
      ),
    );
  }
}

// ignore: must_be_immutable
class _QuestionAnswer extends StatefulWidget {
  String feedBackType;

  _QuestionAnswer({this.feedBackType});

  @override
  State<StatefulWidget> createState() {
    return _ListView();
  }
}

class _ListView extends State<_QuestionAnswer> {
  List<SurveyQuestionRequest> surveySaveRequestList = [];
  List<int> feedbackArr = [];
  int keyId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionAnswerBloc, QuestionAnswerState>(
      listener: (context, state) {
        if (state is PopulateQAListState) {
          surveySaveRequestList.clear();
          surveySaveRequestList = state.surveySaveRequestList;
//          keyId = state.id;
          debugPrint("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
          keyId = Random().nextInt(100000000);
        }
      },
      child: BlocBuilder<QuestionAnswerBloc, QuestionAnswerState>(
        builder: (context, state) {
          return mainUI();
        },
      ),
    );
  }

  Widget mainUI() {
    return Container(
      key: Key(keyId.toString()),
      child: Column(children: bindData()),
    );
  }

  List<Widget> bindData() {
    List<Widget> view = [];
    for (int i = 0; i < surveySaveRequestList.length; i++) {
//      if (surveySaveRequestList[i].questionTypeId == 2) {
      view.add(Smiley(
        surveySaveRequest: surveySaveRequestList[i],
        cardPosition: i,
        feedBackType: widget.feedBackType,
      ));
//      }
    }

    return view;
  }
}
