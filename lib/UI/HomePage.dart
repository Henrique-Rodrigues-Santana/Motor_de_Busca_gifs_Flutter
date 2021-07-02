import 'dart:convert';

import 'package:buscadordegifsflutter/UI/GifPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  String _search ;
  int _offset;

  Future<Map>_getGifs()async{
    
    http.Response response ;
    // caso a string _search seja nulo retorna os 20 melhores gif
    if(_search == null)
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=Q9PNI00GQPaYoS1vOFh8Py5jlPS1zhqe&limit=20&rating=g");
    // caso não, retorna o valor da busca, adicionado no meio da url
    else
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=Q9PNI00GQPaYoS1vOFh8Py5jlPS1zhqe&q=${_search}&limit=19&offset=${_offset}&rating=g&lang=pt");
    return jsonDecode(response.body);
  }

  int getConta(List data){
    if(_search == null)
      return data.length;
    else
      return data.length +  1;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: TextField(
              onSubmitted: (String texto){
                setState(() {
                  _search = texto;
                  _offset = 0;
                });
              },
              decoration: InputDecoration(
                labelText: "Pesquisar",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white,fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: FutureBuilder(
              future: _getGifs(),
              builder: (context,snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  // ignore: missing_return
                  default:
                    if(snapshot.hasError) return Container();
                    else return _createGifTable(context,snapshot);
                }
              }
          ))
        ],
      )
    );
}

                                            // os Objetos da função _getGifs são chamados pelo snapshot,
                                            // que pode ser qualquer nome
 Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(10),
        // organiza os grids na tela
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // quantos itens na horizontal
            crossAxisCount: 2,
          // espaçamento entre os grids na tela
            crossAxisSpacing: 10,
          // espaçamento na vertical
            mainAxisSpacing: 10
        ),
        itemCount: getConta(snapshot.data["data"]),
        itemBuilder: (context,index){
          if(_search == null || index < snapshot.data["data"].length)
          return GestureDetector(
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> GifPage(snapshot.data["data"][index]))
              );
            },
            child: Image.network("${snapshot.data["data"][index]
            ["images"]["fixed_height"]["url"]}",height: 300,fit: BoxFit.cover,),
          );
          else
            return Container(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    _offset += 19;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,color: Colors.white,size: 70,),
                    Text("Carregar Mais ... ",style: TextStyle(color: Colors.white,fontSize: 22),)
                  ],
                ),
              ),
            );
        }
        );
 }
}
