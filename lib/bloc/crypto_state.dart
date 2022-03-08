import 'package:crypto_app_ui/models/crypto_page_response.dart';

abstract class CryptoState {}

class CryptoInitial extends CryptoState {}

class CryptoLoadInProgress extends CryptoState {}

class CryptopageLoadSuccess extends CryptoState {
  final List<CryptoListing> cryptoListing;

  CryptopageLoadSuccess({required this.cryptoListing});
}

class CryptoPageLoadFailed extends CryptoState {
  final error;
  CryptoPageLoadFailed({required this.error});
}
