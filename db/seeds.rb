# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


special_area = TargetArea.create(
                 name: '世田谷区',
                 category: '特別区'
             )

target_areas = [
    {
        name: '桜新町',
        rail_line: '東急田園都市線',
        category: '駅',
        target_area_id: special_area.id
    }
]
TargetArea.create(target_areas)
