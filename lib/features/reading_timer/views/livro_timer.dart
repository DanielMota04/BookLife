import 'dart:async';
import 'dart:ui';
import 'package:book_life/features/reading_timer/viewmodels/timer_livro_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:book_life/core/models/book_model.dart';

class LivroTimer extends StatefulWidget {
  final Book livro;

  LivroTimer({super.key, required this.livro});

  @override
  State<LivroTimer> createState() => _LivroTimerState();
}

class _LivroTimerState extends State<LivroTimer> {
  late final LivroTimerViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LivroTimerViewModel(widget.livro);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? coverImageProvider;

    if (widget.livro.coverBytes != null && widget.livro.coverBytes!.isNotEmpty) {
      coverImageProvider = MemoryImage(widget.livro.coverBytes!);
    } else if (widget.livro.coverUrl != null &&
        widget.livro.coverUrl!.toString().isNotEmpty) {
      coverImageProvider = NetworkImage(widget.livro.coverUrl.toString());
    }
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () =>_viewModel.toggleFavorite(),
                icon: Icon(
                  _viewModel.livro.isFavorite ? Icons.star : Icons.star_border,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 32,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Hero(
                      tag: 'image_bg_${widget.livro.id}',
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: coverImageProvider != null
                              ? DecorationImage(
                                  image: coverImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(color: Colors.black.withOpacity(0.2)),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      child: Hero(
                        tag: 'capa_livro_${widget.livro.id}',
                        child: Container(
                          height: 220,
                          width: 160,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            image: coverImageProvider != null
                                ? DecorationImage(
                                    image: coverImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                Text(
                  widget.livro.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  "de ${widget.livro.author}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _viewModel.digitHours,
                      style: TextStyle(
                        fontSize: 100,
                        color: Theme.of(context).colorScheme.onPrimary,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 100,
                        color: Theme.of(context).colorScheme.onPrimary,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomRight,
                      children: [
                        Text(
                          _viewModel.digitMinutes,
                          style: TextStyle(
                            fontSize: 100,
                            color: Theme.of(context).colorScheme.onPrimary,
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Positioned(
                          bottom: -40,
                          child: Text(
                            _viewModel.digitSeconds,
                            style: TextStyle(
                              fontSize: 50,
                              color: Theme.of(context).colorScheme.onPrimary,
                              height: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => {
                          (!_viewModel.isRunning)
                              ? _viewModel.startTimer()
                              : _viewModel.stopTimer(),
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: (!_viewModel.isRunning)
                                ? Theme.of(context).colorScheme.tertiary
                                : Theme.of(context).colorScheme.error,
                            width: 2.0,
                          ),
                          backgroundColor: (!_viewModel.isRunning)
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.error,
                          foregroundColor: (!_viewModel.isRunning)
                              ? Theme.of(context).colorScheme.onTertiary
                              : Theme.of(context).colorScheme.onError,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          minimumSize: const Size(0, 50),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (!_viewModel.isRunning ? 'INICIAR' : "PARAR"),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_viewModel.hasProgress) ...[
                        SizedBox(width: 10),
                        IconButton.outlined(
                          onPressed: () {
                            _viewModel.addLaps();
                            _viewModel.resetTimer();
                          },
                          icon: Icon(Icons.flag),
                          style: IconButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            iconSize: 30,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                      if (_viewModel.hasProgress) ...[
                        ElevatedButton(
                          onPressed: () {
                            _viewModel.resetTimer();
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface,
                              width: 2,
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.inverseSurface,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onInverseSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            minimumSize: const Size(0, 50),
                          ),
                          child: Text(
                            'VOLTAR',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Divider(color: Theme.of(context).colorScheme.onPrimary),

                SizedBox(
                  width: double.infinity,
                  child: ExpansionTile(
                    shape: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    iconColor: Theme.of(context).colorScheme.onPrimary,
                    collapsedIconColor: Theme.of(context).colorScheme.onPrimary,
                    tilePadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text(
                      'Histórico de Leituras',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: _viewModel.laps.map((lap) {
                      return SizedBox(
                        height: 60,

                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lap.tempo,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                              Text(
                                lap.date,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
