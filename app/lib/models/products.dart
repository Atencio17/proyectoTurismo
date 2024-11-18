class Product {
  final int idProducto;
  final String nombre;
  final String detalle;
  final String imagen;
  final String categoria;
  final String tipo;
  final double precio;

  Product({
    required this.idProducto,
    required this.nombre,
    required this.detalle,
    required this.imagen,
    required this.categoria,
    required this.tipo,
    required this.precio,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProducto: json['idProducto'],
      nombre: json['nombre'],
      detalle: json['detalle'],
      imagen: json['imagen'],
      categoria: json['categoria'],
      tipo: json['tipo'],
      // Asegúrate de convertir el valor de precio a double
      precio: (json['precio'] is int) ? (json['precio'] as int).toDouble() : json['precio'],
    );
  }
}
