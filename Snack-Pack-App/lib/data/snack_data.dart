import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shop link data model
class ShopLink {
  final String name;
  final String url;
  final IconData icon;
  final Color color;

  const ShopLink({
    required this.name,
    required this.url,
    required this.icon,
    required this.color,
  });
}

/// Size variant data model
class SizeVariant {
  final String size;
  final String description;
  final String price;

  const SizeVariant({
    required this.size,
    required this.description,
    required this.price,
  });
}

/// Flavor variant data model
class FlavorVariant {
  final String name;
  final String flavor;
  final Color accentColor;

  const FlavorVariant({
    required this.name,
    required this.flavor,
    required this.accentColor,
  });
}

/// Nutrition fact data model
class NutritionFact {
  final String label;
  final String value;
  final String? dailyValue;

  const NutritionFact({
    required this.label,
    required this.value,
    this.dailyValue,
  });
}

/// Snack class data model with comprehensive product details
class SnackClass {
  final String name;
  final String description;
  final String imagePath;
  final String category;
  final Color categoryColor;
  final Color cardTint;

  // Extended fields for details page
  final String detailedDescription;
  final String manufacturer;
  final String countryOfOrigin;
  final List<String> ingredients;
  final List<NutritionFact> nutritionFacts;
  final List<SizeVariant> sizes;
  final String priceRange;
  final List<ShopLink> shopLinks;
  final List<FlavorVariant> otherFlavors;

  const SnackClass({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.category,
    required this.categoryColor,
    required this.cardTint,
    required this.detailedDescription,
    required this.manufacturer,
    required this.countryOfOrigin,
    required this.ingredients,
    required this.nutritionFacts,
    required this.sizes,
    required this.priceRange,
    required this.shopLinks,
    required this.otherFlavors,
  });
}

