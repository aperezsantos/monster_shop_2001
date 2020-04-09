require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

    it "I cannot see disabled items "do
      visit '/items'
      expect(page).to_not have_content("#item-#{@dog_bone.id}")

      @dog_bone.update(active?:true)
      @dog_bone.save

      visit '/items'

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_link(@dog_bone.name)
        expect(page).to have_content(@dog_bone.description)
        expect(page).to have_content("Price: $#{@dog_bone.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@dog_bone.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      end
    end

    it "can click the image to navigate to the item show page" do
      visit '/items'

      expect(page).to have_css("img[src*='#{@tire.image}']")

      click_link("#{@tire.id}")

      expect(page).to have_current_path("/items/#{@tire.id}")
    end

    describe "can see popularity statistics" do
      it "can see top/bottom five popular items" do
        tire_2 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pull_toy_2 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
        tire_3 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pull_toy_3 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
        tire_4 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pull_toy_4 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
        tire_5 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pull_toy_5 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
        tire_6 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pull_toy_6 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

        order_1 = Order.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
        ItemOrder.create(order_id: order_1.id, item_id: tire_2.id, price: 1.99, quantity: 5004)
        ItemOrder.create(order_id: order_1.id, item_id: tire_3.id, price: 1.99, quantity: 5003)
        ItemOrder.create(order_id: order_1.id, item_id: tire_4.id, price: 1.99, quantity: 5002)
        ItemOrder.create(order_id: order_1.id, item_id: tire_5.id, price: 1.99, quantity: 5001)
        ItemOrder.create(order_id: order_1.id, item_id: tire_6.id, price: 1.99, quantity: 5000)
        ItemOrder.create(order_id: order_1.id, item_id: tire.id, price: 1.99, quantity: 200)
        ItemOrder.create(order_id: order_1.id, item_id: pull_toy.id, price: 1.99, quantity: 200)
        ItemOrder.create(order_id: order_1.id, item_id: pull_toy_2.id, price: 1.99, quantity: 5)
        ItemOrder.create(order_id: order_1.id, item_id: pull_toy_3.id, price: 1.99, quantity: 4)
        ItemOrder.create(order_id: order_1.id, item_id: pull_toy_4.id, price: 1.99, quantity: 3)
        ItemOrder.create(order_id: order_1.id, item_id: pull_toy_5.id, price: 1.99, quantity: 2)
        ItemOrder.create(order_id: order_1.id, item_id: pull_toy_6.id, price: 1.99, quantity: 1)

        visit '/items'
        within "#top_five" do
          expect(page).to have_content("#{tire_2.name}: #{tire_2.order_count}")
          expect(page).to have_content("#{tire_2.name}: #{tire_3.order_count}")
          expect(page).to have_content("#{tire_2.name}: #{tire_4.order_count}")
          expect(page).to have_content("#{tire_2.name}: #{tire_5.order_count}")
          expect(page).to have_content("#{tire_2.name}: #{tire_6.order_count}")
        end

      end
    end
  end
end
