import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:recap_shops/providers/product_data_info.dart';
import 'package:recap_shops/widget/app_drawer.dart';
import 'package:recap_shops/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = '/Edit_product_screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusNode = FocusNode();
  final _descriptionfocusNode = FocusNode();
  final _ImageUrlController = TextEditingController();
  final _imageurlfocusNode = FocusNode();

  //one eof the steps on running the save funcetion
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: '',
      title: '',
      description: '',
      price: 0,
      imageUrl: ''); // we initialized this to be an empty product

  var _isinit = true;
  bool _isloading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl':
        '', //this are setup for a new product or editing an existing product..(1)
  };

  @override
  void initState() {
    _imageurlfocusNode.addListener(UpdateImageurl);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final ProductId = ModalRoute.of(context)!.settings.arguments as String;
      if (ProductId != null) {
        _editedProduct = Provider.of<ProductDataInfo>(context, listen: false)
            .findById(ProductId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _ImageUrlController.text = _editedProduct.imageUrl;
      }
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageurlfocusNode.removeListener(UpdateImageurl);
    _pricefocusNode.dispose();
    _descriptionfocusNode
        .dispose(); // we need to clear focus node from memory after use
    _ImageUrlController.dispose();
    _imageurlfocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void UpdateImageurl() {
    if (!_imageurlfocusNode.hasFocus) {
      if (_ImageUrlController.text.isEmpty ||
          (!_ImageUrlController.text.startsWith('http') &&
              !_ImageUrlController.text.startsWith('https')) ||
          (!_ImageUrlController.text.endsWith('png') &&
              !_ImageUrlController.text.endsWith('Jpeg') &&
              !_ImageUrlController.text.endsWith('jpg'))) {
        return;
      }
      //if we are not having focus anymore let automatically show in container preview
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _form.currentState!.save();

    // setState(() {
    //   _isloading = true;
    // });
    if (_editedProduct.id.isEmpty) {
      try {
        await Provider.of<ProductDataInfo>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (onError) {
        await Provider.of<ProductDataInfo>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occured'),
            content: Text('something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }

      // finally {
      //   setState(() {
      //     _isloading = true;
      //   });
      //   Navigator.of(context).pop();
      //}
    } else {
      await Provider.of<ProductDataInfo>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }

    //eait Provider.of<ProductDataInfo>(context, listen: false).updateProduct(_editedProduct.id _editedProduct);

    setState(() {
      _isloading = true;
    });
    if (!mounted) return;
    Navigator.of(context).pop();
    // ).then((_) {

    //  Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      // drawer: AppDrawer(),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(
                  top: 25, left: 16, right: 16, bottom: 16),
              child: Form(
                  key: _form, //key
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                        textInputAction: TextInputAction
                            .next, //this move to next instead of submitting
                        keyboardType: TextInputType.name,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(
                              _pricefocusNode); //_pricefocus node is calling the focus node in price and it is teelling us to move to the next one after pressinf the enter button in keyboard//
                        },
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return 'Please Input Title';
                          }
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              title: newValue as String,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _pricefocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionfocusNode);
                          },
                          validator: (newValue) {
                            if (newValue!.isEmpty) {
                              return 'please Enter a Price';
                            }
                            if (double.tryParse(newValue) == null) {
                              return 'Please Enter price';
                            }
                            if (double.parse(newValue) <= 0) {
                              return 'Please Enter a number greater than zero';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: double.parse(newValue!),
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionfocusNode,
                          //  onFieldSubmitted: (_){FocusScope.of(context).requestFocus(_descriptionfocusNode)}, this not needed at all
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                description: newValue as String,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          validator: (newValue) {
                            if (newValue!.isEmpty) {
                              return 'enter desription';
                            }
                            if (newValue.length < 10) {
                              return 'should be at least ten characters';
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(
                                left: 8,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                              ),
                              child: _ImageUrlController.text.isEmpty
                                  ? Text(' ImageUrl')
                                  : FittedBox(
                                      child: Image.network(
                                        _ImageUrlController.text,
                                        fit: BoxFit
                                            .none, //now i have to change it from entering enter before images pop up making it work automatically
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                // we have to wrap TextFormField becayse row has Unconstrained width so we wrap it with the expand widget
                                decoration: InputDecoration(
                                    labelText: 'Image Url',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _ImageUrlController,
                                focusNode: _imageurlfocusNode,
                                onSaved: (newValue) {
                                  _editedProduct = Product(
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      price: _editedProduct.price,
                                      imageUrl: newValue as String,
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite);
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (newValue) {
                                  if (newValue!.isEmpty) {
                                    return 'please eneter Image Url';
                                  }
                                  if (!newValue.startsWith('http') &&
                                      !newValue.startsWith('https')) {
                                    return 'Please Enter a valid url';
                                  }
                                  if (!newValue.endsWith('jpg') &&
                                      !newValue.endsWith('jpeg') &&
                                      !newValue.endsWith('png')) {
                                    return 'Please Enter a valid Url';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
    );
  }
}
