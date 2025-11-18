import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '50音表',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GojuonTable(),
    );
  }
}

class GojuonTable extends StatefulWidget {
  const GojuonTable({super.key});

  @override
  State<GojuonTable> createState() => _GojuonTableState();
}

class _GojuonTableState extends State<GojuonTable> {
  // 50音表のデータ（画像に基づいた配置）
  static const List<List<String>> hiraganaTable = [
    ['わ', 'ら', 'や', 'ま', 'は', 'な', 'た', 'さ', 'か', 'あ'],
    ['を', 'り', '', 'み', 'ひ', 'に', 'ち', 'し', 'き', 'い'],
    ['ん', 'る', 'ゆ', 'む', 'ふ', 'ぬ', 'つ', 'す', 'く', 'う'],
    ['。', 'れ', '', 'め', 'へ', 'ね', 'て', 'せ', 'け', 'え'],
    ['、', 'ろ', 'よ', 'も', 'ほ', 'の', 'と', 'そ', 'こ', 'お'],
  ];

  String selectedCharacters = '';

  // 濁音・半濁音マッピング
  final Map<String, List<String>> _dakutenMap = {
    // か行
    'か': ['か', 'が'],
    'き': ['き', 'ぎ', 'きゃ', 'きゅ', 'きょ', 'ぎゃ', 'ぎゅ', 'ぎょ'],
    'く': ['く', 'ぐ'],
    'け': ['け', 'げ'],
    'こ': ['こ', 'ご'],
    // さ行
    'さ': ['さ', 'ざ'],
    'し': ['し', 'じ', 'しゃ', 'しゅ', 'しょ', 'じゃ', 'じゅ', 'じょ'],
    'す': ['す', 'ず'],
    'せ': ['せ', 'ぜ'],
    'そ': ['そ', 'ぞ'],
    // た行
    'た': ['た', 'だ'],
    'ち': ['ち', 'ぢ', 'ちゃ', 'ちゅ', 'ちょ', 'ぢゃ', 'ぢゅ', 'ぢょ'],
    'つ': ['つ', 'づ', 'っ'],
    'て': ['て', 'で'],
    'と': ['と', 'ど'],
    // な行（拗音）
    'に': ['に', 'にゃ', 'にゅ', 'にょ'],
    // は行（濁音・半濁音）
    'は': ['は', 'ば', 'ぱ'],
    'ひ': ['ひ', 'び', 'ぴ', 'ひゃ', 'ひゅ', 'ひょ', 'びゃ', 'びゅ', 'びょ', 'ぴゃ', 'ぴゅ', 'ぴょ'],
    'ふ': ['ふ', 'ぶ', 'ふぃ', 'ふぇ'],
    'へ': ['へ', 'べ', 'ぺ'],
    'ほ': ['ほ', 'ぼ', 'ぽ'],
    // ま行（拗音）
    'み': ['み', 'みゃ', 'みゅ', 'みょ'],
    // ら行（拗音）
    'り': ['り', 'りゃ', 'りゅ', 'りょ'],
  };

  void _addCharacter(String character) {
    setState(() {
      selectedCharacters += character;
    });
  }

  void _onCharacterTapped(
    String character,
    BuildContext context,
    Offset tapPosition,
  ) {
    if (character.isEmpty) return;

    // 濁音・半濁音がある場合はポップアップメニューを表示
    if (_dakutenMap.containsKey(character)) {
      _showCharacterMenu(context, character, tapPosition);
    } else {
      // それ以外は直接追加
      _addCharacter(character);
    }
  }

