# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admins = [
    { email: 'toanvpk@tamu.edu',
      uin: '321004222',
      first_name: 'Toan',
      last_name: 'Vu' },
    { email: 'amohanty03@tamu.edu',
      uin: '',
      first_name: 'Ankit',
      last_name: 'Mohanty' },
    { email: 'njulian@tamu.edu',
      uin: '',
      first_name: 'Neeraj',
      last_name: 'Julian' },
    { email: 'haridher@tamu.edu',
      uin: '',
      first_name: 'Haridher',
      last_name: 'Pandiyan' },
    { email: 'sarkriti@tamu.edu',
      uin: '',
      first_name: 'Kriti',
      last_name: 'Sarker' },
    { email: 'davis.beilue@tamu.edu',
      uin: '',
      first_name: 'Davis',
      last_name: 'Beilue' },
    { email: 'jnojek13@tamu.edu',
      uin: '',
      first_name: 'James',
      last_name: 'Nojek' },
    { email: 'aln170001@tamu.edu',
      uin: '',
      first_name: 'Ali',
      last_name: 'Nablan' }
]

admins.each do |admin|
    Admin.find_or_create_by!(admin)
end
