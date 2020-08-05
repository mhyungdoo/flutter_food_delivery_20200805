import 'dart:ui';

import 'package:app_food_delivery/core/consts.dart';
import 'package:app_food_delivery/core/flutter_icons.dart';
import 'package:app_food_delivery/models/food_model.dart';
import 'package:app_food_delivery/pages/detail_page.dart';
import 'package:app_food_delivery/widgets/app_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FoodModel> foodList = FoodModel.list;
  PageController pageController = PageController(viewportFraction: .8);
  var paddingLeft = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 60),
              child: _buildRightSection(),
            ),
            Container(
              color: AppColors.greenColor,
              height: MediaQuery.of(context).size.height,
              width: 60,
              padding: EdgeInsets.only(top: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage("assets/profile.jpg"),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(FlutterIcons.menu),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Transform.rotate(
                angle: -math.pi / 2,
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _buildMenu("Vegetables", 0),
                        _buildMenu("Chicken", 1),
                        _buildMenu("Beef", 2),
                        _buildMenu("Thai", 3),
                      ],
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.only(left: paddingLeft),
                      width: 150,
                      height: 75,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipPath(
                              clipper: AppClipper(),
                              child: Container(
                                width: 150,           //이동 화살표 영역 크기
                                height: 60,
                                color: AppColors.greenColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Transform.rotate(
                              angle: math.pi / 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: Icon(
                                  FlutterIcons.arrow,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(String menu, int index) {      //좌측 메뉴
    return GestureDetector(
      onTap: () {
        setState(() {
          paddingLeft = index * 110.0;           //메뉴 클릭 시 화살표 이동 거리
        });
      },
      child: Container(
        width: 115,                              // 좌측 메뉴간 간격
        padding: EdgeInsets.only(top: 16),
        child: Center(
          child: Text(
            menu,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightSection() {       //메인 화면 우측 부분
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          _customAppBar(),
          Expanded(
            child: ListView(        //메인화면 우측 전체 ListView
              children: <Widget>[
                Container(        //메인화면 우측 상단의 좌우 스크롤되는 부분
                  height: 350,   //우측 상단 좌우 스크롤 화면의 높이
                  child: PageView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: foodList.length,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailPage(foodList[index]),    // 메뉴를 클릭하면 상세 화면으로 이동
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),   //메인화면 우측 상단 슬라이드 메뉴의 폭을 결정
                          child: Stack(
                            children: <Widget>[
                              _buildBackGround(index),
                              Align(
                                alignment: Alignment.topRight,
                                child: Transform.rotate(
                                  angle: math.pi / 3,
                                  child: Hero(           //애니메이션 효과 위젯, tag 속성 반드시 필요
                                    tag: "image${foodList[index].imgPath}",
                                    child: Image(
                                      width: 180,           // 음식 이미지 크기
                                      image: AssetImage(
                                          "assets/${foodList[index].imgPath}"),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(      // 메뉴 하단에 가격 표시
                                bottom: 0,
                                right: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.redColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    "\$${foodList[index].price.toInt()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    "Popular",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                _buildPopularList(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildBackGround(int index) {
    return Container(
      margin: EdgeInsets.only(
        top: 50,
        bottom: 20,
        right: 50,
      ),
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.greenColor,
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: SizedBox()),
          Row(
            children: <Widget>[
              RatingBar(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 12,
                unratedColor: Colors.black12,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.black,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              SizedBox(width: 10),
              Flexible(         // 텍스트가 영역을 벗어날 경우 플렉서블로 감쌈
                child: Text(
                  "(120 Reviews)",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "${foodList[index].name}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: foodList.length,
      padding: EdgeInsets.only(
        left: 40,
      //  right: 5,
        bottom: 16,
        top: 20,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Row(         // Row 위젯의 크기를 지정할 수는 없는가?
            children: <Widget>[
              Image(
                width: 100,
                image: AssetImage("assets/${foodList[index].imgPath}"),
              ),
              SizedBox(width: 16),
              Flexible(      //해당 컬럼 전체에 Flexible을 걸어주면 됨.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${foodList[index].name}",
                      overflow: TextOverflow.ellipsis, //글자수가 영역을 넘어갈 때
                     //   softWrap: true,  //글자수가 영역을 넘어갈 때 줄바꿈
                     // maxLines: 2,  // 글자 줄 수 지정
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          "\$${foodList[index].price.toInt()}",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.redColor,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                        SizedBox(width: 16),
                        Text(
                          "(${foodList[index].weight.toInt()}gm Weight)",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _customAppBar() {               //상단 앱바
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "Hello,\n",
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: "Shailee Weedly",
                  style: TextStyle(
                    color: AppColors.greenColor,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.greenLightColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                      ),
                    ),
                  ),
                  Icon(
                    FlutterIcons.search,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                FlutterIcons.shop,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
