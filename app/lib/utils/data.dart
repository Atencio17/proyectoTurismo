class AppData {
  static final List<Map<String, dynamic>> favorites = [];
  static final List<Map<String, dynamic>> myList = [];
  static final List<Map<String, dynamic>> cart = [];

  static void addToFavorites(Map<String, dynamic> item) {
    favorites.add(item);
    print('Added to Favorites: ${item['title']}');
  }

  static void addToMyList(Map<String, dynamic> item) {
    myList.add(item);
    print('Added to My List: ${item['title']}');
  }

  static void addToCart(Map<String, dynamic> item) {
    cart.add(item);
    print('Added to Cart: ${item['title']}');
  }

  static void removeFromFavorites(Map<String, dynamic> item) {
    favorites.remove(item);
  }

  static void removeFromCart(Map<String, dynamic> item) {
    cart.remove(item);
  }

  static void removeFromMyList(Map<String, dynamic> item) {
    myList.remove(item);
  }
}
