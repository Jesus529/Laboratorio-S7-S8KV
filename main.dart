
import 'package:flutter/material.dart';

void main() {
  runApp(const ProductosApp());
}

const Color azul = Color(0xFF3157D5);
const Color fondo = Color(0xFFF3F6FC);
const Color verde = Color(0xFF159B79);
const Color rojo = Color(0xFFE34D59);

const String fotoPerfil =
    'https://jujutsu-kaisen.fandom.com/es/wiki/Yuta_Okkotsu';

class Producto {
  String nombre;
  String descripcion;
  double precio;

  Producto(this.nombre, this.descripcion, this.precio);
}

class ProductosApp extends StatefulWidget {
  const ProductosApp({super.key});

  @override
  State<ProductosApp> createState() => _ProductosAppState();
}

class _ProductosAppState extends State<ProductosApp> {
  String pantalla = 'login';
  String correo = '';
  String nombreUsuario = 'JHON kEVIN';
  String telefono = '987 654 321';

  final List<Producto> productos = [
    Producto('Laptop', 'Laptop para uso personal', 2500),
    Producto('Mouse', 'Mouse inalambrico', 80),
    Producto('Teclado', 'Teclado USB', 120),
    Producto('Monitor', 'Monitor LED', 900),
  ];

  // setState permite actualizar los datos que aparecen en pantalla.
  // Se utiliza cuando cambia el menu o se modifica un producto.
  // Flutter vuelve a ejecutar build para mostrar los cambios.
  void cambiarPantalla(String valor) {
    setState(() {
      pantalla = valor;
    });
  }

  void cerrarSesion() {
    setState(() {
      pantalla = 'login';
      correo = '';
    });
  }

  void agregarProducto(Producto producto) {
    setState(() {
      productos.add(producto);
    });
  }

  void eliminarProducto(Producto producto) {
    setState(() {
      productos.remove(producto);
    });
  }

