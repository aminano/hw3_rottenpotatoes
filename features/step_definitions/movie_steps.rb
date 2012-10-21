# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert page.body.index(e1) < page.body.index(e2), "Not the expected order"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(", ")
  ratings.each do |rating|
    if uncheck
      uncheck "ratings_#{rating}"
    else
      check "ratings_#{rating}"
    end
  end
end

Then /I should(n't)? see the following movies: (.*)/ do |negative, titles_list|
  titles = titles_list.split(", ")
  titles.each do |title|
    if negative
      assert page.has_content?(title) == false
    else
      assert page.has_content?(title)
    end
  end
end

When /^I press (.*)$/ do |clicked|
  click_button clicked
end

Then /I should see (all|none) of the movies/ do |which|
  if which == "all"
    size_db = Movie.all.size
  else
    size_db = 0
  end
  assert page.all("table#movies tbody tr").count == size_db
end

