import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AffiliatesScreen extends StatefulWidget {
  @override
  _AffiliatesScreenState createState() => _AffiliatesScreenState();
}

class _AffiliatesScreenState extends State<AffiliatesScreen> {
  String searchQuery = '';
  String selectedDepartment = '전체';

  final List<String> departments = [
    '전체', '공대', '과기대', '경상대', '소융대', '국문대', '디대', '약대', '언정대', '예대'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '제휴 안내',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: '제휴 가게 검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade100, width: 2.5), // 테두리 색상 설정
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade100, width: 2.5), // 비활성 상태 테두리 색상 설정
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade100, width: 2.5), // 포커스 상태 테두리 색상 설정
                ),
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 10), // 높이 줄이기
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: departments.map((department) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDepartment = department;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: selectedDepartment == department ? Colors.black : Colors.grey,
                      ),
                      child: Text(
                          department,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: selectedDepartment == department ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('affiData').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var affiliates = snapshot.data!.docs;
                  var filteredAffiliates = affiliates.where((affiliate) {
                    var name = affiliate['name'] ?? '';
                    var departmentAffiliates = affiliate['affiliates'] as List<dynamic>;
                    var matchesSearchQuery = name.contains(searchQuery);
                    var matchesDepartment = selectedDepartment == '전체' || departmentAffiliates.any((aff) {
                      return aff['department'] == selectedDepartment;
                    });

                    return matchesSearchQuery && matchesDepartment;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredAffiliates.length,
                    itemBuilder: (context, index) {
                      var affiliate = filteredAffiliates[index];
                      var name = affiliate['name'];
                      var departmentAffiliates = affiliate['affiliates'] as List<dynamic>;

                      // 제휴가 없는 가게는 표시하지 않음
                      var hasValidAffiliates = departmentAffiliates.any((aff) {
                        return aff['department'] != null && aff['department'].isNotEmpty;
                      });

                      if (!hasValidAffiliates) {
                        return Container(); // 빈 Container로 처리하여 표시되지 않게 함
                      }

                      return Column(
                        children: [
                          Card(
                            color: Colors.white,  // 카드의 색상 변경
                            elevation: 0,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  ...departmentAffiliates.map((aff) {
                                    return aff['department'] != null && aff['department'] != "" ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          aff['department'],
                                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          aff['contents'],
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ) : Container();
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey), // 카드 사이에 회색 선 추가
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
