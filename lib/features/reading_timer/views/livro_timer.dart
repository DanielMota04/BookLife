import 'dart:async';
import 'dart:ui';
import 'package:book_life/features/reading_timer/repositories/examples_books.dart';
import 'package:flutter/material.dart';
import 'package:book_life/core/models/book_model.dart';

class LivroTimer extends StatefulWidget {
  final Book livro;

  LivroTimer({super.key, required this.livro});

  @override
  State<LivroTimer> createState() => _LivroTimerState();
}

class _LivroTimerState extends State<LivroTimer> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = '00', digitMinutes = '00', digitHours = '00';
  Timer? timer;
  bool start = false;
  List<Map<String, String>> laps = [];
  String? dataFormatada;

  void stopTimer() {
    timer!.cancel();
    setState(() {
      start = false;
    });
  }

  void resetTimer() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitHours = '00';
      digitMinutes = '00';
      digitSeconds = '00';

      start = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    DateTime agora = DateTime.now();
    String dataAtual =
        "${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year}";
    String horaAtual =
        " às ${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}";
    setState(() {
      laps.add({"tempo": lap, "date": dataAtual, 'hours': horaAtual});
    });
  }

  void startTimer() {
    start = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;
      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? '$seconds' : '0$seconds';
        digitMinutes = (minutes >= 10) ? '$minutes' : '0$minutes';
        digitHours = (hours >= 10) ? '$hours' : '0$hours';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final livroAtualizado = mockLivros.firstWhere(
      (b) => b.id == widget.livro.id,
      orElse: () => widget.livro,
    );
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
            onPressed: () {
              setState(() {
                int index = mockLivros.indexWhere(
                  (l) => l.id == livroAtualizado.id,
                );
                if (index != -1) {
                  mockLivros[index] = mockLivros[index].toggleFavorite();
                }
              });
            },
            icon: Icon(
              livroAtualizado.isFavorite ? Icons.star : Icons.star_border,
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
                      image: DecorationImage(
                        image: NetworkImage(widget.livro.coverUrl.toString()),
                        fit: BoxFit.cover,
                      ),
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
                        image: DecorationImage(
                          image: NetworkImage(widget.livro.coverUrl.toString()),
                          fit: BoxFit.cover,
                        ),
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
                  digitHours,
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
                      digitMinutes,
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
                        digitSeconds,
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
                    onPressed: () => {(!start) ? startTimer() : stopTimer()},
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: (!start)
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.error,
                        width: 2.0,
                      ),
                      backgroundColor: (!start)
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.error,
                      foregroundColor: (!start)
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
                          (!start ? 'INICIAR' : "PARAR"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (seconds > 0 || minutes > 0 || hours > 0) ...[
                    SizedBox(width: 10),
                    IconButton.outlined(
                      onPressed: () {
                        addLaps();
                        resetTimer();
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
                  if (seconds > 0 || minutes > 0 || hours > 0) ...[
                    ElevatedButton(
                      onPressed: () {
                        resetTimer();
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.inverseSurface,
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
                children: laps.map((lap) {
                  return SizedBox(
                    height: 60,

                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lap['tempo']!,
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            lap['date']!,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onPrimary,
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
  }
}
