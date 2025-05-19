class Product {
  final int idProductos;
  final String nombre;
  final String detalle;
  final String imagen;
  final int stock;
  final String categoria;
  final double precio;

  Product({
    required this.idProductos,
    required this.nombre,
    required this.detalle,
    required this.imagen,
    required this.stock,
    required this.categoria,
    required this.precio,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProductos: json['idProductos'],
      nombre: json['nombre'],
      detalle: json['detalle'],
      imagen: json['imagen'],
      categoria: json['categoria'],
      stock: json['stock'],
      // Asegúrate de convertir el valor de precio a double
      precio: (json['precio'] is int)
          ? (json['precio'] as int).toDouble()
          : json['precio'],
    );
  }
}
