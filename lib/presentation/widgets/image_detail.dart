import 'dart:typed_data';

import 'package:bouncing_button/bouncing_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/commons/colors.dart';
import 'package:minwell/models/heart.dart';
import 'package:minwell/presentation/widgets/widgets.dart';

class ImageDetail extends StatefulWidget {
  String urlData;
  String? photographerURL;
  String? photographerData;
  String? widthImageData;
  int? heightImageData;
  String? avg_colorData;
  ImageDetail(
      {super.key,
      required this.urlData,
      this.photographerData,
      this.photographerURL,
      this.widthImageData,
      this.heightImageData,
      this.avg_colorData});

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  //Variables
  bool? isFavorite = false;
  Color favoriteColor = Colors.white;
  late ConfettiController _controllerTopCenter;

  // Inicializar el estado
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavoritesBloc>(context).add(GetFavorites());
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  // Cambiar el estado de favorito
  setFavorite() {
    setState(() {
      isFavorite = !isFavorite!;
    });
  }
  
  /// Guardar imagen en la galeria
  saveImage()async{
     try {
      Loader.show(
        context, 
        overlayColor: Colors.black.withOpacity(0.6),
        progressIndicator: CircularProgressIndicator(
        color: buttonsBar,
      ));
      var response = await Dio()
          .get(widget.urlData, options: Options(responseType: ResponseType.bytes));
      
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "ImageMinwell");
      if (result == null) {
        return;
      }
      Loader.hide();
      CherryToast(title: const Text('Imagen descargada'), icon: Icons.download_done, themeColor: buttonsBar).show(context);
      // Below is a method of obtaining saved image information.
    } on PlatformException catch (error) {
      print(error);
    }
  }
  @override
  Widget build(BuildContext context) {
    var blocFavorites = BlocProvider.of<FavoritesBloc>(context);
    var blocFavoritesState = blocFavorites.state;
    List<String> favorites = [];
    /// Obtener el estado de favoritos
    if (blocFavoritesState is FavoritesLoaded) {
      favorites = blocFavoritesState.favorites;
      isFavorite = blocFavoritesState.isFavorite;
    }

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  child: CachedNetworkImage(
                      imageUrl: widget.urlData, fit: BoxFit.cover))),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black,
                      Colors.transparent,
                    ])),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: buttonsBar,
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                            padding: const EdgeInsets.all(10),
                            onPressed: () {
                              Navigator.pop(context);
                              BlocProvider.of<FavoritesBloc>(context)
                                  .add(GetFavorites());
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            )),
                      ),
                      const Spacer(),
                      ConfettiWidget(
                        blastDirectionality: BlastDirectionality
                            .explosive, // don't specify a direction, blast randomly
                        confettiController: _controllerTopCenter,
                        particleDrag: 0.03, // apply drag to the confetti
                        emissionFrequency: 0.03, // how often it should emit
                        numberOfParticles: 5, // number of particles to emit
                        gravity: 0.05, // gravity - or fall speed
                        shouldLoop:
                            false, // start again as soon as the animation is finished
                        colors: const [Colors.red],
                        createParticlePath:
                            drawHeart, // define a custom shape/path.
                        child: BouncingButton(
                          child: Icon(Icons.favorite,
                              color: favorites.contains(widget.urlData)
                                  ? isFavorite == true
                                      ? favoriteColor = Colors.red
                                      : favoriteColor = Colors.white
                                  : Colors.white),
                          onPressed: () {
                            _controllerTopCenter.play();
                            setFavorite();
                            if (favorites.contains(widget.urlData)) {
                              blocFavorites
                                  .add(RemoveFavorite(url: widget.urlData));
                              _controllerTopCenter.stop();
                            } else {
                              blocFavorites
                                  .add(SetFavorite(url: widget.urlData));

                              CherryToast.success(
                                  title: const Text(
                                'Agregado a favoritos',
                              )).show(context);
                            }
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            
                           saveImage(); 
                          
                          },
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ]),
              ),
              height: 250,
              child: ImageInfoDetail(
                urlData: widget.urlData,
                photographerData: widget.photographerData,
                photographerURL: widget.photographerURL,
                widthImageData: widget.widthImageData,
                heightImageData: widget.heightImageData,
                avg_colorData: widget.avg_colorData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
