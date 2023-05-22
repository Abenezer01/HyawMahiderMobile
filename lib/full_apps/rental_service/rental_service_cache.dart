import 'package:hyaw_mahider/full_apps/rental_service/models/car.dart';

class RentalServiceCache {
  static List<Car> cars = [];

  static Future<void> initDummy() async {
    RentalServiceCache.cars = await Car.getDummyList();
  }
}
