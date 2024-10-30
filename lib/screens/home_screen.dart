import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/category_button.dart';
import '../widgets/store_card.dart';
import 'roulette_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // 뒤로 가기 버튼
        backgroundColor: Colors.blue.shade100,
        scrolledUnderElevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // 뒤로가기 버튼 기능
              Navigator.pop(context);
            }
        ),
        leadingWidth: 25,
        title: Text('가게', style: TextStyle(fontWeight: FontWeight.bold),),

        actions: [
          // 룰렛 서비스 아이콘
          IconButton(
            icon: Icon(Icons.casino),
            onPressed: () {
              // 룰렛 서비스 기능
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RouletteScreen()), // 룰렛 스크린으로 이동
              );
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.home),
          //   onPressed: () {
          //     // 홈 버튼 기능
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          // 카테고리 선택 바
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(1),
            child: Row(
              children: [
                CategoryButton(
                  label: '전체',
                  onTap: () {
                    setState(() {
                      selectedCategory = '전체';
                    });
                  },
                ),
                CategoryButton(
                  label: '한식',
                  onTap: () {
                    setState(() {
                      selectedCategory = '한식';
                    });
                  },
                ),
                CategoryButton(
                  label: '중식',
                  onTap: () {
                    setState(() {
                      selectedCategory = '중식';
                    });
                  },
                ),
                CategoryButton(
                  label: '일식',
                  onTap: () {
                    setState(() {
                      selectedCategory = '일식';
                    });
                  },
                ),
                CategoryButton(
                  label: '양식',
                  onTap: () {
                    setState(() {
                      selectedCategory = '양식';
                    });
                  },
                ),
                CategoryButton(
                  label: '아시안',
                  onTap: () {
                    setState(() {
                      selectedCategory = '아시안';
                    });
                  },
                ),
                CategoryButton(
                  label: '도시락',
                  onTap: () {
                    setState(() {
                      selectedCategory = '도시락';
                    });
                  },
                ),
                CategoryButton(
                  label: '피자',
                  onTap: () {
                    setState(() {
                      selectedCategory = '피자';
                    });
                  },
                ),
                CategoryButton(
                  label: '고기·구이',
                  onTap: () {
                    setState(() {
                      selectedCategory = '고기·구이';
                    });
                  },
                ),
                CategoryButton(
                  label: '치킨',
                  onTap: () {
                    setState(() {
                      selectedCategory = '치킨';
                    });
                  },
                ),
                CategoryButton(
                  label: '덮밥',
                  onTap: () {
                    setState(() {
                      selectedCategory = '덮밥';
                    });
                  },
                ),
                CategoryButton(
                  label: '분식',
                  onTap: () {
                    setState(() {
                      selectedCategory = '분식';
                    });
                  },
                ),
                CategoryButton(
                  label: '패스트푸드',
                  onTap: () {
                    setState(() {
                      selectedCategory = '패스트푸드';
                    });
                  },
                ),

                CategoryButton(
                  label: '샐러드·샌드위치',
                  onTap: () {
                    setState(() {
                      selectedCategory = '샐러드·샌드위치';
                    });
                  },
                ),
                CategoryButton(
                  label: '카페',
                  onTap: () {
                    setState(() {
                      selectedCategory = '카페';
                    });
                  },
                ),
                CategoryButton(
                  label: '주점',
                  onTap: () {
                    setState(() {
                      selectedCategory = '주점';
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(  // 구분선 추가
            color: Colors.grey,  // 구분선 색상
            thickness: 0.7,  // 구분선 두께
          ),
          // 가게 정보
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('storeData').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var shops = snapshot.data!.docs;
                var filteredShops = selectedCategory == '전체'
                    ? shops
                    : shops.where((shop) => shop['category'] == selectedCategory).toList();

                return ListView.builder(
                  itemCount: filteredShops.length,
                  itemBuilder: (context, index) {
                    var shop = filteredShops[index];
                    return StoreCard(
                      shop: shop,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