  void actualizarPerfil(String nombre, String email, String celular) {
    setState(() {
      nombreUsuario = nombre;
      correo = email;
      telefono = celular;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi tienda',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: azul),
        scaffoldBackgroundColor: fondo,
        appBarTheme: const AppBarTheme(
          backgroundColor: azul,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: fondo,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: _construirPantalla(),
    );
  }

  Widget _construirPantalla() {
    switch (pantalla) {
      case 'login':
        return LoginPage(
          onLogin: (email) {
            setState(() {
              correo = email;
              pantalla = 'menu';
            });
          },
        );

      case 'menu':
        return MenuPage(
          nombre: nombreUsuario,
          correo: correo,
          cantidad: productos.length,
          onRegistrar: () => cambiarPantalla('registro'),
          onListar: () => cambiarPantalla('lista'),
          onPerfil: () => cambiarPantalla('perfil'),
          onLogout: cerrarSesion,
        );

      case 'registro':
        return RegistroPage(
          onBack: () => cambiarPantalla('menu'),
          onGuardar: (producto) {
            agregarProducto(producto);
            cambiarPantalla('lista');
          },
        );

      case 'lista':
        return ListaPage(
          productos: productos,
          onBack: () => cambiarPantalla('menu'),
          onEliminar: eliminarProducto,
        );

      case 'perfil':
        return PerfilPage(
          nombre: nombreUsuario,
          correo: correo,
          telefono: telefono,
          onBack: () => cambiarPantalla('menu'),
          onGuardar: actualizarPerfil,
        );

      default:
        return LoginPage(
          onLogin: (email) {
            setState(() {
              correo = email;
              pantalla = 'menu';
            });
          },
        );
    }
  }
}

// LOGIN
class LoginPage extends StatefulWidget {
  final ValueChanged<String> onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  void ingresar() {
    if (correoController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    widget.onLogin(correoController.text.trim());
  }

  @override
  void dispose() {
    // dispose se ejecuta cuando esta pantalla deja de utilizarse.
    // Los controladores pueden consumir recursos si no se liberan.
    // dispose() evita mantener controladores que ya no necesitamos.
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PantallaMarco(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.storefront_rounded, size: 65, color: azul),
          const SizedBox(height: 12),
          const Text(
            'Bienvenido',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Ingresa a tu tienda',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 28),
          campo(correoController, 'Correo electronico', Icons.email_outlined),
          const SizedBox(height: 14),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            onSubmitted: (_) => ingresar(),
          ),
          const SizedBox(height: 24),
          boton('INGRESAR', Icons.login_rounded, ingresar),
          const SizedBox(height: 12),
          const Text(
            'Demo: puedes ingresar con cualquier cuenta',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// MENU PRINCIPAL
class MenuPage extends StatelessWidget {
  final String nombre;
  final String correo;
  final int cantidad;
  final VoidCallback onRegistrar;
  final VoidCallback onListar;
  final VoidCallback onPerfil;
  final VoidCallback onLogout;

  const MenuPage({
    super.key,
    required this.nombre,
    required this.correo,
    required this.cantidad,
    required this.onRegistrar,
    required this.onListar,
    required this.onPerfil,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi tienda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: onLogout,
            tooltip: 'Cerrar sesion',
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [azul, Color(0xFF728CF2)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                avatarPerfil(30),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hola, bienvenido!',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        correo,
                        style: const TextStyle(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Panel principal',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5ECFF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: azul,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(child: Text('Productos registrados')),
                Text(
                  '$cantidad',
                  style: const TextStyle(
                    color: azul,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            '¿Que deseas hacer?',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          opcion(
            Icons.add_box_rounded,
            'Registrar productos',
            'Agrega un producto nuevo',
            verde,
            onRegistrar,
          ),
          opcion(
            Icons.inventory_2_rounded,
            'Listar productos',
            'Consulta o elimina productos',
            azul,
            onListar,
          ),
          opcion(
            Icons.person_rounded,
            'Mi perfil',
            'Edita tus datos personales',
            const Color(0xFF8B5CF6),
            onPerfil,
          ),
          opcion(
            Icons.logout_rounded,
            'Cerrar sesion',
            'Salir de tu cuenta',
            rojo,
            onLogout,
          ),
        ],
      ),
    );
  }
}

// REGISTRAR PRODUCTOS
class RegistroPage extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<Producto> onGuardar;

  const RegistroPage({
    super.key,
    required this.onBack,
    required this.onGuardar,
  });

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();

  void guardar() {
    final nombre = nombreController.text.trim();
    final descripcion = descripcionController.text.trim();

    // double.tryParse convierte el texto en un numero decimal.
    // Si el texto no es numerico, devuelve null en vez de fallar.
    // Esto permite validar el precio antes de guardar el producto.
    final precio = double.tryParse(
      precioController.text.trim().replaceAll(',', '.'),
    );

    if (nombre.isEmpty ||
        descripcion.isEmpty ||
        precio == null ||
        precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa los campos con un precio valido'),
        ),
      );
      return;
    }

    widget.onGuardar(Producto(nombre, descripcion, precio));
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        title: const Text('Registrar producto'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          cabecera(
            Icons.add_shopping_cart_rounded,
            'Nuevo producto',
            'Completa la informacion del producto',
          ),
          const SizedBox(height: 22),
          campo(nombreController, 'Nombre del producto', Icons.inventory),
          const SizedBox(height: 16),
          campo(descripcionController, 'Descripcion', Icons.description),
          const SizedBox(height: 16),
          campo(
            precioController,
            'Precio en soles (S/)',
            Icons.payments,
            tecladoNumerico: true,
          ),
          const SizedBox(height: 24),
          boton('GUARDAR PRODUCTO', Icons.save_rounded, guardar),
        ],
      ),
    );
  }
}

// LISTAR Y ELIMINAR PRODUCTOS
class ListaPage extends StatelessWidget {
  final List<Producto> productos;
  final VoidCallback onBack;
  final ValueChanged<Producto> onEliminar;

  const ListaPage({
    super.key,
    required this.productos,
    required this.onBack,
    required this.onEliminar,
  });

  Future<void> confirmarEliminacion(
    BuildContext context,
    Producto producto,
  ) async {
    // showDialog muestra una ventana encima de la pantalla actual.
    // La ventana pregunta si el usuario realmente quiere eliminar.
    // El resultado true confirma la accion y false la cancela.
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        icon: const Icon(Icons.delete_outline, color: rojo, size: 42),
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que deseas eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: rojo,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete),
            label: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      onEliminar(producto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${producto.nombre} eliminado'),
          backgroundColor: verde,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: onBack),
        title: const Text('Mis productos'),
      ),
      body: productos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 85,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'No hay productos',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Registra un producto para que aparezca aqui.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    boton('VOLVER AL MENU', Icons.home, onBack),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                cabecera(
                  Icons.inventory_2_rounded,
                  'Catalogo',
                  '${productos.length} productos registrados',
                ),
                const SizedBox(height: 14),
                ...productos.map(
                  (producto) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5ECFF),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_rounded,
                            color: azul,
                          ),
                        ),
                        title: Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(producto.descripcion),
                              const SizedBox(height: 7),
                              Text(
                                'S/ ${producto.precio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: verde,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: 'Eliminar producto',
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE9EB),
                          ),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: rojo,
                          ),
                          onPressed: () =>
                              confirmarEliminacion(context, producto),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onBack,
        backgroundColor: azul,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.home_rounded),
        label: const Text('Menu'),
      ),
    );
  }
}

