import 'package:bloc/bloc.dart';

import './bloc.dart';

class ReviewDetailBloc extends Bloc<ReviewDetailsEvent, ReviewDetailsState> {
  ReviewDetailBloc() : super(null);
  ReviewDetailsState get initialState => InitialReviewDetailsState();

  @override
  Stream<ReviewDetailsState> mapEventToState(ReviewDetailsEvent event) async* {
    if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    } else if (event is ShowProgressBarEvent) {
      yield ShowProgressBar();
    } else if (event is HideProgressBarEvent) {
      yield HideProgressBar();
    }
  }
}
