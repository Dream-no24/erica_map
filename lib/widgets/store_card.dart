import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreCard extends StatefulWidget {
  final QueryDocumentSnapshot shop;

  StoreCard({required this.shop});

  @override
  _StoreCardState createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  bool showMore = false;
  String selectedAffiliate = '';

  @override
  Widget build(BuildContext context) {
    var shopData = widget.shop.data() as Map<String, dynamic>;
    var menu = shopData['menu'] as List<dynamic>;

    return Column(
      children: [
        Card(
          color: Colors.white,  // 카드의 색상 변경
          elevation: 0,  // 카드의 음영 제거
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 가게 이름과 별점
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shopData['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (shopData.containsKey('rating')) // 별점이 있는 경우만 표시
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow,),
                          Text('${shopData['rating']}'),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 5.0),
                // 제휴 정보와 버튼
                FutureBuilder(
                  future: _fetchAffiliateInfo(shopData['name']),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    var affiliates = snapshot.data as List<dynamic>;
                    affiliates = affiliates.where((affiliate) => affiliate['department'].isNotEmpty && affiliate['contents'].isNotEmpty).toList();
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text('제휴정보 :'),
                          SizedBox(width: 1.0),  // 간격 조정
                          ...affiliates.map<Widget>((affiliate) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 0.1, left: 0.11,), // 버튼 간격 조정
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,  // 텍스트 색상
                                  backgroundColor: Colors.white,  // 버튼 배경색
                                ),
                                onPressed: () {
                                  _showAffiliateDialog(context, affiliate['department'], affiliate['contents']);
                                },
                                child: Text(affiliate['department']),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
                if (selectedAffiliate.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(selectedAffiliate),
                  ),
                SizedBox(height: 8.0),
                // 메뉴 항목과 가격
                ...menu.take(showMore ? menu.length : 5).map((menuItem) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('${menuItem['item']} ${menuItem['price']}'),
                    )),
                // 더보기 버튼
                if (menu.length > 5)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,  // 텍스트 색상
                      backgroundColor: Colors.white,  // 버튼 배경색
                    ),
                    onPressed: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                    child: Text(showMore ? '접기' : '더보기'),
                  ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey, thickness: 0.3), // 카드 구분을 위한 회색 줄 추가
      ],
    );
  }

  void _showAffiliateDialog(BuildContext context, String department, String contents) {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            title: Text(department, style: TextStyle(color: Colors.black)), // 텍스트 색상 변경
            content: Text(contents, style: TextStyle(color: Colors.black)), // 텍스트 색상 변경
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,  // 텍스트 색상
                  backgroundColor: Colors.white,  // 버튼 배경색
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('닫기'),
              ),
            ],
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
        );
      },
    );
  }

  Future<List<dynamic>> _fetchAffiliateInfo(String shopName) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('affiData')
        .where('name', isEqualTo: shopName)
        .get();
    return snapshot.docs.map((doc) => doc.data()['affiliates']).expand((i) => i).toList();
  }
}
