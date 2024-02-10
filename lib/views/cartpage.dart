import 'dart:convert';
import 'dart:developer';
import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/models/cart.dart';
import 'package:bookbytes/views/billscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../shared/myserverconfig.dart';

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({super.key, required this.user});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartList = <Cart>[];
  double total = 0.0;
  int newqty = 0;
  double newprice = 0;
  @override
  void initState() {
    super.initState();
    loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 255, 126, 171),
          title: Text("My Cart"),
          centerTitle: true),
      body: cartList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Expanded(
                child: ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            deleteDialog(index);
                          } else {
                            return false;
                          }
                          return false;
                        },
                        background: Container(
                          color: Colors.red,
                          child: Row(children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete)),
                          ]),
                        ),
                        key: Key(cartList[index].bookId.toString()),
                        child: ListTile(
                            title: Text(cartList[index].bookTitle.toString()),
                            onTap: () async {},
                            subtitle: Text("RM ${cartList[index].bookPrice}"),
                            leading: const Icon(Icons.sell),
                            trailing: Text("${cartList[index].cartQty} unit")),
                      );
                    }),
              ),
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL RM ${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => BillScreen(
                                          user: widget.user,
                                          totalprice: total,
                                        )));
                            loadUserCart();
                          },
                          child: const Text("Pay Now"))
                    ],
                  ))
            ]),
    );
  }

  void loadUserCart() {
    String userid = widget.user.userid.toString();
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/bookbytes/php/load_cart.php?userid=$userid"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          cartList.clear();
          total = 0.0;
          data['data']['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
            //create me code for merge the same book title in the cart
            if (cartList.length > 1) {
              for (int i = 0; i < cartList.length - 1; i++) {
                for (int j = i + 1; j < cartList.length; j++) {
                  if (cartList[i].bookId == cartList[j].bookId) {
                    cartList[i].cartQty =
                        (int.parse(cartList[i].cartQty.toString()) +
                                int.parse(cartList[j].cartQty.toString()))
                            .toString();
                    cartList[i].bookPrice =
                        (double.parse(cartList[i].bookPrice.toString()) +
                                double.parse(cartList[j].bookPrice.toString()))
                            .toString();
                    cartList.removeAt(j);
                  }
                }
              }
            }
            total = total +
                (double.parse(v['book_price']) * int.parse(v['cart_qty']));
          });
          print(total);
          setState(() {});
        } else {
          Navigator.of(context).pop();
          //if no status failed
        }
      }
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      print("Timeout");
    });
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this item?",
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
                deleteCart(index);
                //registerUser();
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

  void deleteCart(int index) {
    http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/delete_cart.php"),
        body: {
          "cartid": cartList[index].cartId,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadUserCart();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Delete Failed")));
      }
    });
  }

  void updateCart(int index, int newqty, double newprice) {
    http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/update_cart.php"),
        body: {
          "cartid": cartList[index].cartId,
          "newqty": newqty.toString(),
          "newprice": newprice.toString()
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadUserCart();
        } else {}
      } else {}
    });
  }
}
