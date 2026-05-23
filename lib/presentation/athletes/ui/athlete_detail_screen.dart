import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/athletes/ui/athlete_detail_shimmer.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/home/bloc/home_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/note_model.dart';
import 'package:quadraclub_app/presentation/home/data/rating_model.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/video_player_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/videos_list_widget.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/pdf_viewer.dart';
import 'package:quadraclub_app/utils/components/alert_dialogue.dart';
import 'package:quadraclub_app/utils/components/custom_dialogue.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

import '/app_exports.dart';
import '../../../utils/components/blue_app_bar.dart';

class AthleteProfileScreen extends StatefulWidget {
  final int athleteId;

  const AthleteProfileScreen({super.key, required this.athleteId});

  @override
  State<AthleteProfileScreen> createState() => _AthleteProfileScreenState();
}

class _AthleteProfileScreenState extends State<AthleteProfileScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetUserById(userId: widget.athleteId));
    super.initState();
  }

  String get currentUserId {
    return context.read<AuthBloc>().state.user?.id.toString() ?? '';
  }

  RatingModel? get myExistingRating {
    final ratings = context.read<HomeBloc>().state.athleteRatings;
    try {
      return ratings.firstWhere(
        (rating) => rating.ratedBy?.providedBy.toString() == currentUserId,
      );
    } catch (e) {
      return null;
    }
  }

  void _showAddNotesDialog() {
    TextEditingController notesController = TextEditingController();
    String selectedType = 'private';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CustomDialog(
              title: 'Add Note',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Note',
                    style: AppStyles.subtitleMedium.copyWith(
                      color: kBlackColor,
                    ),
                  ),
                  10.heightBox,
                  // Type Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedType,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: 'private',
                            child: Text('Private Note'),
                          ),
                          DropdownMenuItem(
                            value: 'public',
                            child: Text('Public Note'),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  10.heightBox,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: notesController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter your notes here...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ).withPaddingSymmetric(12, 0),
              buttonText: 'Add',
              onButtonTap: () {
                if (notesController.text.isNotEmpty) {
                  context.read<HomeBloc>().add(
                    AddNote(
                      userId: widget.athleteId,
                      note: notesController.text,
                      type: selectedType,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            );
          },
        );
      },
    );
  }

  void _showUpdateNoteDialog(NoteModel note) {
    TextEditingController notesController = TextEditingController(
      text: note.note,
    );
    String selectedType = note.type ?? 'private';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CustomDialog(
              title: 'Update Note',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Note',
                    style: AppStyles.subtitleMedium.copyWith(
                      color: kBlackColor,
                    ),
                  ),
                  10.heightBox,
                  // Type Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedType,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: 'private',
                            child: Text('Private Note'),
                          ),
                          DropdownMenuItem(
                            value: 'public',
                            child: Text('Public Note'),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  10.heightBox,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: notesController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter your notes here...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ).withPaddingSymmetric(12, 0),
              buttonText: 'Update',
              onButtonTap: () {
                if (notesController.text.isNotEmpty) {
                  context.read<HomeBloc>().add(
                    UpdateNote(
                      noteId: note.id ?? 0,
                      userId: widget.athleteId,
                      note: notesController.text,
                      type: selectedType,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteNoteDialog(NoteModel note) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CustomAlertDialog(
              title: 'Delete Note',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Are you sure you want to delete this note?',
                    style: AppStyles.subtitleMedium.copyWith(
                      color: kBlackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ).withPaddingSymmetric(16, 0),
              onButtonTap: () {
                context.read<HomeBloc>().add(
                  DeleteNote(noteId: note.id ?? 0, userId: widget.athleteId),
                );
                Navigator.pop(context);
              },
              leftButtonText: 'No',
              rightButtonText: 'Yes',
            );
          },
        );
      },
    );
  }

  void _showRatingDialog() {
    final existingRating = myExistingRating;
    double tempRating = existingRating?.rating?.toDouble() ?? 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CustomDialog(
              title: existingRating != null ? 'Change Rating' : 'Rate',
              buttonText: 'Done',
              onButtonTap: () {
                if (tempRating > 0) {
                  context.read<HomeBloc>().add(
                    AddRating(
                      userId: widget.athleteId,
                      rating: tempRating.toInt(),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              content: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (existingRating != null) ...[
                      Text(
                        'Your current rating',
                        style: AppStyles.bodyRegular.copyWith(
                          color: kTextColor,
                        ),
                      ),
                      8.heightBox,
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              tempRating = (index + 1).toDouble();
                            });
                          },
                          child: Icon(
                            index < tempRating ? Icons.star : Icons.star_border,
                            size: 48,
                            color: kSecondaryColor,
                          ),
                        );
                      }),
                    ),
                    10.heightBox,
                    Text(
                      '${tempRating.toStringAsFixed(0)}/5',
                      style: AppStyles.headingSemibold.copyWith(
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
          Text(value, style: AppStyles.bodyMedium.copyWith(color: kBlackColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BlueAppBar(
        showBackArrow: true,
        height: 100,
        title: 'Athletes Profile',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.status == HomeStateStatus.fetching) {
                  return const AthleteProfileShimmer();
                } else if (state.currentAthlete == null) {
                  return Center(
                    child: Text(
                      'Athlete not found',
                      style: AppStyles.subtitleMedium.copyWith(
                        color: kBlackColor,
                      ),
                    ),
                  );
                }
                final athlete = state.currentAthlete!;
                return Container(
                  margin: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9F4E8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: kWhiteColor,
                        radius: 50,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              athlete.scannedUserProfile?.image != null
                              ? NetworkImage(athlete.scannedUserProfile!.image!)
                              : null,
                          child: athlete.scannedUserProfile?.image == null
                              ? Icon(Icons.person, size: 60)
                              : null,
                        ),
                      ),
                      8.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: kSecondaryColor, size: 24),
                          4.widthBox,
                          Text(
                            athlete.scannedUserProfile?.averageRating
                                    ?.toStringAsFixed(1) ??
                                '',
                            style: AppStyles.subtitleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: kBlackColor,
                            ),
                          ),
                        ],
                      ),
                      16.heightBox,
                      _buildInfoRow(
                        'Full Name',
                        athlete.scannedUserProfile?.fullName ?? "Unknown",
                      ),
                      _buildInfoRow('Email', athlete.email ?? "N/A"),
                      _buildInfoRow(
                        'Graduation Year',
                        athlete.scannedUserProfile?.graduationYear.toString() ??
                            "unknown",
                      ),
                      _buildInfoRow(
                        'Team',
                        athlete.scannedUserProfile?.teamName ?? "unknown",
                      ),
                      _buildInfoRow(
                        'Position',
                        athlete.scannedUserProfile?.position ?? "unknown",
                      ),
                      if (myExistingRating != null)
                        _buildInfoRow(
                          'You Rate',
                          '⭐ ${myExistingRating?.rating ?? 0}',
                        ),
                      if (athlete.scannedUserProfile?.transcript != null)
                        buildTranscriptField(
                          context,
                          athlete.scannedUserProfile!.transcript!,
                        ),
                      if (athlete.scannedUserProfile?.highlightVideos != null &&
                          athlete
                              .scannedUserProfile!
                              .highlightVideos!
                              .isNotEmpty)
                        _buildHighlightedVideos(
                          context,
                          athlete.scannedUserProfile!.highlightVideos!
                              .map((video) => video.video ?? '')
                              .where((url) => url.isNotEmpty)
                              .toList(),
                        ),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.status == HomeStateStatus.fetching) {
                  return SizedBox.shrink();
                } else if (state.currentAthlete == null) {
                  return SizedBox.shrink();
                }

                // Filter notes
                final publicNotes = state.athleteNotes
                    .where(
                      (note) =>
                          (note.type == 'public' &&
                          note.provider != currentUserId),
                    )
                    .toList();

                final myNotes = state.athleteNotes
                    .where((note) => note.provider == currentUserId)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Public Notes Section
                    if (publicNotes.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dim.PADDING_SIZE_DEFAULT,
                        ),
                        child: Text(
                          'Public Notes',
                          style: AppStyles.titleSemibold.copyWith(
                            color: kBlackColor,
                          ),
                        ),
                      ),
                      10.heightBox,
                      ...publicNotes.map(
                        (note) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: Dim.PADDING_SIZE_DEFAULT,
                            vertical: 8,
                          ),
                          padding: EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFF9F4E8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: kTertiaryColor),
                                  color: kWhiteColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  DateFormat(
                                    'dd MMM,yyyy',
                                  ).format(note.createdAt!),
                                  style: AppStyles.bodyRegular.copyWith(
                                    color: kPrimaryColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              8.heightBox,
                              Text(
                                note.note ?? "",
                                style: AppStyles.bodyRegular.copyWith(
                                  color: kTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.heightBox,
                    ],

                    // Your Note Section
                    if (myNotes.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dim.PADDING_SIZE_DEFAULT,
                        ),
                        child: Text(
                          'Your Notes',
                          style: AppStyles.titleSemibold.copyWith(
                            color: kBlackColor,
                          ),
                        ),
                      ),
                      10.heightBox,
                      ...myNotes.map((note) => noteCard(note)),
                      10.heightBox,
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final hasRating = myExistingRating != null;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dim.PADDING_SIZE_DEFAULT,
              vertical: Dim.PADDING_SIZE_SMALL,
            ),
            decoration: BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(color: kTextColor, thickness: 0.5),
                  Row(
                    children: [
                      Expanded(
                        child: CustomActionButton(
                          buttonText: 'Add Note',
                          onTap: _showAddNotesDialog,
                          backgroundColor: kWhiteColor,
                          borderColor: kSecondaryColor,
                        ),
                      ),
                      8.widthBox,
                      Expanded(
                        child: CustomActionButton(
                          buttonText: hasRating ? 'Change Rating' : 'Rate',
                          onTap: _showRatingDialog,
                          backgroundColor: kSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTranscriptField(BuildContext context, String transcript) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transcript',
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PdfViewerScreen(pdfUrl: transcript, title: 'Transcript'),
                ),
              );
            },
            child: Text(
              'Transcript.pdf',
              style: AppStyles.bodyMedium.copyWith(
                color: kPrimaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedVideos(BuildContext context, List<String> videos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Highlighted Videos',
                style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
              ),
            ],
          ),
        ),
        8.heightBox,
        VideoListWidget(
          videoUrls: videos,
          itemHeight: 50,
          isFromHome: false,
          spacing: 8,
          onVideoTap: (videoUrl) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget noteCard(NoteModel note) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dim.PADDING_SIZE_DEFAULT,
        vertical: 8,
      ),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF9F4E8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: kTertiaryColor),
                  color: kWhiteColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  DateFormat('dd MMM,yyyy').format(note.createdAt!),
                  style: AppStyles.bodyRegular.copyWith(
                    color: kPrimaryColor,
                    fontSize: 10,
                  ),
                ),
              ),
              8.widthBox,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: kTertiaryColor),
                  color: note.type == 'public'
                      ? kSecondaryColor.withValues(alpha: 0.2)
                      : kPrimaryColor.withValues(alpha: 0.2),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  note.type?.toUpperCase() ?? 'PRIVATE',
                  style: AppStyles.bodyRegular.copyWith(
                    color: note.type == 'public'
                        ? kSecondaryColor
                        : kPrimaryColor,
                    fontSize: 10,
                  ),
                ),
              ),
              Spacer(),
              // IconButton(onPressed: (){
              //   _showUpdateNoteDialog(note);
              // }, icon: Icon(Icons.edit)),
              // 8.widthBox,
              // IconButton(onPressed: (){
              //   _showDeleteNoteDialog(note);
              // }, icon: Icon(Icons.delete,color: Colors.red,))
              _actionButton(
                icon: Icons.edit_outlined,
                color: kPrimaryColor,
                onTap: () {
                  _showUpdateNoteDialog(note);
                },
              ),
              12.widthBox,
              _actionButton(
                icon: Icons.delete_outline,
                color: Colors.red,
                onTap: () {
                  _showDeleteNoteDialog(note);
                },
              ),
            ],
          ),
          8.heightBox,
          Text(
            note.note ?? "",
            style: AppStyles.bodyRegular.copyWith(color: kTextColor),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
