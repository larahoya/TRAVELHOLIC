function buildTravelHtml(travel) {
  return '<div><h2>'+ travel.title + '</h2>'
  + '<dl><dt> Initial date </dt><dd>' + travel.initial_date + '</dd>'
  + '<dl><dt> Final date </dt><dd>' + travel.final_date + '</dd>'
  + '<dl><dt> Description </dt><dd>' + travel.description + '</dd>'
  + '<dl><dt> Countries </dt><dd>' + travel.countries + '</dd>'
  + '<dl><dt> Places </dt><dd>' + travel.places + '</dd>'
  + '<dl><dt> Initial date </dt><dd>' + travel.initial_date + '</dd>'
  + '<dl><dt> Budget </dt><dd>' + travel.budget + '</dd>'
  + '<dl><dt> Requirements</dt><dd>' + travel.requirements + '</dd>'
  + '<dl><dt> Initial date </dt><dd>' + travel.initial_date + '</dd>'
  + '<dl><dt> Maximum people </dt><dd>' + travel.maximum_people + '</dd>'
  + '<dl><dt> Total people </dt><dd>' + travel.people + '</dd>'
}