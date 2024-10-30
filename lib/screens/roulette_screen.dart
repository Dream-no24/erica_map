import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class RouletteScreen extends StatefulWidget {
  @override
  _RouletteScreenState createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen>
    with SingleTickerProviderStateMixin {
  final List<String> foodItems = [
    '김치찌개',
    '돈까스',
    '피자',
    '파스타',
    '부대찌개',
    '감자탕',
    '뼈해장국',
    '덮밥',
    '닭갈비',
    '고기',
    '냉면',
    '샤브샤브',
    '부리또',
    '햄버거',
    '카레',
    '칼국수',
    '샐러드',
    '샌드위치',
    '치킨',
    '라멘',
    '초밥',
    '국밥',
    '족발',
    '보쌈',
    '떡볶이',
    '마라탕',
    '짜장면',
    '짬뽕',
    '육회비빔밥',
    '곱창',
    '쌀국수',
    '만둣국',
    '두루치기',
    '마라샹궈',
    '필라프',
    '일본식덮밥',
    '해장국',
    '국수',
    '도시락',
    '쌈밥',
    '김밥',
    '볶음밥',
    '회',
  ];

  String selectedFood = '';
  String recommendedStore = '';
  bool isRolling = false;

  void _rollSlotMachine() async {
    setState(() {
      isRolling = true;
      recommendedStore = '';
    });

    // 슬롯 머신 효과를 위해 타이머를 사용하여 일정 시간 동안 빠르게 아이템을 변경
    final random = Random();
    int rollCount = 20; // 슬롯 머신이 돌아가는 횟수
    int interval = 100; // 슬롯 머신이 변경되는 간격 (ms)
    for (int i = 0; i < rollCount; i++) {
      await Future.delayed(Duration(milliseconds: interval), () {
        setState(() {
          selectedFood = foodItems[random.nextInt(foodItems.length)];
        });
      });
    }

    setState(() {
      isRolling = false;
    });

    await _getRecommendedStore(selectedFood);
  }

  Future<void> _getRecommendedStore(String foodItem) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('food_recomend')
        .where('item', isEqualTo: foodItem)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var stores = snapshot.docs.first.data()['store'] as List<dynamic>;
      final random = Random();
      setState(() {
        recommendedStore = stores.isNotEmpty ? stores[random.nextInt(stores.length)] : '추천 가게 없음';
      });
    } else {
      setState(() {
        recommendedStore = '추천 가게 없음';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴 룰렛', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0), // 위로 올리기 위해 패딩 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 시작점으로 정렬
            children: <Widget>[
              Align(
                alignment: Alignment(-0.7, -0.2),
                child: Text(
                  '나는 오늘',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade100, width: 5),
                ),
                child: Text(
                  selectedFood,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade100,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.7, 0.2),
                child: Text(
                  '이(가) 땡긴다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: isRolling ? null : _rollSlotMachine,
                child: Text('룰렛 돌리기'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade100,
                ),
              ),
              SizedBox(height: 20),
              if (recommendedStore.isNotEmpty)
                Text(
                  '추천 맛집: $recommendedStore',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
