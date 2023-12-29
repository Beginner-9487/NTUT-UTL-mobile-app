import 'characteristic_and_descriptor_abstract.dart';
import 'characteristic_and_descriptor_mixin.dart';

class ChaDesBlocExampleBloc extends BluetoothChaDesPageBloc with ChaDesBlocExample {
  ChaDesBlocExampleBloc({super.characteristic, super.descriptor});
}