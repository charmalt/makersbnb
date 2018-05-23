feature 'adding a room' do

  before do
    visit '/rooms/new'
  end

  let(:name) { 'Champagne Central' }
  let(:location) { 'London' }
  let(:description) { 'Booooooze!' }
  let(:start_date) { '2018-11-29' }
  let(:end_date) { '2018-11-30' }

  scenario 'can successfully complete form' do
    rooms_fill_in_and_submit(name, location, description, start_date, end_date)
    expect(page).to have_content 'Room received'
  end

  scenario 'booking data added to database' do
    rooms_fill_in_and_submit(name, location, description, start_date, end_date)
    expect(Room.all.last).to be_instance_of(Room)
    expect(Room.all.last.name).to eq name
    expect(Room.all.last.location).to eq location
    expect(Room.all.last.description).to eq description
    expect(Room.all.last.from.strftime("%Y-%m-%d")).to eq start_date
    expect(Room.all.last.to.strftime("%Y-%m-%d")).to eq end_date
  end

  scenario 'availability data added to database' do
    number_of_dates = Date.strptime(end_date, "%Y-%m-%d").day - Date.strptime(start_date, "%Y-%m-%d").day + 1
    rooms_fill_in_and_submit(name, location, description, start_date, end_date)
    expect(Availability.all.last).to be_instance_of(Availability)
    expect(Availability.all.last.date).to eq Date.strptime(end_date, "%Y-%m-%d")
    expect(Availability.all.length).to eq number_of_dates
  end
end
