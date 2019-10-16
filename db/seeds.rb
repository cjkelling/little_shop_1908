# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
Review.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
pump = bike_shop.items.create(name: "Bike Pump", description: "It works fast!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/71Wa47HMBmL._SY550_.jpg", inventory: 15)
helmet = bike_shop.items.create(name: "Helmet", description: "Protects your brain. Try it!", price: 15, image: "https://www.rei.com/media/product/1289320004", inventory: 20)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Don't let your pupper die of thirst!", price: 30, image: "https://img.chewy.com/is/image/catalog/54477_MAIN._AC_SL1500_V1547154540_.jpg", active?:false, inventory: 8)

#bike_shop reviews
tire.reviews.create(title: "Sucks!", content: "I really really hate it.", rating: 1)
tire.reviews.create(title: "It's okay.", content: "Not that bad, I guess.", rating: 3)
tire.reviews.create(title: "Amazing!", content: "Truly changed my life!", rating: 5)

pump.reviews.create(title: "Sucks!", content: "I really really hate it.", rating: 1)
pump.reviews.create(title: "It's okay.", content: "Not that bad, I guess.", rating: 3)
pump.reviews.create(title: "Amazing!", content: "Truly changed my life!", rating: 5)

helmet.reviews.create(title: "Sucks!", content: "I really really hate it.", rating: 1)
helmet.reviews.create(title: "It's okay.", content: "Not that bad, I guess.", rating: 3)
helmet.reviews.create(title: "Amazing!", content: "Truly changed my life!", rating: 5)

#dog_shop reviews
pull_toy.reviews.create(title: "Sucks!", content: "I really really hate it.", rating: 1)
pull_toy.reviews.create(title: "It's okay.", content: "Not that bad, I guess.", rating: 3)
pull_toy.reviews.create(title: "Amazing!", content: "Truly changed my life!", rating: 5)

dog_bone.reviews.create(title: "Sucks!", content: "I really really hate it.", rating: 1)
dog_bone.reviews.create(title: "It's okay.", content: "Not that bad, I guess.", rating: 3)
dog_bone.reviews.create(title: "Amazing!", content: "Truly changed my life!", rating: 5)

dog_bowl.reviews.create(title: "Sucks!", content: "I really really hate it.", rating: 1)
dog_bowl.reviews.create(title: "It's okay.", content: "Not that bad, I guess.", rating: 3)
dog_bowl.reviews.create(title: "Amazing!", content: "Truly changed my life!", rating: 5)
