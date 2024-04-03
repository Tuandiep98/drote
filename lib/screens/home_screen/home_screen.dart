import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:drote/screens/drawing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late IBoardViewModel _viewModel;
  @override
  void initState() {
    _viewModel = context.read<IBoardViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _viewModel.init();
      if (_viewModel.currentBoard != null) {
        _viewModel.setCurrentBoard(_viewModel.currentBoard!);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DrawingPage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IBoardViewModel>(builder: (_, viewmodel, __) {
      return Scaffold(
        body: GridView.count(
          padding: const EdgeInsets.all(15),
          crossAxisCount: MediaQuery.of(context).size.width ~/ 250,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          children: _viewModel.allBoards
              .map(
                (e) => InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    _viewModel.setCurrentBoard(e);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DrawingPage(),
                      ),
                    );
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 250,
                      maxWidth: 250,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Container(
                          height: 60,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(11),
                              bottomRight: Radius.circular(11),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(e.name),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}
