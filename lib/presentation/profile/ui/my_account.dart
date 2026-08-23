import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/change_location_sheet.dart';
import 'package:quadraclub_app/utils/app_utils.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/image_picker_util.dart';

import '../../../app_exports.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _image;
  String? _initialImageUrl;

  // Keep the resolved coordinates alongside the display text, in case
  // you need to persist lat/lng along with the address on save.
  LocationResult? _selectedLocation;

  // Snapshot of the values loaded from AuthState, used to diff against
  // the current field values so we know (a) whether to enable the
  // Update button and (b) which fields actually changed.
  String _initialName = '';
  String _initialLocation = '';
  String _initialDob = '';

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadFromAuthState();

    _nameController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
    _dobController.addListener(_onFieldChanged);
  }

  void _loadFromAuthState() {
    final user = context.read<AuthBloc>().state.user;

    _initialName = user?.name ?? '';
    _initialImageUrl = user?.imageUrl;
    // NOTE: UserModel currently doesn't expose location/dob fields.
    // Once the backend/UserModel is updated to include them, populate
    // _initialLocation / _initialDob from `user` the same way as name.
    _initialLocation = _locationController.text;
    _initialDob = _dobController.text;

    _nameController.text = _initialName;
    _emailController.text = user?.email ?? '';
    _locationController.text = _initialLocation;
    _dobController.text = _initialDob;
  }

  void _onFieldChanged() {
    final changed =
        _nameController.text != _initialName ||
        _locationController.text != _initialLocation ||
        _dobController.text != _initialDob ||
        _image != null;

    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  Future<void> _onTapChangePhoto() async {
    final File? img = await ImagePickerUtil.pickFromGallery(context);
    if (img != null) {
      setState(() {
        _image = File(img.path);
      });
      _onFieldChanged();
    }
  }

  Future<void> _onSelectDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _dobController.text = AppUtils.getFormattedDateWithSlash(date);
      });
      _onFieldChanged();
    }
  }

  Future<void> _onSelectLocation() async {
    await ChangeLocationSheet.show(
      context,
      onLocationSelected: (LocationResult location) {
        setState(() {
          _selectedLocation = location;
          _locationController.text = location.address;
        });
        _onFieldChanged();
      },
    );
  }

  DateTime? _parseDob(String text) {
    if (text.trim().isEmpty) return null;
    try {
      final parts = text.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  void _onTapUpdate() {
    if (!_hasChanges) return;

    final nameChanged = _nameController.text != _initialName;
    final locationChanged = _locationController.text != _initialLocation;
    final dobChanged = _dobController.text != _initialDob;

    context.read<AuthBloc>().add(
      UpdateProfile(
        // `name` is required by UpdateProfile, so send the current
        // value regardless (it's unchanged if the user didn't edit it).
        name: _nameController.text,
        location: locationChanged ? _locationController.text : null,
        profileImage: _image, // only non-null when a new photo was picked
        dob: dobChanged ? _parseDob(_dobController.text) : null,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _locationController.removeListener(_onFieldChanged);
    _dobController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _locationController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          context.pop();
          context.showToast("Profile updated successfully");
        } else if (state.status == AuthStateStatus.failure &&
            state.error != null) {
          context.showToast(
            state.error ?? "Something went wrong",
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final isUpdating = state.status == AuthStateStatus.updating;

        return Scaffold(
          appBar: CustomAppBar(
            title: "My Account",
            showActions: false,
            centerTile: true,
            showBackIcon: true,
            titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
          ),
          backgroundColor: kCardColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                32.heightBox,
                CustomTextField(
                  label: "Name",
                  controller: _nameController,
                  hintText: "Enter your name",
                  prefixIcon: SvgPicture.asset(Assets.svg.accontIcon.path),
                  keyboardType: TextInputType.name,
                ),
                12.heightBox,
                CustomTextField(
                  label: "Location",
                  controller: _locationController,
                  hintText: "Enter your location",
                  readOnly: true,
                  onTap: _onSelectLocation,
                  prefixIcon: SvgPicture.asset(Assets.svg.mapMarker.path),
                ),
                12.heightBox,
                CustomTextField(
                  controller: _dobController,
                  label: 'Date of Birth',
                  hintText: 'dd/mm/yyyy',
                  readOnly: true,
                  onTap: () => _onSelectDate(),
                  suffixIcon: SvgPicture.asset(Assets.svg.calendarBlank.path),
                ),
                12.heightBox,
                CustomTextField(
                  label: "Email (Can’t Change)",
                  controller: _emailController,
                  readOnly: true,
                  hintText: "Enter your email",
                  textStyle: AppStyles.w400f14inter.copyWith(
                    color: kTextSecondary.withValues(alpha: 0.50),
                  ),
                  prefixIcon: SvgPicture.asset(Assets.svg.emailIcon.path),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ).withPaddingAll(24),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(16),
            color: kWhiteF9,
            child: isUpdating
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CustomLoadingView()],
                  )
                : CustomActionButton(
                    buttonText: "Update",
                    isEnabled: _hasChanges,
                    onTap: (_hasChanges && !isUpdating) ? _onTapUpdate : null,
                  ),
          ),
        );
      },
    );
  }

  Row _buildHeader() {
    ImageProvider? networkImage;
    if (_initialImageUrl != null && _initialImageUrl!.isNotEmpty) {
      networkImage = NetworkImage(_initialImageUrl!);
    }

    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            AppCachedImage(
              borderRadius: BorderRadius.circular(20),
              localFile: _image,
              // Falls back to the user's current photo until a new one is picked.
              imageUrl: _image == null ? _initialImageUrl : null,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            Positioned(
              right: -10,
              bottom: -10,
              child: InkWell(
                onTap: _onTapChangePhoto,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBorderColor),
                  ),
                  child: SvgPicture.asset(Assets.svg.uploadPhoto.path),
                ),
              ),
            ),
          ],
        ),
        20.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Photo',
              style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
            ),
            Text(
              'JPG or PNG, max 5MB.',
              style: AppStyles.w400f14inter.copyWith(color: kTextColor),
            ),
          ],
        ),
      ],
    );
  }
}
