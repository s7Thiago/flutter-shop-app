import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  // Focus nodes
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final productInstance =
          ModalRoute.of(context).settings.arguments as Product;

      if (productInstance != null) {
        //Initializing the form data with data passed via argument object
        _formData['id'] = productInstance.id;
        _formData['title'] = productInstance.title;
        _formData['description'] = productInstance.description;
        _formData['price'] = productInstance.price;
        _formData['imageUrl'] = productInstance.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool startsWithHttp = url.startsWith('http://');
    bool startsWithHttps = url.startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithjpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startsWithHttp || startsWithHttps) &&
        (endsWithPng || endsWithjpg || endsWithJpeg);
  }

  _saveForm() {
    bool _isFormValid = _form.currentState.validate();

    if (!_isFormValid) return; //If the form is not valid, exits the function

    _form.currentState.save(); //Call the onSave from each form textfield

// Product instance
    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
      price: _formData['price'],
    );

    // Adding the product above in the global list via provider
    final products = Provider.of<Products>(context, listen: false);

    // Records when some late operation is running
    setState(() => _isLoading = true);

    if (_formData['id'] == null) {
      products.addProduct(product).then((_) {
        // Records when some late operation is finished
        setState(() => _isLoading = true);
        Navigator.of(context).pop();
      });
    } else {
      products.updateProduct(product);
      setState(() => _isLoading = true);
      Navigator.of(context).pop();
    }

    Navigator.of(context).pop(); // Closing the current screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _formData['title'] = value;
                      },
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;

                        bool isInvalid = value.trim().length < 3;

                        if (isEmpty || isInvalid) {
                          return 'Provide a valid title at least 3 letters!';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _formData['price'] = double.parse(value);
                      },
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isInvalid = newPrice == null || newPrice <= 0;

                        if (isEmpty || isInvalid) {
                          return 'Provide a valid price!';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      },
                      onSaved: (value) {
                        _formData['description'] = value;
                      },
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;

                        bool isInvalid = value.trim().length < 10;

                        if (isEmpty || isInvalid) {
                          return 'Provide a valid description with at least 10 characters!';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            onFieldSubmitted: (value) {
                              _saveForm();
                            },
                            controller: _imageUrlController,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onSaved: (value) {
                              _formData['imageUrl'] = value;
                            },
                            validator: (value) {
                              bool emptyUrl = value.trim().isEmpty;
                              bool invalidUrl = !isValidImageUrl(value);

                              if (emptyUrl || invalidUrl)
                                return 'Provide a valid image URL';

                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, left: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Type a URL')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
