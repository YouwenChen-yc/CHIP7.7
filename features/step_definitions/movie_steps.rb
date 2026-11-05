# Part 1: Seed movies into database
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /(\d+) seed movies should exist/ do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

# Part 2: Check or uncheck multiple rating boxes
When /I (un)?check the following ratings:\s*(.*)/ do |uncheck, rating_list|
  rating_list.split(/,\s*/).each do |rating|
    if uncheck
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

# Part 2: Check visibility for list of movies
Then /^I should (not )?see the following movies: (.*)$/ do |no, movie_list|
  movie_list.split(/,\s*/).each do |movie|
    if no
      expect(page).not_to have_content(movie)
    else
      expect(page).to have_content(movie)
    end
  end
end

# Part 2: Verify total movie card count matching div#movie_X elements
Then /I should see all (?:of )?the movies/ do
  count = page.all('#movies div[id^="movie_"]').count
  expect(count).to eq Movie.count
end

# Part 3: Verify string ordering on page body
Then /(?:|I )should see "(.*)" before "(.*)"/ do |e1, e2|
  pos1 = page.body.index(e1)
  pos2 = page.body.index(e2)
  expect(pos1).not_to be_nil, "Expected page body to contain '#{e1}'"
  expect(pos2).not_to be_nil, "Expected page body to contain '#{e2}'"
  expect(pos1).to be < pos2
end