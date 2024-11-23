import 'dart:convert';

import 'package:calculator/Theme/theme_changer.dart';
import 'package:calculator/data/history.dart';
import 'package:calculator/pages/history_page.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/UI/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String equation = "";
  String result = "";

  int historyIndex = 0;

  List<History> history = List.empty(growable: true);

  late SharedPreferences sp;
  getSharedPreferences() async {
    sp = await SharedPreferences.getInstance();
    readHistorySP();
  }

  saveHistorySP() {
    List<String> historyList =
        history.map((historys) => jsonEncode(historys.toJson())).toList();
    sp.setStringList('history', historyList);
  }

  readHistorySP() {
    List<String>? historyList = sp.getStringList('history');

    if (historyList != null) {
      history = historyList
          .map((historys) => History.fromJson(json.decode(historys)))
          .toList();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        equation = '';
        result = '';
      } else if (buttonText == "=") {
        try {
          String finalEquation = equation.replaceAll('x', '*');
          Parser p = Parser();
          Expression exp = p.parse(finalEquation);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';

          history.add(History(equation: equation, result: result));

        } catch (e) {
          result = '0';
        }
      } else if (buttonText == "backspace") {
        if (equation.isNotEmpty) {
          equation = equation.substring(0, equation.length - 1);
        }
      } else {
        equation += buttonText;
      }
    });
  }

  // animation

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                themeChanger.setTheme(ThemeMode.light);
              },
              icon: Icon(
                Icons.light_mode,
                color: themeChanger.themeMode == ThemeMode.light
                    ? Colors.yellow
                    : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                themeChanger.setTheme(ThemeMode.dark);
              },
              icon: Icon(
                Icons.dark_mode,
                color: themeChanger.themeMode == ThemeMode.dark
                    ? Colors.blue
                    : Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(
                    history: history,
                    onRemoveHistory: (onRemoveHistory) {
                      setState(() {
                        history.removeRange(historyIndex, history.length);
                        saveHistorySP();
                      });
                    },
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.history,
              size: 30,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              // Display Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          equation.isNotEmpty ? equation : '0',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '=',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              result.isNotEmpty ? result : '0',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              // Button Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10 ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // First Row of Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UiHelper.customButton(
                            btnText: 'e',
                            height: 40,
                            txtSize: 16,
                            onPressed: () => buttonPressed('e'),
                          ),
                          UiHelper.customButton(
                            btnText: 'µ',
                            txtSize: 16,
                            height: 40,
                            onPressed: () => buttonPressed('µ'),
                          ),
                          UiHelper.customButton(
                            btnText: 'sin',
                            txtSize: 16,
                            height: 40,
                            onPressed: () => buttonPressed('sin'),
                          ),
                          UiHelper.customButton(
                            btnText: 'deg',
                            height: 40,
                            txtSize: 16,
                            onPressed: () => buttonPressed('deg'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Second Row of Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UiHelper.customButton(
                            btnText: 'AC',
                            onPressed: () => buttonPressed('AC'),
                          ),
                          UiHelper.customButton(
                            icon: Icons.backspace_outlined,
                            onPressed: () => buttonPressed('backspace'),
                          ),
                          UiHelper.customButton(
                            btnText: '/',
                            color: const Color(0xFF1991FF),
                            textColor: Colors.white,
                            onPressed: () => buttonPressed('/'),
                          ),
                          UiHelper.customButton(
                            btnText: '*',
                            color: const Color(0xFF1991FF),
                            textColor: Colors.white,
                            onPressed: () => buttonPressed('*'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Third Row of Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UiHelper.customButton(
                            btnText: '9',
                            onPressed: () => buttonPressed('9'),
                          ),
                          UiHelper.customButton(
                            btnText: '8',
                            onPressed: () => buttonPressed('8'),
                          ),
                          UiHelper.customButton(
                            btnText: '7',
                            onPressed: () => buttonPressed('7'),
                          ),
                          UiHelper.customButton(
                            btnText: '-',
                            color: const Color(0xFF1991FF),
                            textColor: Colors.white,
                            onPressed: () => buttonPressed('-'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          // Left Column
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    UiHelper.customButton(
                                      btnText: '4',
                                      onPressed: () => buttonPressed('4'),
                                    ),
                                    UiHelper.customButton(
                                      btnText: '5',
                                      onPressed: () => buttonPressed('5'),
                                    ),
                                    UiHelper.customButton(
                                      btnText: '6',
                                      onPressed: () => buttonPressed('6'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    UiHelper.customButton(
                                      btnText: '1',
                                      onPressed: () => buttonPressed('1'),
                                    ),
                                    UiHelper.customButton(
                                      btnText: '2',
                                      onPressed: () => buttonPressed('2'),
                                    ),
                                    UiHelper.customButton(
                                      btnText: '3',
                                      onPressed: () => buttonPressed('3'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    UiHelper.customButton(
                                      btnText: '0',
                                      width: 160,
                                      onPressed: () => buttonPressed('0'),
                                    ),
                                    UiHelper.customButton(
                                      btnText: '.',
                                      color: const Color(0xFF1991FF),
                                      textColor: Colors.white,
                                      onPressed: () => buttonPressed('.'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Right Column
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Column(
                                  children: [
                                    UiHelper.customButton(
                                      btnText: '+',
                                      color: const Color(0xFF1991FF),
                                      textColor: Colors.white,
                                      height: 96,
                                      onPressed: () => buttonPressed('+'),
                                    ),
                                    const SizedBox(height: 8),
                                    UiHelper.customButton(
                                      btnText: '=',
                                      color: const Color(0xFF1991FF),
                                      textColor: Colors.white,
                                      height: 96,
                                      onPressed: () {
                                        buttonPressed('=');

                                        // setState(() {
                                        //   history.add(
                                        //     History(
                                        //       equation: equation,
                                        //       result: result,
                                        //     ),
                                        //   );

                                        //   historyIndex++;
                                        // });
                                        saveHistorySP();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
