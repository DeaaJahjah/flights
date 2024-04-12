import 'package:flights/main_pages/my_flights_list_page.dart';
import 'package:flights/utils/r.dart';
import 'package:flights/widgets/fade_in_out_widget/fade_in_out_widget.dart';
import 'package:flights/widgets/fade_in_out_widget/fade_in_out_widget_controller.dart';
import 'package:flights/widgets/fading_item_list/fading_item_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:snake_button/snake_button.dart';

import 'add_flight_page.dart';
import 'add_flight_page_controller.dart';

enum MainPageEnum { myFlights, addFlight }

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';

  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _sheetAnimationController;
  late final SnakeButtonController _snakeButtonController;
  late final FadingItemListController _fadingItemListController;
  late final AddFlightPageController _addFlightPageController;
  late final FadeInOutWidgetController _sheetContentFadeInOutController;
  late final FadeInOutWidgetController _headerFadeInOutController;
  late final ValueNotifier<MainPageEnum> _currentMainPage;
  late final Map<MainPageEnum, Widget> pages;
  late Animation routeTransitionValue;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _snakeButtonController = SnakeButtonController();
    _fadingItemListController = FadingItemListController();
    _sheetContentFadeInOutController = FadeInOutWidgetController();
    _headerFadeInOutController = FadeInOutWidgetController();
    _sheetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );

    routeTransitionValue = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    _sheetAnimationController.forward().whenComplete(
      () {
        _headerFadeInOutController.show();
        _fadingItemListController.showItems();
        _snakeButtonController.toggle();
      },
    );

    _currentMainPage = ValueNotifier(MainPageEnum.myFlights);
    _addFlightPageController = AddFlightPageController();

    pages = {
      MainPageEnum.myFlights: MyFlightsListPage(
        fadingItemListController: _fadingItemListController,
      ),
      MainPageEnum.addFlight: AddFlightPage(
        isSingleTabSelectionCompleted: (isCompleted) {
          isCompleted ? _snakeButtonController.show() : _snakeButtonController.hide(from: 0.3);
        },
        addFlightPageController: _addFlightPageController,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    // FlightDbService().addFlight(
    //     flight: Flight(
    //   userId: FirebaseAuth.instance.currentUser!.uid,
    //   userName: 'userName',
    //   flightNo: 'flightNo',
    //   airplaneNo: 'airplaneNo',
    //   from: 'syria',
    //   to: 'ua',
    //   lunchDate: DateTime(2017, 3, 3),
    //   arriveDate: DateTime(2019, 3, 3),
    //   businessClassCost: 200,
    //   normalClassCost: 100,
    //   numberOfNormalSeats: 10,
    //   numberOfVIPSeats: 5,
    //   seats: [
    //     Seat(id: 'id', isVip: true, name: 'c1', available: true),
    //     Seat(id: 'id2', isVip: false, name: 'b1', available: true),
    //   ],
    // ));
    return Scaffold(
      floatingActionButton: _buildFloatingButton(),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: _buildHeader,
            ),
            const SizedBox(
              height: 32.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeInOutWidget(
                initialVisibilityValue: false,
                slideDuration: const Duration(milliseconds: 500),
                fadeInOutWidgetController: _headerFadeInOutController,
                child: ValueListenableBuilder<MainPageEnum>(
                  valueListenable: _currentMainPage,
                  builder: (_, value, __) => _isMyFlightsPage ? _myFlightsTextWidget : _addFlightTextWidget,
                ),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            AnimatedBuilder(
              animation: _sheetAnimationController,
              builder: (context, child) => Container(
                height: (1 - _sheetAnimationController.value) * 600,
              ),
            ),
            Flexible(
              child: _buildBottomSheet,
            ),
          ],
        ),
      ),
    );
  }

  Text get _myFlightsTextWidget => Text(
        "رحلاتي السابقة",
        style: TextStyle(
          color: R.primaryColor,
          fontSize: 30.0,
          fontWeight: FontWeight.w600,
        ),
      );

  Text get _addFlightTextWidget => Text(
        "حجز رحلة",
        style: TextStyle(
          color: R.primaryColor,
          fontSize: 30.0,
          fontWeight: FontWeight.w600,
        ),
      );

  Widget get _buildHeader => AnimatedBuilder(
        animation: routeTransitionValue,
        builder: (context, child) => Opacity(
          opacity: 1.0 * routeTransitionValue.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.menu,
                color: R.primaryColor,
              ),
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: R.primaryColor,
                ),
                child: Icon(
                  Icons.person,
                  color: R.secondaryColor,
                  size: 40.0,
                ),
              )
            ],
          ),
        ),
      );

  Widget get _buildBottomSheet => Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: R.primaryColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        child: FadeInOutWidget(
          slideDuration: const Duration(milliseconds: 500),
          slideEndingOffset: const Offset(0, 0.04),
          fadeInOutWidgetController: _sheetContentFadeInOutController,
          child: ValueListenableBuilder<MainPageEnum>(
            valueListenable: _currentMainPage,
            builder: (_, value, __) => pages[value]!,
          ),
        ),
      );

  Widget _buildFloatingButton() {
    final elevatedButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: R.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () => _onMainButtonClick(),
      child: ValueListenableBuilder<MainPageEnum>(
        valueListenable: _currentMainPage,
        builder: (_, value, __) => Icon(
          value == MainPageEnum.myFlights ? Icons.add : Icons.arrow_forward_ios,
          color: R.primaryColor,
        ),
      ),
    );

    return SnakeButton(
      controller: _snakeButtonController,
      snakeAnimationDuration: const Duration(milliseconds: 500),
      snakeColor: R.secondaryColor,
      snakeWidth: 2.0,
      borderRadius: 20.0,
      child: SizedBox(
        height: 70,
        width: 70,
        child: elevatedButton,
      ),
    );
  }

  void _onMainButtonClick() {
    _snakeButtonController.hide(from: 0.3);
    if (_isMyFlightsPage) {
      _sheetContentFadeInOutController.hide();
      _headerFadeInOutController.hide();

      Future.delayed(const Duration(milliseconds: 500), () {
        _currentMainPage.value = MainPageEnum.addFlight;
      }).whenComplete(() {
        _sheetContentFadeInOutController.show();
        _headerFadeInOutController.show();
      });
    } else {
      _addFlightPageController.nextTab();
    }
  }

  bool get _isMyFlightsPage => _currentMainPage.value == MainPageEnum.myFlights;
}
