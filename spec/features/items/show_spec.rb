require 'rails_helper'

RSpec.describe 'item show page', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @review_1 = @chain.reviews.create(title: "Awesome", content: "Really really awesome", rating: 5)
    @review_2 = @chain.reviews.create(title: "Not Great", content: "Stinks a lot", rating: 1)
    @review_3 = @chain.reviews.create(title: "Mediocre", content: "What can I say? Gets the job done I guess.", rating: 3)
    @review_4 = @chain.reviews.create(title: "Good", content: "Good product. Satisfied.", rating: 4)
    visit "/items/#{@chain.id}"
  end
  it 'shows item info' do

    expect(page).to have_link(@chain.merchant.name)
    expect(page).to have_content(@chain.name)
    expect(page).to have_content(@chain.description)
    expect(page).to have_content("Price: $#{@chain.price}")
    expect(page).to have_content("Active")
    expect(page).to have_content("Inventory: #{@chain.inventory}")
    expect(page).to have_content("Sold by: #{@bike_shop.name}")
    expect(page).to have_css("img[src*='#{@chain.image}']")
  end

  it 'can show flash message when trying to visit nonexistent item show page' do
    visit "/items/2389720"

    expect(page).to have_content('Item does not exist. Redirecting to item index page.')

    expect(current_path).to eq('/items')
  end

  it "see a list of reviews for that item" do


    within "#review-#{@review_1.id}" do
      expect(page).to have_content(@review_1.title)
      expect(page).to have_content(@review_1.content)
      expect(page).to have_content(@review_1.rating)
    end

    within "#review-#{@review_2.id}" do
      expect(page).to have_content(@review_2.title)
      expect(page).to have_content(@review_2.content)
      expect(page).to have_content(@review_2.rating)
    end
  end

  it "has a link to create new review" do
    click_link "Create New Review"

    expect(current_path).to eq("/items/#{@chain.id}/reviews/new")

    fill_in "Title", with: "Great Product!"
    fill_in "Content", with: "Seriously really good product"
    fill_in "rating", with: 5

    click_button "Create"

    expect(current_path).to eq("/items/#{@chain.id}")

    review_3 = Review.last

    within "#review-#{review_3.id}" do
      expect(page).to have_content(review_3.title)
      expect(page).to have_content(review_3.content)
      expect(page).to have_content(review_3.rating)
    end
  end

  it "shows reviews statistics" do
    within "#review-top-three" do
      expect(page).to have_content(@review_1.title)
      expect(page).to have_content(@review_1.rating)
      expect(page).to have_content(@review_4.title)
      expect(page).to have_content(@review_4.rating)
      expect(page).to have_content(@review_3.title)
      expect(page).to have_content(@review_3.rating)
      expect(page).to_not have_content(@review_2.title)
      expect(page).to_not have_content(@review_2.rating)
    end

    within "#review-bottom-three" do
      expect(page).to have_content(@review_2.title)
      expect(page).to have_content(@review_2.rating)
      expect(page).to have_content(@review_3.title)
      expect(page).to have_content(@review_3.rating)
      expect(page).to have_content(@review_4.title)
      expect(page).to have_content(@review_4.rating)
      expect(page).to_not have_content(@review_1.title)
      expect(page).to_not have_content(@review_1.rating)
    end

    within "#review-average-rating" do
      expect(page).to have_content("Average Rating: 3.25")
    end
  end

  it "can edit a review" do
    within "#review-#{@review_2.id}" do
      click_link 'Edit Review'
    end

    expect(current_path).to eq("/items/#{@chain.id}/reviews/#{@review_2.id}/edit")

    expect(find_field('Title').value).to eq 'Not Great'
    expect(find_field('Content').value).to eq 'Stinks a lot'
    expect(find_field('rating').value).to eq "1"

    fill_in "Title", with: "It's a little better"
    fill_in "Content", with: "Really, it got better"
    fill_in "rating", with: 2

    click_button 'Update Review'

    expect(current_path).to eq("/items/#{@chain.id}")

    within "#review-#{@review_2.id}" do
      expect(page).to have_content("It's a little better")
      expect(page).to have_content("Really, it got better")
      expect(page).to have_content(2)

      expect(page).to_not have_content("Not Great")
      expect(page).to_not have_content("Stinks a lot")
      expect(page).to_not have_content(1)
    end
  end

  it "can delete a review" do
    within "#review-#{@review_2.id}" do
      click_link 'Delete Review'
    end

    expect(current_path).to eq("/items/#{@chain.id}")

    expect(page).to_not have_content(@review_2.title)
    expect(page).to_not have_content(@review_2.content)
    expect(page).to_not have_content(@review_2.rating)
  end

  it "cannot create review if fields are blank" do
    visit "/items/#{@chain.id}/reviews/new"

    click_button 'Create'

    expect(page).to have_content("Title can't be blank, Content can't be blank, Rating can't be blank, and Rating is not included in the list")

    expect(page).to have_button('Create')
  end

  it "cannot edit review if fields are blank" do
    visit "/items/#{@chain.id}/reviews/#{@review_1.id}/edit"

    fill_in 'Title', with: ''

    click_button 'Update Review'

    expect(page).to have_content("Title can't be blank")

    expect(page).to have_button('Update Review')
  end

  it "can show a link to add item to cart" do
    click_link 'Add Item to Cart'

    expect(page).to have_content("You now have 1 copy of #{@chain.name} in your cart.")

    expect(current_path).to eq('/items')

    expect(page).to have_link("Cart (1)")

    visit "/items/#{@chain.id}"

    click_link 'Add Item to Cart'

    expect(page).to have_content("You now have 2 copies of #{@chain.name} in your cart.")

    expect(current_path).to eq('/items')

    expect(page).to have_link("Cart (2)")
  end

  it "cannot delete item if it has been ordered" do
    click_link 'Add Item to Cart'

    visit '/cart'

    click_link 'Checkout'

    fill_in 'Customer name', with: 'Joe'
    fill_in 'Customer address', with: '123 Test Drive'
    fill_in 'Customer city', with: 'Denver'
    fill_in 'Customer state', with: 'CO'
    fill_in 'Customer zip', with: 80128

    click_button 'Create Order'

    visit "/items/#{@chain.id}"

    expect(page).to_not have_link('Delete Item')
  end
end
