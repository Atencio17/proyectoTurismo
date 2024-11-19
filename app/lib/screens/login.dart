import 'package:app/screens/home.dart';
import 'package:app/screens/registro.dart';
import 'package:app/utils/api.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final Color mintGreen = Color(0xFF3EB489);

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 200,
                  width: 200,
                ),
                // Campo ID de Usuario
                _buildTextFormField(
                  controller: _idController,
                  label: 'Número de documento',
                  keyboardType: TextInputType.number,
                ),

                // Campo Contraseña
                _buildTextFormField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),

                // Botón de login
                _isLoading
                    ? CircularProgressIndicator(color: mintGreen)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mintGreen,
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: _handleLogin,
                        child: Text('Iniciar Sesión'),
                      ),
                const SizedBox(height: 16.0),

                // Enlace para registro
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationForm(),
                      ),
                    );
                  },
                  child: Text(
                    '¿No tienes una cuenta? Regístrate',
                    style: TextStyle(color: mintGreen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final idUsuario = _idController.text.trim();
      final password = _passwordController.text.trim();

      setState(() {
        _isLoading = true;
      });

      try {
        final isValid =
            await ProductService().validateUser(idUsuario, password);

        if (isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Inicio de sesión exitoso'),
              backgroundColor: mintGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Redirigir a la pantalla principal
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          _showErrorSnackbar('Credenciales inválidas o usuario no encontrado');
        }
      } catch (e) {
        _showErrorSnackbar('Error al conectar con el servidor');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mintGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mintGreen, width: 2.0),
            ),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese su $label';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
