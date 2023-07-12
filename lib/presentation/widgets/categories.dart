import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/commons/colors.dart';
import 'package:minwell/presentation/pages/resultSearch_view.dart';

class CategoriSlider extends StatefulWidget {
  const CategoriSlider({super.key});

  @override
  State<CategoriSlider> createState() => _CategoriSliderState();
}

class _CategoriSliderState extends State<CategoriSlider> {
  List categorias = [
    'Nature',
    'Galaxy ',
    'People ',
    'Animal ',
    'Space ',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print('Categoria ${categorias[index]}');
              BlocProvider.of<SearchBloc>(context)
                  .add(SearchWallpapers(query: categorias[index], page: 1));
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ResultSearch(categoria: categorias[index],)))
                  .catchError((onError) {
                print('error');
              });
            },
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                color: buttonsBar,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.category,
                    size: 20,
                  ),
                  Text(
                    ' ${categorias[index]}',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
