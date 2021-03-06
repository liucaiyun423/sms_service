# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
SmsProvider.find_or_create_by!(url: "https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1",
                            redis_key_prefix: "primary")
SmsProvider.find_or_create_by!(url: "https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2",
                            redis_key_prefix: "secondary")
