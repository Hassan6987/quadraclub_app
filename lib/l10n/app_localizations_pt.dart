// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get somethingWentWrong => 'Algo deu errado';

  @override
  String get signIn => 'Entrat';

  @override
  String get enterYourCredentialsManageYourBookings =>
      'Insira suas credenciais para gerenciar seu reservas.';

  @override
  String get email => 'E-mail';

  @override
  String get enterYourEmail => 'Digite seu e-mail';

  @override
  String get password => 'Senha';

  @override
  String get enterYourPassword => 'Digite sua senha';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get doNotHaveAnAccount => 'Não tem uma conta? ';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get anOtpHasBeenSentToYourEmail =>
      'Um código OTP foi enviado para o seu e-mail.';

  @override
  String get forgotPasswordd => 'Esqueci a senha';

  @override
  String get enterTheEmailAddressAssociatedWithAccountWeSendYouRecoveryCode =>
      'Digite o endereço de e-mail associado à conta e enviaremos um código de recuperação.';

  @override
  String get sendCode => 'Enviar código';

  @override
  String get emailVerifiedSuccessfully => 'E-mail verificado com sucesso';

  @override
  String get otpVerification => 'Verificação OTP';

  @override
  String get enterTheDigitCodeSentToYouAt =>
      'Digite o código de 6 dígitos enviado a você em:';

  @override
  String get verify => 'Verifique';

  @override
  String get iDidNotReceiveCode => 'Não recebi um código ';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get didNotReceiveTheCodeCheckYourSpamFolderOrTryResendingIt =>
      'Não recebeu o código? Verifique sua pasta de spam ou tente reenviá-la.';

  @override
  String get verifyContinue => 'Verifique e continue';

  @override
  String get pleaseConfirmYourPassword => 'Por favor, confirme sua senha.';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem.';

  @override
  String get passwordChangedSuccessfully => 'Senha alterada com sucesso.';

  @override
  String get setNewPassword => 'Definir nova senha';

  @override
  String get setNewPasswordToSecureYourAccount =>
      'Defina uma nova senha para proteger sua conta.';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get confirmNewPassword => 'Digite sua senha';

  @override
  String get done => 'Concluído';

  @override
  String get createYourAccount => 'Crie sua conta';

  @override
  String get fillInYourDetailsToStartPlaying =>
      'Preencha seus dados para começar a jogar.';

  @override
  String get profilePhoto => 'Foto do perfil';

  @override
  String get jpgOrPNGMaxMB => 'JPG ou PNG, máximo 5 MB.';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get enterYourName => 'Digite seu nome';

  @override
  String get dateOfBirth => 'Data de nascimento';

  @override
  String get ddMmYyyy => 'dd/mm/aaaa';

  @override
  String get dateOfBirthIsRequired =>
      'É necessário informar a data de nascimento.';

  @override
  String get confirmYourPassword => 'Confirme sua senha';

  @override
  String get continuee => 'Continuar';

  @override
  String get back => 'Voltar';

  @override
  String get step => 'Etapa';

  @override
  String get locationPermissionIsRequiredToUseThis =>
      'É necessário obter permissão de localização para usar este recurso.';

  @override
  String get pleaseEnableLocationServices =>
      'Por favor, ative os serviços de localização.';

  @override
  String get couldNotDetermineYourCityPleaseSearchManually =>
      'Não foi possível determinar sua cidade. Por favor, pesquise manualmente.';

  @override
  String get somethingWentWrongGettingYourLocation =>
      'Ocorreu um erro ao obter sua localização.';

  @override
  String get aboutYou => 'Sobre você';

  @override
  String get thisHelpsYouFindCourtsAndPlayersNearYou =>
      'Isso ajuda você a encontrar quadras e jogadores perto de você.';

  @override
  String get location => 'Localização';

  @override
  String get useMyLocation => 'Usar minha localização';

  @override
  String get cityArea => 'Cidade/área';

  @override
  String get gender => 'Gênero';

  @override
  String get masculine => 'Masculino';

  @override
  String get feminine => 'Feminino';

  @override
  String get preferNotToSay => 'Prefiro não dizer';

  @override
  String get dominantHand => 'Mão Dominante';

  @override
  String get left => 'Esquerda';

  @override
  String get right => 'Certo';

  @override
  String get whatGamesDoYouPlay => 'Que jogos você joga?';

  @override
  String get selectOneOrMoreYouCanAddOthersLater =>
      'Selecione um ou mais. Você pode adicionar outros mais tarde.';

  @override
  String get continueWith => 'Continuar com';

  @override
  String get sport => 'esporte';

  @override
  String get defineYourLevel => 'Defina seu nível.';

  @override
  String get selectCategoryForEachSport =>
      'Selecione sua categoria para cada esporte. Você pode alterá-la depois.';

  @override
  String get youCanChangeThisLater => 'Você pode alterar isso depois';

  @override
  String get selectYourCategory => 'Selecione sua categoria';

  @override
  String get preferredSide => 'Lado preferido';

  @override
  String get both => 'Ambos';

  @override
  String get completeRegistration => 'Concluir cadastro';

  @override
  String get categoryOpen => 'Aberto';

  @override
  String get categoryOpenDescription => 'Para jogadores avançados/competitivos';

  @override
  String get category1 => 'Categoria 1';

  @override
  String get category1Description => 'Jogadores de nível iniciante';

  @override
  String get category2 => 'Categoria 2';

  @override
  String get category2Description => 'Jogadores de nível intermediário';

  @override
  String get category3 => 'Categoria 3';

  @override
  String get category3Description => 'Jogadores de nível avançado';

  @override
  String everythingReady(Object firstName) {
    return 'Está tudo pronto, $firstName!';
  }

  @override
  String get timeToFindCourtsPlayersMatches =>
      'É hora de encontrar quadras, jogadores e partidas perto de você.';

  @override
  String get profileSummary => 'Resumo do perfil';

  @override
  String get findSportsCourtsNearMe =>
      'Encontrar quadras esportivas perto de mim';

  @override
  String get classes => 'Aulas';

  @override
  String get matches => 'Partidas';

  @override
  String get courts => 'Quadras';

  @override
  String get agenda => 'Agenda';

  @override
  String get profile => 'Perfil';
}
