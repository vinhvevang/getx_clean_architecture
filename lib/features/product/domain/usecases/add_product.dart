
import 'package:flutter/material.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

class AddProduct {
   ProductRepository repository;
   AddProduct(this.repository);
   
  void call(Product product){
    repository.addProduct(product);
  }
  }