/// All 10 snack classes available for classification
class SnackData {
  static const List<SnackClass> snackClasses = [
    // 1. Piattos Cheese
    SnackClass(
      name: 'Piattos Cheese',
      description: 'Crunchy potato chips with rich cheesy flavor.',
      imagePath: 'assets/img/Piattos_Cheese.png',
      category: 'CHEESE',
      categoryColor: AppColors.tagCheese,
      cardTint: AppColors.categoryCheese,
      detailedDescription:
          'Piattos Cheese is a premium snack featuring thin, crispy potato chips seasoned with a rich and creamy cheese flavor. Made from carefully selected potatoes, these chips deliver an irresistible crunch with every bite. The distinctive cheese seasoning provides a savory, indulgent taste that has made Piattos a favorite among Filipino snack lovers since its introduction.',
      manufacturer: 'Jack \'n Jill (Universal Robina Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Potato',
        'Vegetable Oil (Palm Oil)',
        'Cheese Seasoning',
        'Maltodextrin',
        'Salt',
        'Sugar',
        'Cheese Powder',
        'Whey Powder',
        'Natural and Artificial Flavors',
        'Monosodium Glutamate',
        'Citric Acid',
        'Lactic Acid',
        'Silicon Dioxide',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '28g (about 15 chips)'),
        NutritionFact(label: 'Calories', value: '150 kcal'),
        NutritionFact(label: 'Total Fat', value: '9g', dailyValue: '12%'),
        NutritionFact(label: 'Saturated Fat', value: '4g', dailyValue: '20%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '180mg', dailyValue: '8%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '15g', dailyValue: '5%'),
        NutritionFact(label: 'Protein', value: '2g'),
      ],
      sizes: [
        SizeVariant(
            size: '40g', description: 'Single-serving pack', price: '₱18'),
        SizeVariant(
            size: '85g', description: 'Buddy pack for sharing', price: '₱35'),
        SizeVariant(size: '170g', description: 'Family size', price: '₱65'),
      ],
      priceRange: '₱18 - ₱65',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=piattos+cheese',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url: 'https://www.lazada.com.ph/catalog/?q=piattos+cheese',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=piattos+cheese',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Roast Beef',
            flavor: 'Roast Beef flavored potato crisps',
            accentColor: Color(0xFF8B4513)),
        FlavorVariant(
            name: 'Sour Cream & Onion',
            flavor: 'Sour Cream & Onion flavored potato crisps',
            accentColor: Color(0xFF90EE90)),
        FlavorVariant(
            name: 'Nacho Pizza',
            flavor: 'Nacho Pizza flavored potato crisps',
            accentColor: Color(0xFFFF6347)),
        FlavorVariant(
            name: 'Roadhouse Barbecue',
            flavor: 'Roadhouse BBQ flavored potato crisps',
            accentColor: Color(0xFFD84315)),
      ],
    ),

    // 2. Nova Country Cheddar
    SnackClass(
      name: 'Nova Country Cheddar',
      description: 'Baked chips inspired by classic cheddar taste.',
      imagePath: 'assets/img/Nova_Country_Cheddar.png',
      category: 'CHEDDAR',
      categoryColor: AppColors.tagCheddar,
      cardTint: AppColors.categoryCheddar,
      detailedDescription:
          'Nova Country Cheddar features uniquely shaped multigrain snacks with a distinctive wavy texture. These baked chips are crafted with a blend of corn, wheat, and rice, providing a lighter crunch compared to traditional fried snacks. The Country Cheddar seasoning delivers a bold, tangy cheese flavor that appeals to snack enthusiasts looking for a more wholesome option.',
      manufacturer: 'Jack \'n Jill (Universal Robina Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Corn Grits',
        'Wheat Flour',
        'Rice Flour',
        'Vegetable Oil',
        'Cheddar Cheese Seasoning',
        'Salt',
        'Sugar',
        'Cheese Powder',
        'Maltodextrin',
        'Natural Flavors',
        'Onion Powder',
        'Garlic Powder',
        'Paprika Extract',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '28g (about 13 chips)'),
        NutritionFact(label: 'Calories', value: '130 kcal'),
        NutritionFact(label: 'Total Fat', value: '5g', dailyValue: '6%'),
        NutritionFact(label: 'Saturated Fat', value: '1g', dailyValue: '5%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '220mg', dailyValue: '10%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '19g', dailyValue: '7%'),
        NutritionFact(label: 'Protein', value: '2g'),
      ],
      sizes: [
        SizeVariant(
            size: '40g', description: 'Single-serving pack', price: '₱17'),
        SizeVariant(
            size: '78g', description: 'Buddy pack for sharing', price: '₱32'),
        SizeVariant(size: '150g', description: 'Family size', price: '₱58'),
      ],
      priceRange: '₱17 - ₱58',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=nova+country+cheddar',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url: 'https://www.lazada.com.ph/catalog/?q=nova+country+cheddar',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=nova+country+cheddar',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Summer Salad',
            flavor: 'Summer Salad flavor',
            accentColor: Color(0xFF32CD32)),
        FlavorVariant(
            name: 'Jalapeño Spice',
            flavor: 'Jalapeño Spice flavor',
            accentColor: Color(0xFF228B22)),
        FlavorVariant(
            name: 'Homestyle BBQ',
            flavor: 'Homestyle BBQ flavor',
            accentColor: Color(0xFFCD853F)),
      ],
    ),

    // 3. V-Cut Barbecue
    SnackClass(
      name: 'V-Cut Barbecue',
      description: 'Ridged potato chips with smoky barbecue flavor.',
      imagePath: 'assets/img/V-Cut_Barbecue.png',
      category: 'BBQ',
      categoryColor: AppColors.tagBbq,
      cardTint: AppColors.categoryBbq,
      detailedDescription:
          'V-Cut Barbecue features distinctive V-shaped ridged potato chips that deliver an extra crunchy texture. The deep ridges not only provide a satisfying crunch but also hold more of the smoky, sweet barbecue seasoning. This iconic snack has been a staple in Filipino households, perfect for any occasion from casual snacking to parties.',
      manufacturer: 'Jack \'n Jill (Universal Robina Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Potato',
        'Vegetable Oil (Palm Oil)',
        'BBQ Seasoning',
        'Sugar',
        'Salt',
        'Maltodextrin',
        'Onion Powder',
        'Garlic Powder',
        'Tomato Powder',
        'Paprika',
        'Spices',
        'Natural Smoke Flavor',
        'Caramel Color',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '28g (about 12 chips)'),
        NutritionFact(label: 'Calories', value: '150 kcal'),
        NutritionFact(label: 'Total Fat', value: '9g', dailyValue: '12%'),
        NutritionFact(label: 'Saturated Fat', value: '4g', dailyValue: '20%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '200mg', dailyValue: '9%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '16g', dailyValue: '6%'),
        NutritionFact(label: 'Protein', value: '2g'),
      ],
      sizes: [
        SizeVariant(size: '25g', description: 'Snack pack', price: '₱12'),
        SizeVariant(size: '60g', description: 'Regular pack', price: '₱28'),
        SizeVariant(size: '155g', description: 'Party size', price: '₱62'),
      ],
      priceRange: '₱12 - ₱62',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=v-cut+barbecue',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url: 'https://www.lazada.com.ph/catalog/?q=v-cut+barbecue',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=v-cut+barbecue',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Cheese',
            flavor: 'Cheese flavor',
            accentColor: Color(0xFFFFA500)),
        FlavorVariant(
            name: 'Onion & Garlic',
            flavor: 'Onion & Garlic flavor',
            accentColor: Color(0xFFDEB887)),
      ],
    ),

    // 4. Chippy Chili & Cheese
    SnackClass(
      name: 'Chippy Chili & Cheese',
      description: 'Spicy chili combined with creamy cheese seasoning.',
      imagePath: 'assets/img/Chippy_Chili&Cheese.png',
      category: 'SPICY',
      categoryColor: AppColors.tagSpicy,
      cardTint: AppColors.categorySpicy,
      detailedDescription:
          'Chippy Chili & Cheese is a beloved Filipino corn chip snack that combines the heat of chili peppers with the creamy richness of cheese. These crispy corn-based chips have a distinctive curved shape and satisfying crunch. The bold flavor combination has made Chippy a household name in the Philippines, perfect for those who enjoy a little kick with their snacks.',
      manufacturer: 'Jack \'n Jill (Universal Robina Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Corn Grits',
        'Vegetable Oil',
        'Chili & Cheese Seasoning',
        'Salt',
        'Sugar',
        'Cheese Powder',
        'Chili Powder',
        'Maltodextrin',
        'Monosodium Glutamate',
        'Garlic Powder',
        'Onion Powder',
        'Paprika Extract',
        'Natural and Artificial Flavors',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '27g'),
        NutritionFact(label: 'Calories', value: '140 kcal'),
        NutritionFact(label: 'Total Fat', value: '7g', dailyValue: '9%'),
        NutritionFact(label: 'Saturated Fat', value: '3g', dailyValue: '15%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '240mg', dailyValue: '10%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '18g', dailyValue: '7%'),
        NutritionFact(label: 'Protein', value: '2g'),
      ],
      sizes: [
        SizeVariant(size: '27g', description: 'Solo pack', price: '₱10'),
        SizeVariant(size: '110g', description: 'Sharing size', price: '₱42'),
        SizeVariant(size: '200g', description: 'Family size', price: '₱75'),
      ],
      priceRange: '₱10 - ₱75',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=chippy+chili+cheese',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url: 'https://www.lazada.com.ph/catalog/?q=chippy+chili+cheese',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=chippy+chili+cheese',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Barbecue',
            flavor: 'Barbecue flavor',
            accentColor: Color(0xFFD84315)),
        FlavorVariant(
            name: 'Beef & Chili',
            flavor: 'Beef & Chili flavor',
            accentColor: Color(0xFF8B0000)),
        FlavorVariant(
            name: 'Garlic & Vinegar',
            flavor: 'Garlic & Vinegar flavor',
            accentColor: Color(0xFF9ACD32)),
      ],
    ),

    // 5. Mr. Chips Corn & Cheese
    SnackClass(
      name: 'Mr. Chips Corn & Cheese',
      description: 'Corn chips with savory cheese seasoning.',
      imagePath: 'assets/img/Mr._Chips_Corn&Cheese.png',
      category: 'CHEESE',
      categoryColor: AppColors.tagCheese,
      cardTint: AppColors.categoryCheese,
      detailedDescription:
          'Mr. Chips Corn & Cheese delivers the classic combination of crunchy corn chips with rich cheese flavoring. These triangular-shaped chips are made from quality corn and seasoned with a blend of cheese and savory spices. The snack offers a satisfying crunch and cheesy taste that has made it a popular choice among Filipinos of all ages.',
      manufacturer: 'Jack \'n Jill (Universal Robina Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Corn',
        'Vegetable Oil',
        'Corn & Cheese Seasoning',
        'Salt',
        'Cheese Powder',
        'Maltodextrin',
        'Whey Powder',
        'Sugar',
        'Monosodium Glutamate',
        'Onion Powder',
        'Natural Flavors',
        'Yellow 5',
        'Yellow 6',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '28g'),
        NutritionFact(label: 'Calories', value: '140 kcal'),
        NutritionFact(label: 'Total Fat', value: '7g', dailyValue: '9%'),
        NutritionFact(label: 'Saturated Fat', value: '3g', dailyValue: '15%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '190mg', dailyValue: '8%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '18g', dailyValue: '7%'),
        NutritionFact(label: 'Protein', value: '2g'),
      ],
      sizes: [
        SizeVariant(size: '25g', description: 'Tipid pack', price: '₱8'),
        SizeVariant(size: '100g', description: 'Regular pack', price: '₱38'),
        SizeVariant(size: '175g', description: 'Party pack', price: '₱65'),
      ],
      priceRange: '₱8 - ₱65',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=mr+chips+corn+cheese',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url: 'https://www.lazada.com.ph/catalog/?q=mr+chips+corn+cheese',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=mr+chips+corn+cheese',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Nacho Cheese',
            flavor: 'Nacho Cheese flavor',
            accentColor: Color(0xFFFF8C00)),
        FlavorVariant(
            name: 'Pinoy Spaghetti',
            flavor: 'Pinoy Spaghetti flavor',
            accentColor: Color(0xFFFF4500)),
      ],
    ),

    // 6. Oishi Spicy Seafood Curls
    SnackClass(
      name: 'Oishi Spicy Seafood Curls',
      description: 'Curly snacks with spicy seafood flavor.',
      imagePath: 'assets/img/Oishi_Spicy_Seafood_Curls.png',
      category: 'SEAFOOD',
      categoryColor: AppColors.tagSeafood,
      cardTint: AppColors.categorySeafood,
      detailedDescription:
          'Oishi Spicy Seafood Curls are irresistibly crunchy curly snacks infused with the bold flavors of the sea and a hint of spice. These unique curl-shaped snacks deliver a satisfying crunch with every bite, complemented by authentic seafood taste and just the right amount of heat. Perfect for seafood lovers who enjoy a little kick in their snacks.',
      manufacturer: 'Oishi (Liwayway Marketing Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Tapioca Starch',
        'Wheat Flour',
        'Vegetable Oil',
        'Seafood Seasoning',
        'Shrimp Powder',
        'Salt',
        'Sugar',
        'Chili Powder',
        'Monosodium Glutamate',
        'Garlic Powder',
        'Onion Powder',
        'Citric Acid',
        'Natural and Artificial Flavors',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '25g'),
        NutritionFact(label: 'Calories', value: '120 kcal'),
        NutritionFact(label: 'Total Fat', value: '5g', dailyValue: '6%'),
        NutritionFact(label: 'Saturated Fat', value: '2g', dailyValue: '10%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '280mg', dailyValue: '12%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '17g', dailyValue: '6%'),
        NutritionFact(label: 'Protein', value: '1g'),
      ],
      sizes: [
        SizeVariant(size: '24g', description: 'Handy pack', price: '₱12'),
        SizeVariant(size: '60g', description: 'Regular size', price: '₱28'),
        SizeVariant(size: '95g', description: 'Big size', price: '₱45'),
      ],
      priceRange: '₱12 - ₱45',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=oishi+spicy+seafood+curls',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url:
                'https://www.lazada.com.ph/catalog/?q=oishi+spicy+seafood+curls',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=oishi+spicy+seafood+curls',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Prawn Crackers Spicy',
            flavor: 'Spicy Prawn Crackers',
            accentColor: Color(0xFFFF6B6B)),
        FlavorVariant(
            name: 'Shrimp Original',
            flavor: 'Original Shrimp Crackers',
            accentColor: Color(0xFFFA8072)),
      ],
    ),

    // 7. Oishi Onion Rings
    SnackClass(
      name: 'Oishi Onion Rings',
      description: 'Crispy rings with savory onion flavor.',
      imagePath: 'assets/img/Oishi_Onion_Rings.png',
      category: 'CLASSIC',
      categoryColor: AppColors.tagClassic,
      cardTint: AppColors.categoryClassic,
      detailedDescription:
          'Oishi Onion Rings are perfectly shaped ring snacks that deliver an authentic onion flavor in every crunchy bite. Made with real onion powder and a blend of savory seasonings, these classic snacks offer a lighter, airier texture compared to traditional chips. The distinctive ring shape makes them fun to eat and perfect for sharing.',
      manufacturer: 'Oishi (Liwayway Marketing Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Wheat Flour',
        'Corn Starch',
        'Vegetable Oil',
        'Onion Seasoning',
        'Onion Powder',
        'Salt',
        'Sugar',
        'Maltodextrin',
        'Monosodium Glutamate',
        'Garlic Powder',
        'Natural Flavors',
        'Caramel Color',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '25g'),
        NutritionFact(label: 'Calories', value: '130 kcal'),
        NutritionFact(label: 'Total Fat', value: '6g', dailyValue: '8%'),
        NutritionFact(label: 'Saturated Fat', value: '2.5g', dailyValue: '12%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '200mg', dailyValue: '9%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '17g', dailyValue: '6%'),
        NutritionFact(label: 'Protein', value: '2g'),
      ],
      sizes: [
        SizeVariant(size: '23g', description: 'Snack size', price: '₱10'),
        SizeVariant(size: '65g', description: 'Regular pack', price: '₱30'),
        SizeVariant(size: '90g', description: 'Big pack', price: '₱42'),
      ],
      priceRange: '₱10 - ₱42',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=oishi+onion+rings',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url: 'https://www.lazada.com.ph/catalog/?q=oishi+onion+rings',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=oishi+onion+rings',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Potato Fries Ketchup',
            flavor: 'Tomato Ketchup flavor',
            accentColor: Color(0xFFDC143C)),
        FlavorVariant(
            name: 'Potato Fries Cheese',
            flavor: 'Cheese flavor',
            accentColor: Color(0xFFFFD700)),
      ],
    ),

    // 8. Oishi Fish Crackers
    SnackClass(
      name: 'Oishi Fish Crackers',
      description: 'Light and crispy fish-flavored crackers.',
      imagePath: 'assets/img/Oishi_Fish_Crackers.png',
      category: 'SEAFOOD',
      categoryColor: AppColors.tagSeafood,
      cardTint: AppColors.categorySeafood,
      detailedDescription:
          'Oishi Fish Crackers are delightfully crispy snacks with an authentic fish flavor that seafood lovers adore. These light and airy crackers are made with real fish powder and carefully selected ingredients to deliver a savory, umami-rich taste. The distinctive fish shape makes them appealing to both kids and adults alike.',
      manufacturer: 'Oishi (Liwayway Marketing Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Tapioca Starch',
        'Wheat Flour',
        'Fish Powder',
        'Vegetable Oil',
        'Salt',
        'Sugar',
        'Fish Sauce Powder',
        'Monosodium Glutamate',
        'Garlic Powder',
        'Onion Powder',
        'Natural Flavors',
        'Turmeric',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '25g'),
        NutritionFact(label: 'Calories', value: '115 kcal'),
        NutritionFact(label: 'Total Fat', value: '4g', dailyValue: '5%'),
        NutritionFact(label: 'Saturated Fat', value: '2g', dailyValue: '10%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '5mg', dailyValue: '2%'),
        NutritionFact(label: 'Sodium', value: '320mg', dailyValue: '14%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '18g', dailyValue: '7%'),
        NutritionFact(label: 'Protein', value: '2g'),
      ],
      sizes: [
        SizeVariant(size: '25g', description: 'Snack size', price: '₱12'),
        SizeVariant(size: '65g', description: 'Regular pack', price: '₱28'),
        SizeVariant(size: '100g', description: 'Value pack', price: '₱45'),
      ],
      priceRange: '₱12 - ₱45',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=oishi+fish+crackers',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url: 'https://www.lazada.com.ph/catalog/?q=oishi+fish+crackers',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=oishi+fish+crackers',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Prawn Crackers Spicy',
            flavor: 'Spicy Prawn Crackers',
            accentColor: Color(0xFFFF4500)),
        FlavorVariant(
            name: 'Seafood Original',
            flavor: 'Original Seafood blend',
            accentColor: Color(0xFF20B2AA)),
      ],
    ),

    // 9. Oishi Cracklings Salt & Vinegar
    SnackClass(
      name: 'Oishi Cracklings Salt & Vinegar',
      description: 'Crispy cracklings with tangy salt and vinegar.',
      imagePath: 'assets/img/Oishi_Cracklings_Salt&Vinegar.png',
      category: 'CLASSIC',
      categoryColor: AppColors.tagClassic,
      cardTint: AppColors.categoryClassic,
      detailedDescription:
          'Oishi Cracklings Salt & Vinegar features ultra-crispy puffed snacks with the perfect balance of tangy vinegar and savory salt. These light and airy cracklings deliver an intense flavor punch that tingles the taste buds. The addictive combination of crunch and tang makes this a favorite among those who enjoy bold, zesty flavors.',
      manufacturer: 'Oishi (Liwayway Marketing Corporation)',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Tapioca Starch',
        'Vegetable Oil',
        'Salt & Vinegar Seasoning',
        'Salt',
        'Maltodextrin',
        'Vinegar Powder',
        'Citric Acid',
        'Malic Acid',
        'Sugar',
        'Natural Flavors',
        'Silicon Dioxide',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '24g'),
        NutritionFact(label: 'Calories', value: '125 kcal'),
        NutritionFact(label: 'Total Fat', value: '6g', dailyValue: '8%'),
        NutritionFact(label: 'Saturated Fat', value: '2.5g', dailyValue: '12%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '350mg', dailyValue: '15%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '16g', dailyValue: '6%'),
        NutritionFact(label: 'Protein', value: '0g'),
      ],
      sizes: [
        SizeVariant(size: '24g', description: 'Snack pack', price: '₱12'),
        SizeVariant(size: '50g', description: 'Regular pack', price: '₱25'),
        SizeVariant(size: '90g', description: 'Big pack', price: '₱42'),
      ],
      priceRange: '₱12 - ₱42',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url:
                'https://shopee.ph/search?keyword=oishi+cracklings+salt+vinegar',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url:
                'https://www.lazada.com.ph/catalog/?q=oishi+cracklings+salt+vinegar',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url:
                'https://www.tiktok.com/search?q=oishi+cracklings+salt+vinegar',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Plain Salted',
            flavor: 'Plain salted potato snacks',
            accentColor: Color(0xFFDCDCDC)),
        FlavorVariant(
            name: 'Cheese',
            flavor: 'Cheese flavor potato snacks',
            accentColor: Color(0xFFFFD700)),
      ],
    ),

    // 10. Clover Chips Ham & Cheese
    SnackClass(
      name: 'Clover Chips Ham & Cheese',
      description: 'Potato chips with ham and cheese flavor.',
      imagePath: 'assets/img/Clover_Chips_Ham&Cheese.png',
      category: 'HAM & CHEESE',
      categoryColor: AppColors.tagHamCheese,
      cardTint: AppColors.categoryHamCheese,
      detailedDescription:
          'Clover Chips Ham & Cheese is a unique Filipino snack that combines the savory taste of ham with creamy cheese in every crispy bite. These clover-shaped chips have a distinctive texture and bold flavor profile that sets them apart from traditional potato chips. A nostalgic favorite for many Filipinos, it offers a hearty and satisfying snacking experience.',
      manufacturer: 'Leslie\'s Corporation',
      countryOfOrigin: 'Philippines',
      ingredients: [
        'Corn Grits',
        'Vegetable Oil',
        'Ham & Cheese Seasoning',
        'Salt',
        'Sugar',
        'Ham Flavor',
        'Cheese Powder',
        'Maltodextrin',
        'Monosodium Glutamate',
        'Onion Powder',
        'Garlic Powder',
        'Natural and Artificial Flavors',
        'Paprika Extract',
      ],
      nutritionFacts: [
        NutritionFact(label: 'Serving Size', value: '28g'),
        NutritionFact(label: 'Calories', value: '145 kcal'),
        NutritionFact(label: 'Total Fat', value: '8g', dailyValue: '10%'),
        NutritionFact(label: 'Saturated Fat', value: '3.5g', dailyValue: '17%'),
        NutritionFact(label: 'Trans Fat', value: '0g'),
        NutritionFact(label: 'Cholesterol', value: '0mg', dailyValue: '0%'),
        NutritionFact(label: 'Sodium', value: '260mg', dailyValue: '11%'),
        NutritionFact(
            label: 'Total Carbohydrates', value: '17g', dailyValue: '6%'),
        NutritionFact(label: 'Protein', value: '2g'),
      ],
      sizes: [
        SizeVariant(
            size: '40g',
            description: 'Small, single-serving pack',
            price: '₱15'),
        SizeVariant(
            size: '85g',
            description: 'Medium buddy pack, good for sharing',
            price: '₱32'),
        SizeVariant(size: '145g', description: 'Family size', price: '₱55'),
      ],
      priceRange: '₱15 - ₱55',
      shopLinks: [
        ShopLink(
            name: 'Shopee',
            url: 'https://shopee.ph/search?keyword=clover+chips+ham+cheese',
            icon: Icons.shopping_bag_outlined,
            color: Color(0xFFEE4D2D)),
        ShopLink(
            name: 'Lazada',
            url: 'https://www.lazada.com.ph/catalog/?q=clover+chips+ham+cheese',
            icon: Icons.local_mall_outlined,
            color: Color(0xFF0F146D)),
        ShopLink(
            name: 'TikTok Shop',
            url: 'https://www.tiktok.com/search?q=clover+chips+ham+cheese',
            icon: Icons.music_note_outlined,
            color: Color(0xFF000000)),
      ],
      otherFlavors: [
        FlavorVariant(
            name: 'Cheese',
            flavor: 'Cheese flavor',
            accentColor: Color(0xFFFFA500)),
        FlavorVariant(
            name: 'Barbecue',
            flavor: 'Barbecue flavor',
            accentColor: Color(0xFFD84315)),
      ],
    ),
  ];

  /// Get snack class by name (case-insensitive matching)
  static SnackClass? getByName(String name) {
    final normalizedName = name.toLowerCase().trim();
    for (final snack in snackClasses) {
      if (snack.name.toLowerCase() == normalizedName) {
        return snack;
      }
    }
    // Try partial matching
    for (final snack in snackClasses) {
      if (snack.name.toLowerCase().contains(normalizedName) ||
          normalizedName.contains(snack.name.toLowerCase())) {
        return snack;
      }
    }
    return null;
  }

  /// Get category color based on class name
  static Color getCategoryColor(String className) {
    final snack = getByName(className);
    return snack?.categoryColor ?? AppColors.primary;
  }
}
