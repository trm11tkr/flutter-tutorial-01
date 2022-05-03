import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  // WordPair型の配列を準備
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 16.0);

  void _pushSaved() {
    // Navigator.pushはNavigatorスタックにルートをプッシュする
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) {
            final tiles = _saved.map(
                (pair) {
                  return ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
            );
            final divided = tiles.isNotEmpty
                ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                  ).toList()
                : <Widget>[];
            return Scaffold(
              appBar: AppBar(
                title: const Text('Saved Sugggestions'),
              ),
              body: ListView(children: divided),
            );
          },
      ),
    );
  }

  @override
  // BuildContextはWidgetの場所を保持するもの。
  // これがないと、子の要素の場所も辿れなくなる。
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestion',
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }


  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          // WordPairは前後の2つの単語をくっつける
          // ['low', 'book', 'city', 'boy'];
          // 毎回(全てのiで)リストを作ると['LowBook', 'LowBook','CityBoy','CityBoy']
          // となるので奇数番目にDividerを呼び出している
          // indexは下記の式により、0,
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            // 10個WordPairを追加してくれる
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        },
        // itemCount: _suggestions.length,
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadeySaved = _saved.contains(pair); // 既に追加されていないかチェック
    return ListTile(
      title: Center(
        child: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
      ),
      trailing: Icon(
        // 三項演算子　? → if : → else
        alreadeySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadeySaved ? Colors.red : null,
        semanticLabel: alreadeySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {
        setState(() {
          if (alreadeySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}

