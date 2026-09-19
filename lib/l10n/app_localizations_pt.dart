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

  @override
  String get language => 'linguagem';

  @override
  String get chooseLanguage => 'Escolha seu idioma preferido';

  @override
  String get close => 'Fechar';

  @override
  String get myChats => 'Meus chats';

  @override
  String get signInToViewYourChatsAndConversations =>
      'Entre para ver seus chats e conversas';

  @override
  String get all => 'Todos';

  @override
  String get games => 'Partidas';

  @override
  String get noChatsFound => 'Nenhum chat encontrado';

  @override
  String get game => 'Partida';

  @override
  String get classroom => 'Aula';

  @override
  String get now => 'agora';

  @override
  String get you => 'VOCÊ';

  @override
  String get players => 'jogadores';

  @override
  String playersInChat(int count) {
    return '$count jogadores no chat';
  }

  @override
  String get typeYourMessage => 'Digite sua mensagem';

  @override
  String get today => 'HOJE';

  @override
  String get yesterday => 'ONTEM';

  @override
  String get classDetails => 'Detalhes da aula';

  @override
  String registrationUntil(String date) {
    return 'Inscrições até $date';
  }

  @override
  String get description => 'Descrição';

  @override
  String get classFull => 'Aula lotada';

  @override
  String get confirmLesson => 'Confirmar aula';

  @override
  String get registrationClosed => 'Inscrições encerradas';

  @override
  String get classBooked => 'Aula reservada';

  @override
  String get classConfirmedMessage =>
      'Sua aula está confirmada. Esperamos por você!';

  @override
  String categoryWithLevel(String level) {
    return 'Categoria $level';
  }

  @override
  String get group => 'Grupo';

  @override
  String get individual => 'Individual';

  @override
  String get coach => 'Professor';

  @override
  String get availableClasses => 'Aulas disponíveis';

  @override
  String get noClassesFound => 'Nenhuma aula encontrada.';

  @override
  String get searchByName => 'Pesquisar por nome...';

  @override
  String todayWithDate(String date) {
    return 'Hoje, $date';
  }

  @override
  String tomorrowWithDate(String date) {
    return 'Amanhã, $date';
  }

  @override
  String get signInToBookThisClass => 'Entre para reservar esta aula';

  @override
  String get loginToReserveYourSpot =>
      'Entre ou crie uma conta para reservar sua vaga.';

  @override
  String get paymentForLesson => 'Pagamento da aula';

  @override
  String get afterPaymentCoachApproval =>
      'Após o pagamento, sua solicitação será enviada ao professor para aprovação.';

  @override
  String get paymentMethod => 'MÉTODO DE PAGAMENTO';

  @override
  String get insufficientPortfolioBalance => 'Saldo insuficiente no portfólio';

  @override
  String get agreeToTermsOfUse => 'Concordo com os termos de uso.';

  @override
  String get filters => 'Filtros';

  @override
  String get timeOfDay => 'Horário';

  @override
  String get morning => 'Manhã';

  @override
  String get afternoon => 'Tarde';

  @override
  String get night => 'Noite';

  @override
  String get morningTime => '6h - 12h';

  @override
  String get afternoonTime => '12h - 18h';

  @override
  String get nightTime => '18h - 00h';

  @override
  String get level => 'Nível';

  @override
  String get allLevels => 'Todos os níveis';

  @override
  String get selectLevels => 'Selecionar níveis';

  @override
  String get format => 'Formato';

  @override
  String get city => 'Cidade';

  @override
  String get search => 'Pesquisar..';

  @override
  String get distance => 'Distância';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get showResults => 'Mostrar resultados';

  @override
  String get padel => 'Padel';

  @override
  String get tennis => 'Tênis';

  @override
  String get beachTennis => 'Tênis de praia';

  @override
  String get pickleball => 'Pickleball';

  @override
  String get signInToBookThisCourt => 'Faça login para reservar este quadra.';

  @override
  String get pleaseLogInCreateAccountToReserveYourSpot =>
      'Faça login ou crie uma conta para reservar sua vaga.';

  @override
  String get signup => 'Inscreva-se';

  @override
  String get findCourtsNearYou => 'Encontre quadras perto de você.';

  @override
  String get clearAll => 'Limpar tudo';

  @override
  String get noCourtsMatchSearchFilters =>
      'Nenhuma quadra corresponde à sua pesquisa/filtros.';

  @override
  String get resetFilters => 'Redefinir filtros';

  @override
  String get availableTimeSlots => 'Horários disponíveis';

  @override
  String get noSportsInformationAvailable =>
      'Nenhuma informação de esportes disponível para este clube.';

  @override
  String get noCourtsOfferThisSport =>
      'Nenhuma quadra oferece este esporte ainda.';

  @override
  String get noSlotsPublishedForDate =>
      'Nenhum horário publicado para esta data.';

  @override
  String get clubDetails => 'Detalhes do clube';

  @override
  String distanceKm(String distance) {
    return '< $distance km';
  }

  @override
  String get available => 'Disponível';

  @override
  String get full => 'Lotado';

  @override
  String get slotsLeft => 'Vagas restantes';

  @override
  String get invitePlayers => 'Convidar jogadores';

  @override
  String get cancelInvite => 'CANCELAR CONVITE';

  @override
  String get invite => 'CONVIDAR';

  @override
  String get bookingConfirmed => 'Reserva confirmada!';

  @override
  String get yourCourtIsReserved =>
      'Sua quadra está reservada. Prepare-se para\numa partida incrível.';

  @override
  String get bookingSummary => 'Resumo da reserva';

  @override
  String get courtDetails => 'DETALHES DA QUADRA';

  @override
  String get court => 'QUADRA';

  @override
  String get time => 'HORÁRIO';

  @override
  String get bookingType => 'TIPO DE RESERVA';

  @override
  String get reserveIndividual => 'Reservar individualmente';

  @override
  String get createAMatch => 'Criar uma partida';

  @override
  String get bookCourtWithoutMatch =>
      'Reserve a quadra sem criar uma partida no aplicativo.';

  @override
  String get createGameForPlayers =>
      'Crie uma partida para que outros jogadores possam participar.';

  @override
  String get book => 'Reservar';

  @override
  String get configureMatch => 'Configurar partida';

  @override
  String get matchType => 'TIPO DE PARTIDA';

  @override
  String get invitePlayersSection => 'CONVIDAR JOGADORES';

  @override
  String get payment => 'PAGAMENTO';

  @override
  String get searchPlayers => 'Pesquisar jogadores...';

  @override
  String get private => 'Privada';

  @override
  String get privateMatchDescription =>
      'Somente jogadores convidados podem participar.';

  @override
  String get open => 'Aberta';

  @override
  String get openMatchDescription =>
      'Outros jogadores podem participar da partida.';

  @override
  String get single => 'Individual';

  @override
  String get double => 'Dupla';

  @override
  String get payAllReceiveLater => 'Pague tudo agora e receba depois';

  @override
  String get payOnlyMyPart => 'Pague apenas minha parte agora';

  @override
  String get payAllNoSplit => 'Pague tudo agora sem dividir depois';

  @override
  String get payAllReceiveLaterDescription =>
      'A quadra já está reservada e você recebe as peças dos outros jogadores automaticamente após a partida.';

  @override
  String get payOnlyMyPartDescription =>
      'O quadra ainda não está marcado. Só será reservado quando todos aderirem. Risco de perder reserva';

  @override
  String get payALlNoSplitDescription =>
      'Os jogadores convidados podem entrar sem pagar nada.';

  @override
  String bookingDateAndTime(String date, String time) {
    return '$date | $time';
  }

  @override
  String get doubleFormat => 'Dupla';

  @override
  String get portfolio => 'Carteira';

  @override
  String get card => 'Cartão';

  @override
  String get priceDetails => 'DETALHES DO PREÇO';

  @override
  String get courtFee => 'Taxa da Quadra';

  @override
  String get serviceFee => 'Taxa de Serviço';

  @override
  String get total => 'Total';

  @override
  String get payNow => 'Pagar Agora';

  @override
  String get portfolioPayment => 'Pagamento pela Carteira';

  @override
  String get cardPayment => 'Pagamento com Cartão';

  @override
  String get changeLocation => 'Change Location';

  @override
  String get searchLocation => 'Search location';

  @override
  String get noLocationsFound => 'No locations found';

  @override
  String get currentLocation => 'Current location';

  @override
  String get searchCity => 'Search city';

  @override
  String withinDistance(Object distance) {
    return 'Within $distance km';
  }

  @override
  String get anyDistance => 'Any distance';

  @override
  String get noAvailableSlotsForDay => 'No available slots for this day';

  @override
  String get viewDetails => 'View Details';

  @override
  String get noCourtsWithLocationToShowHereYet =>
      'Ainda não há tribunais com localização definida para exibir aqui';

  @override
  String get searchCourts => 'Pesquisar quadras';

  @override
  String get searchCourtsHint => 'Pesquisar quadras';

  @override
  String get noCourtsFound => 'Nenhuma quadra encontrada';

  @override
  String get send => 'Enviar';

  @override
  String get space => 'espaço';
}
