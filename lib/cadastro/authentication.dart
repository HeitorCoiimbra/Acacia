import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //CRIA NOVO USUÁRIO (SING UP)
  Future<String?> signUp(
    {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      return null;
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }
  //FAZER LOGIN (SING IN)
  Future<String?> signIn( {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return null;
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }
  //FAZER LOGOUT (SING OUT)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  String traduzirRetorno(String msg) {
    String retorno = '';
    switch (msg) {
      case "The email address is badly formatted.":
        retorno = "Formato inválido de email";
        break;
      case "Password should be at least 6 characters":
        retorno = "A senha deve possuir ao menos 6 caracteres";
        break;
      case "The email address is already in use by another account.":
        retorno = "O email digitado já está em uso por outra conta";
        break;
      case "The password is invalid or the user does not have a password.":
        retorno = "Senha inválida.";
        break;
      case "There is no user record corresponding to this identifier. The user may have been deleted.":
        retorno = "Usuário não encontrado.";
        break;
      default:
        retorno = msg;
        break;  
    }
    return retorno;
  }
}