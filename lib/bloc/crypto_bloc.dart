import 'package:crypto_app_ui/bloc/crypto_event.dart';
import 'package:crypto_app_ui/bloc/crypto_state.dart';
import 'package:crypto_app_ui/models/crypto_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final _cryptoRepository = CryptoRepository();

  CryptoBloc() : super(CryptoInitial());

  @override
  Stream<CryptoState> mapEventToState(CryptoEvent event) async* {
    if (event is CryptoPageRequest) {
      yield CryptoLoadInProgress();

      try {
        final cryptoPageResponse = await _cryptoRepository.getCryptoPage();
        yield CryptopageLoadSuccess(
            cryptoListing: cryptoPageResponse.cryptoListing);
      } catch (e) {
        yield CryptoPageLoadFailed(error: e);
      }
    }
  }
}
