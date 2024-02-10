import 'dart:convert';
import 'dart:developer';
import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/views/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbytes/models/book.dart';
import 'package:bookbytes/shared/myserverconfig.dart';

class BookDetails extends StatefulWidget {
  final User user;
  final Book book;

  const BookDetails({Key? key, required this.user, required this.book})
      : super(key: key);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  late double screenWidth, screenHeight;
  final f = 'Placeholder';
  bool bookowner = false;

  @override
  Widget build(BuildContext context) {
    if (widget.user.userid == widget.book.sellerId) {
      bookowner = true;
    } else {
      bookowner = false;
    }
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(widget.book.bookTitle.toString()),
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.4,
              width: screenWidth,
              child: Image.network(
                "${MyServerConfig.server}/bookbytes/assets/${widget.book.bookId}.png",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              height: screenHeight * 0.6,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.book.bookTitle.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.book.bookAuthor.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("ISBN ${widget.book.bookIsbn}"),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.bookDesc.toString(),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "RM ${widget.book.bookPrice}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Quantity Available ${widget.book.bookQty}"),
                  ElevatedButton(
                    onPressed: () {
                      //print(widget.user.useremail);
                      if (widget.user.useremail == 'unregistered@email.com') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (content) => LoginPage()));
                      } else {
                        // Add to cart function
                        insertCartDialog();
                      }
                    },
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    void insertCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Insert to cart?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertCart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertCart() {
    http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/insert_cart.php"),
        body: {
          "buyer_id": widget.user.userid.toString(),
          "seller_id": widget.book.sellerId.toString(),
          "book_id": widget.book.bookId.toString(),
          "book_price": widget.book.bookPrice.toString(),
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

}