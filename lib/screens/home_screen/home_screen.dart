import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
// import 'package:drote/screens/drawing_canvas/drawing_canvas.dart';
import 'package:drote/screens/drawing_screen/drawing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

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
      await _viewModel.init(context.size ?? const Size(1920, 1080));
      if (_viewModel.currentBoard != null) {
        // ignore: use_build_context_synchronously
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
    return Consumer<IBoardViewModel>(
      builder: (_, viewmodel, __) {
        return Scaffold(
          backgroundColor: const Color(0xFFEEEEEE),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add new board',
            child: const Icon(Icons.add),
            onPressed: () async => await _viewModel.createNewBoard(context.size ?? const Size(1920, 1080)),
          ),
          body: Scrollbar(
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(15, kIsWeb ? 15 : 40, 15, 80),
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
                          color: const Color(0xFFDDDDDD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            // SizedBox(
                            //   width: 50,
                            //   height: 50,
                            //   child: CustomPaint(
                            //     size: const Size(10, 50),
                            //     painter: SketchPainter(
                            //       sketches: viewmodel.allSketches,
                            //     ),
                            //   ),
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    PullDownButton(
                                      itemBuilder: (context) => [
                                        PullDownMenuItem(
                                          onTap: () async =>
                                              await _viewModel.deleteBoard(e),
                                          title: 'Delete',
                                          subtitle:
                                              'Permantly delete this board',
                                          isDestructive: true,
                                          icon: CupertinoIcons.delete,
                                        ),
                                      ],
                                      buttonBuilder: (context, showMenu) =>
                                          CupertinoButton(
                                        onPressed: showMenu,
                                        padding: EdgeInsets.zero,
                                        child: const Icon(
                                          CupertinoIcons.ellipsis_circle,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 75,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(11),
                                      bottomRight: Radius.circular(11),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          DateFormat('hh:mm dd/MM/yyyy')
                                              .format(e.createdTime),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
