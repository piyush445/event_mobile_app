class Event {

  final int id;
  final String dateTime;
  final String title;
  final String organiserName;
  final String description;
  final String organiserIcon;
  final String venueName;
  final String venueCity;
  final String venuecountry;
  final String bannerImage;

  Event( {
    required this.id,required this.description, required this.bannerImage,required this.title,required this.dateTime, required this.organiserName,required this.organiserIcon,required this.venueCity,required this.venueName,required this.venuecountry
  });

}