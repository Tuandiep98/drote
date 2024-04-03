import 'package:drote/core/view_models/implements/board_viewmodel.dart';
import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> viewModelProviders = [
  ChangeNotifierProvider<IBoardViewModel>(
    create: (_) => BoardViewModel(),
  ),
];
