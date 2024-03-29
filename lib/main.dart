import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:intl/date_symbol_data_local.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  late String past_email;
  late String past_pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              TextFormField(
                initialValue: past_email,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                initialValue: past_pass,
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setStringList('my_string_list', [email, password]);
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return _start(email0: email,);
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoText = "登録に失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlinedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setStringList('my_string_list', [email, password]);
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return _start(email0: email,);
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String> inf = prefs.getStringList('my_string_list') ?? ['',''];
      email = inf[0];
      password = inf[1];
      past_email = inf[0];
      past_pass = inf[1];
    });
  }

  @override
  void initState() {
    super.initState();
    // 初期化時にShared Preferencesに保存している値を読み込む
    _getPrefItems();
  }
}

class _start extends StatefulWidget{
  const _start({required this.email0});
  final String email0;
  @override
  State<_start> createState() => _startPageState(email1: email0);
}

class _startPageState extends State<_start> {
  _startPageState({required this.email1});

  final String email1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Center(
            child: Text(
              'start',
              style: TextStyle(
                fontSize: 46.0,
                color: Colors.black54,
              ),
            ),
          ),
          onPressed: () async{
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return MyHomePage(email2: email1,);
              }),
            );
          },
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,required this.email2});

  final String email2;

  @override
  State<MyHomePage> createState() => _MyHomePageState(email3: email2);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.email3});

  final String email3;

  double appBarHeight = AppBar().preferredSize.height;

  String rate = '';
  List<String> lis = ['','','','','',''];
  List<String> ans = ['',''];
  List<String> change_score = [];
  List<String> change_acc = [];
  int num1 = 0;
  int num2 = 0;
  int max = 300;
  int _accurate = 0;
  int past_acc = 0;
  static final controller1 = PublishSubject<String>();
  static final controller2 = PublishSubject<String>();
  int time = 0;
  Map<String, dynamic> pre_map = new Map();

  void _incrementCounter(String letter) {
    setState(() {
      var random = math.Random();
      if(letter != ' '){
        for(var i = 1;i < 6;i++){
          lis[i-1] = lis[i];
        }
        lis[5] = (random.nextInt(9)+1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('クレペリン検査'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            ' ',
                          ),
                          Text(
                            'No. ',style: TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 25,
                          ),
                          ),
                        ],
                      ),
                      Text(
                        (num1+1).toString(),
                        style: TextStyle(
                          color: Colors.indigoAccent,
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              '${lis[0]} ${lis[1]} ',
                              style: const TextStyle(
                                fontSize: 50,
                              ),
                            ),
                            Text(
                              '   ${ans[0]}   ${ans[1]}',
                              style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        ' ${lis[2]} ${lis[3]} ',
                        style: const TextStyle(
                          fontSize: 100,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              ' ${lis[4]} ${lis[5]}',
                              style: const TextStyle(
                                fontSize: 50,
                              ),
                            ),
                            const Text(
                              ' ',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Keyboard(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  @override
  void initState() {
    setState(() {
      var random = math.Random();
      if(num1 == 0) {
        lis[0] = '*';
        lis[1] = '*';
        for (var i = 2; i < 6; i++) {
          lis[i] = (random.nextInt(9) + 1).toString();
        }
      }
      Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) {
          if(time >= max){
            timer.cancel();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
                  title: Column(
                    children: [
                      Text("Complete!"),
                      Text(' '),
                      Text(
                        '解答数　' + num1.toString(),
                      ),
                      Text(
                        '正解数　' + _accurate.toString(),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    // ボタン領域
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () async{
                        var index = await FirebaseFirestore.instance.collection('user').doc(email3).get();
                        pre_map['answer'] = num1.toString();
                        pre_map['correct'] = _accurate.toString();
                        pre_map['0~1 ans'] = change_score[0].toString();
                        pre_map['1~2 ans'] = change_score[1].toString();
                        pre_map['2~3 ans'] = change_score[2].toString();
                        pre_map['3~4 ans'] = change_score[3].toString();
                        pre_map['4~5 ans'] = change_score[4].toString();
                        pre_map['0~1 cor'] = change_acc[0].toString();
                        pre_map['1~2 cor'] = change_acc[1].toString();
                        pre_map['2~3 cor'] = change_acc[2].toString();
                        pre_map['3~4 cor'] = change_acc[3].toString();
                        pre_map['4~5 cor'] = change_acc[4].toString();
                        initializeDateFormatting('ja_JP');
                        var now = DateTime.now();
                        if(index.exists){
                          await FirebaseFirestore.instance.collection('user').doc(email3).update({now.toString().split(".")[0]: pre_map});
                        }else{
                          await FirebaseFirestore.instance.collection('user').doc(email3).set({now.toString().split(".")[0]: pre_map});
                        }
                        int count = 0;
                        Navigator.popUntil(context, (_) => count++ >= 2);
                      },
                    ),
                  ],
                );
              },
            );
          }else{
            time++;
            if(time % 60 == 0){
              change_score.add((num1-num2).toString());
              num2 = num1;
              change_acc.add((_accurate - past_acc).toString());
              past_acc = _accurate;
            }
          }
        },
      );
    });
    controller1.stream.listen((event) => _incrementCounter(event));
    controller2.stream.listen((event) => _UpdateText(event));
    super.initState();
  }

  void _UpdateText(String letter){
    setState(() {
      if(letter != ' '){
        if(int.parse(lis[2]) + int.parse(lis[3]) == int.parse(letter) || int.parse(lis[2]) + int.parse(lis[3]) == int.parse(letter) + 10){
          _accurate++;
        }
        ans[0] = ans[1];
        ans[1] = letter;
        num1++;
      }
    });
  }
/////////////
  Widget Keyboard(){
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Expanded(
      flex: 6,
      child: Center(
          child: Container(
            color: const Color(0xff87cefa),
            height: (deviceHeight - appBarHeight)*0.6,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              childAspectRatio: (deviceWidth/3)/((deviceHeight - appBarHeight)*0.15),
              children: [
                '7', '8', '9',
                '4', '5', '6',
                '1', '2', '3',
                ' ', '0', ' ',
              ].map((key) {
                return GridTile(
                  child: Button(key),
                );
              }).toList(),
            ),
          )
      ),
    );
  }

  Widget Button(String _key){
    return Container(
        child: TextButton(
          child: Center(
            child: Text(
              _key,
              style: const TextStyle(
                fontSize: 46.0,
                color: Colors.black54,
              ),
            ),
          ),
          onPressed: (){
            if(time <= max){
              _MyHomePageState.controller2.sink.add(_key);
              _MyHomePageState.controller1.sink.add(_key);
            }else{
              null;
            }
          },
        )
    );
  }
}