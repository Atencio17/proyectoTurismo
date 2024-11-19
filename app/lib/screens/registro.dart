import 'package:app/screens/login.dart';
import 'package:app/utils/api.dart';
import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _documentTypes = ['CC', 'Pasaporte', 'TI'];
  String? _selectedDocumentType = 'CC';
  final Color mintGreen = Color(0xFF3EB489);

  // Variables para almacenar los datos del formulario
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Registro',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Tipo de documento
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Tipo de Documento',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mintGreen),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mintGreen, width: 2.0),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: TextStyle(color: Colors.white),
                  items: _documentTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDocumentType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un tipo de documento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Campos de texto
                _buildTextFormField(
                  controller: _documentNumberController,
                  label: 'Número de Documento',
                  keyboardType: TextInputType.number,
                ),
                _buildTextFormField(
                  controller: _nameController,
                  label: 'Nombre',
                ),
                _buildTextFormField(
                  controller: _lastNameController,
                  label: 'Apellido',
                ),
                _buildTextFormField(
                  controller: _birthDateController,
                  label: 'Fecha de Nacimiento',
                  hintText: 'YYYY-MM-DD',
                  keyboardType: TextInputType.datetime,
                ),
                _buildTextFormField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: true,
                ),
                _buildTextFormField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),

                // Botón de registro
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mintGreen,
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Las contraseñas no coinciden'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      try {
                        await ProductService()
                            .createUser(
                              _documentNumberController.text,
                              _nameController.text,
                              _lastNameController.text,
                              _birthDateController.text,
                              _passwordController.text,
                            )
                            .whenComplete(() => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginForm(),
                                )));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Usuario creado exitosamente'),
                            backgroundColor: mintGreen,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al crear el usuario: $e'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para simplificar la creación de campos de texto
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.grey),
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