  void _showCharacterMenu(
    BuildContext context,
    String character,
    Offset position,
  ) {
    final options = _dakutenMap[character]!;

    // 「ひ」の場合は3列レイアウトで表示
    if (character == 'ひ') {
      _showThreeColumnMenu(context, character, position);
    } else if (character == 'き' ||
        character == 'し' ||
        character == 'ち' ||
        character == 'ふ') {
      // 「き」「し」「ち」「ふ」の場合は2列レイアウトで表示
      _showTwoColumnMenu(context, character, position);
    } else {
      // それ以外は従来の1列メニュー
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;

      showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(position.dx, position.dy, 0, 0),
          Rect.fromLTWH(0, 0, overlay.size.width, overlay.size.height),
        ),
        items: options.map((option) {
          return PopupMenuItem<String>(
            value: option,
            child: Center(
              child: Text(
                option,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ).then((selected) {
        if (selected != null) {
          _addCharacter(selected);
        }
      });
    }
  }

  void _showTwoColumnMenu(
    BuildContext context,
    String character,
    Offset position,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    // 左列と右列の文字を決定
    List<String> leftColumn;
    List<String> rightColumn;

    if (character == 'き') {
      leftColumn = ['き', 'きゃ', 'きゅ', 'きょ'];
      rightColumn = ['ぎ', 'ぎゃ', 'ぎゅ', 'ぎょ'];
    } else if (character == 'し') {
      leftColumn = ['し', 'しゃ', 'しゅ', 'しょ', 'しぇ'];
      rightColumn = ['じ', 'じゃ', 'じゅ', 'じょ', 'じぇ'];
    } else if (character == 'ち') {
      leftColumn = ['ち', 'ちゃ', 'ちゅ', 'ちょ', 'ちぇ'];
      rightColumn = ['ぢ'];
    } else if (character == 'ふ') {
      leftColumn = ['ふ', 'ふぃ', 'ふぇ'];
      rightColumn = ['ぶ'];
    } else {
      return;
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 背景をタップして閉じる
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                overlayEntry?.remove();
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          // ポップアップメニュー
          Positioned(
            left: position.dx.clamp(0.0, screenSize.width - 200),
            top: position.dy.clamp(0.0, screenSize.height - 300),
            child: Material(
              color: Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 左列
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: leftColumn.map((char) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildMenuButton(char, () {
                            overlayEntry?.remove();
                            _addCharacter(char);
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 16),
                    // 右列
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 「ふ」と「ち」の場合は最初に空のスペースを追加して右列を左列と同じ高さにする
                        if (character == 'ふ' || character == 'ち')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SizedBox(
                              height: 56, // ボタンの高さ（padding 12*2 + フォントサイズ32）
                            ),
                          ),
                        ...rightColumn.map((char) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildMenuButton(char, () {
                              overlayEntry?.remove();
                              _addCharacter(char);
                            }),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(overlayEntry);
  }

  void _showThreeColumnMenu(
    BuildContext context,
    String character,
    Offset position,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    // 3列の文字を決定（ひの場合）
    List<String> leftColumn; // ひ・ひゃ・ひゅ・ひょ
    List<String> middleColumn; // び・びゃ・びゅ・びょ
    List<String> rightColumn; // ぴ・ぴゃ・ぴゅ・ぴょ

    if (character == 'ひ') {
      leftColumn = ['ひ', 'ひゃ', 'ひゅ', 'ひょ'];
      middleColumn = ['び', 'びゃ', 'びゅ', 'びょ'];
      rightColumn = ['ぴ', 'ぴゃ', 'ぴゅ', 'ぴょ'];
    } else {
      return;
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 背景をタップして閉じる
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                overlayEntry?.remove();
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          // ポップアップメニュー
          Positioned(
            left: position.dx.clamp(0.0, screenSize.width - 300),
            top: position.dy.clamp(0.0, screenSize.height - 300),
            child: Material(
              color: Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 左列
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: leftColumn.map((char) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildMenuButton(char, () {
                            overlayEntry?.remove();
                            _addCharacter(char);
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 16),
                    // 中央列
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: middleColumn.map((char) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildMenuButton(char, () {
                            overlayEntry?.remove();
                            _addCharacter(char);
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 16),
                    // 右列
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: rightColumn.map((char) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildMenuButton(char, () {
                            overlayEntry?.remove();
                            _addCharacter(char);
                          }),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(overlayEntry);
  }

  Widget _buildMenuButton(String text, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            text,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  void _deleteLastCharacter() {
    if (selectedCharacters.isNotEmpty) {
      setState(() {
        selectedCharacters = selectedCharacters.substring(
          0,
          selectedCharacters.length - 1,
        );
      });
    }
  }

  void _clearAllCharacters() {
    setState(() {
      selectedCharacters = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('50音表'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Table(
                      border: TableBorder.all(color: Colors.black, width: 1.0),
                      defaultColumnWidth: const FixedColumnWidth(90.0),
                      children: hiraganaTable.map((row) {
                        return TableRow(
                          children: row.map((character) {
                            if (character.isEmpty) {
                              return Container(
                                height: 90.0,
                                alignment: Alignment.center,
                                color: Colors.white,
                              );
                            }
                            return Builder(
                              builder: (cellContext) {
                                return Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    onTapDown: (details) {
                                      _onCharacterTapped(
                                        character,
                                        cellContext,
                                        details.globalPosition,
                                      );
                                    },
                                    splashColor: Colors.blue.withOpacity(0.3),
                                    highlightColor: Colors.blue.withOpacity(
                                      0.1,
                                    ),
                                    child: Container(
                                      height: 90.0,
                                      alignment: Alignment.center,
                                      child: Text(
                                        character,
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    // 50音表の幅に合わせる: 10列 × 90.0 + ボーダー11本 × 2.0 = 922.0
                    width: 922.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedCharacters,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: selectedCharacters.isNotEmpty
                          ? _deleteLastCharacter
                          : null,
                      child: const Text('1文字削除'),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: selectedCharacters.isNotEmpty
                          ? _clearAllCharacters
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('全削除'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
