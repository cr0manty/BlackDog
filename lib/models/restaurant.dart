class Restaurant {
  String name;
  String email;
  String website;
  String phone;
  String instagramLink;
  String facebook;
  String logo;

  Restaurant(
      {this.name,
      this.email,
      this.facebook,
      this.instagramLink,
      this.logo,
      this.phone,
      this.website});

  factory Restaurant.fromJson(Map<String, dynamic> data) => new Restaurant(
      name: data['name'],
      email: data['email'],
      facebook: data['facebook'],
      instagramLink: data['instagram_link'],
      logo: data['logo'],
      phone: data['phone'],
      website: data['website']);
}
