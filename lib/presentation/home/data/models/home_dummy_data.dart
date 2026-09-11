class CityFilterModel {
  final String cityName;
  final double distanceKm;

  const CityFilterModel({required this.cityName, required this.distanceKm});
}

const List<CityFilterModel> dummyCities = [
  CityFilterModel(cityName: 'New York', distanceKm: 0.0),
  CityFilterModel(cityName: 'Los Angeles', distanceKm: 10.0),
  CityFilterModel(cityName: 'Chicago', distanceKm: 15.0),
  CityFilterModel(cityName: 'London', distanceKm: 25.0),
];