// PERFIL
class PerfilPage extends StatefulWidget {
  final String nombre;
  final String correo;
  final String telefono;
  final VoidCallback onBack;
  final Function(String, String, String) onGuardar;

  const PerfilPage({
    super.key,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.onBack,
    required this.onGuardar,
  });

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late final TextEditingController nombreController;
  late final TextEditingController correoController;
  late final TextEditingController telefonoController;

  @override
  void initState() {
    super.initState();

    // initState se ejecuta al crear la pantalla por primera vez.
    // Aqui colocamos los datos actuales dentro de los campos.
    // Asi el perfil muestra la informacion guardada anteriormente.
    nombreController = TextEditingController(text: widget.nombre);
    correoController = TextEditingController(text: widget.correo);
    telefonoController = TextEditingController(text: widget.telefono);
  }

  void guardarPerfil() {
    final nombre = nombreController.text.trim();
    final email = correoController.text.trim();
    final celular = telefonoController.text.trim();

    if (nombre.isEmpty || email.isEmpty || celular.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    widget.onGuardar(nombre, email, celular);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil actualizado')),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        title: const Text('Mi perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                avatarPerfil(58),
                const SizedBox(height: 12),
                const Text(
                  'Datos personales',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                campo(nombreController, 'Nombre completo', Icons.person),
                const SizedBox(height: 15),
                campo(correoController, 'Correo', Icons.email),
                const SizedBox(height: 15),
                campo(telefonoController, 'Telefono', Icons.phone),
                const SizedBox(height: 24),
                boton(
                  'GUARDAR CAMBIOS',
                  Icons.check_circle_outline,
                  guardarPerfil,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// FOTO DE PERFIL CON RESPALDO
Widget avatarPerfil(double radio) {
  return CircleAvatar(
    radius: radio,
    backgroundColor: const Color(0xFFE5ECFF),
    child: ClipOval(
      child: SizedBox(
        width: radio * 2,
        height: radio * 2,
        // Image.network carga la foto desde una direccion de internet.
        // errorBuilder muestra un reemplazo si el enlace no funciona.
        // Asi la pantalla conserva el avatar aunque no cargue Pinterest.
        child: Image.network(
          fotoPerfil,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'JV',
                style: TextStyle(
                  fontSize: radio * 0.65,
                  color: azul,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

// COMPONENTES DE DISEÑO
class PantallaMarco extends StatelessWidget {
  final Widget child;

  const PantallaMarco({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE7EDFF), fondo, Color(0xFFDDE9FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 390),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: azul.withAlpha(25),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget cabecera(IconData icono, String titulo, String subtitulo) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFE5ECFF),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Icon(icono, color: azul, size: 35),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitulo,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget campo(
  TextEditingController controller,
  String etiqueta,
  IconData icono, {
  bool tecladoNumerico = false,
}) {
  return TextField(
    controller: controller,
    keyboardType: tecladoNumerico
        ? const TextInputType.numberWithOptions(decimal: true)
        : TextInputType.text,
    decoration: InputDecoration(
      labelText: etiqueta,
      prefixIcon: Icon(icono, color: azul),
    ),
  );
}

Widget boton(String texto, IconData icono, VoidCallback accion) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton.icon(
      onPressed: accion,
      icon: Icon(icono),
      label: Text(
        texto,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}

Widget opcion(
  IconData icono,
  String titulo,
  String subtitulo,
  Color color,
  VoidCallback accion,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icono, color: color),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: accion,
      ),
    ),
  );
}

