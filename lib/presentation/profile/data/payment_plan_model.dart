class PaymentPlanModel {
  final String id;
  final String name;
  final double price;
  final String displayPrice;
  final List<String> features;
  final bool isCurrentPlan;
  final bool isPopular;

  PaymentPlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.displayPrice,
    required this.features,
    this.isCurrentPlan = false,
    this.isPopular = false,
  });
}

// Dummy data
final dummyPaymentPlans = [
  PaymentPlanModel(
    id: '1',
    name: 'Free',
    price: 0.0,
    displayPrice: '\$0.00',
    isCurrentPlan: true,
    features: ['Upload 1 Highlight Video', 'Only Can View Rating'],
  ),
  PaymentPlanModel(
    id: '2',
    name: 'Premium Monthly',
    price: 10.0,
    displayPrice: '\$100.00',
    isPopular: false,
    features: ['Upload Multiple Highlight Videos', 'View Profile Analytics'],
  ),
  PaymentPlanModel(
    id: '3',
    name: 'Premium Yearly',
    price: 100.0,
    displayPrice: '\$100.00',
    isPopular: true,
    features: ['Upload Multiple Highlight Videos', 'View Profile Analytics'],
  ),
];
