import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:espoch/vistas/crearRepositorio.dart';

import 'package:espoch/vistas/repositorio.dart';
import 'package:espoch/vistas/reutilizables.dart';

class InicioLogeadoPage extends StatefulWidget {
  const InicioLogeadoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InicioLogeadoPageState createState() => _InicioLogeadoPageState();
}

class _InicioLogeadoPageState extends State<InicioLogeadoPage> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<Widget> _pageItems = [];

  double containerHeight = 250.0;

  // Cantidad de recursos que deseas mostrar
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _buildPageItems();
    super.didChangeDependencies();
  }

///// se crean los repositorios aleatorios
  Widget _buildPageItems() {
    const int itemsPerPage = 6; // Cantidad de contenedores por página
    const int totalItems = 15; // Total de contenedores en tu lista

    List<Widget> pageItems = [];

    for (int i = 0; i < totalItems; i += itemsPerPage) {
      List<Widget> page = [];

      for (int j = i; j < i + itemsPerPage; j++) {
        if (j < totalItems) {
          Color randomColor = const Color.fromARGB(255, 149, 148, 148);

          page.add(
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const repositoriosScreem(),
                  ),
                );
              },
              child: Container(
                color: randomColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Nombre del recurso',
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }

      pageItems.add(
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: page,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 400;
////version mobil
        if (isMobile) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: pageItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              return pageItems[index];
            },
          );
        } else {
// Versión para web
          int columns = (maxWidth / 200)
              .floor(); // Ajusta el número de columnas según tus necesidades
          double spacing = 8.0; // Espacio entre los contenedores
          double containerWidth =
              (maxWidth - (columns - 1) * spacing) / columns;
          double containerHeight =
              250.0; // Ajusta la altura máxima de los contenedores según tus necesidades

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  500, // Ajusta el ancho máximo de cada contenedor
              mainAxisExtent:
                  containerHeight, // Ajusta la altura máxima de cada contenedor
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: containerWidth /
                  containerHeight, // Ajusta la relación de aspecto según tus necesidades
            ),
            itemCount: pageItems.length,
            itemBuilder: (context, index) {
              return pageItems[index];
            },
          );
        }
      },
    );
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    } else {
      _pageController.jumpToPage(_pageItems.length - 1);
      setState(() {
        _currentPage = _pageItems.length - 1;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _pageItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _pageController.jumpToPage(0);
      setState(() {
        _currentPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
    body: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
    children: <Widget>[
      const SizedBox(height: 10),
      const Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Recursos mas populares',
          style: TextStyle(fontSize: 18),
        ),
      ),
      const SizedBox(height: 15),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '   Buscar',
                    border: InputBorder.none,
                   
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Color.fromARGB(255, 25, 182, 33),
            child: IconButton(
              onPressed: () {
                // Lógica para manejar la acción del botón de búsqueda
              },
              icon: Icon(
                Icons.search,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        color: Color.fromARGB(255, 25, 182, 33),
        child: IconButton(
          onPressed: () {
            // Lógica para manejar la acción del botón "+"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CrearRepositorio()),
            );
          },
          icon: Icon(
            Icons.add,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 10),
      ////aqui se ponen los repositorios ahora esta solo creandose aleatoriamente pero deberia ir con una base de datos
      Expanded(
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [_buildPageItems()],
        ),
      ),
    ],
  ),
),

      ////footer
      bottomNavigationBar: MyBottomNavigationBar(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0), // Ajusta el espaciado aquí
            child: IconButton(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          IconButton(
            onPressed: _nextPage,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
