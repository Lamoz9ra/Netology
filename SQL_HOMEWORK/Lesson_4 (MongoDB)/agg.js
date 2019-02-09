# - подсчитайте число элементов в созданной коллекции
db.tags.find().count()
# - подсчитайте число фильмов с конкретным тегом - `woman`
db.tags.find({name:"woman"}).count()
# - используя группировку данных ($groupby) вывести top-3 самых распространённых тегов
db.tags.aggregate([{$group:{_id: "$name", count:{$sum:1}}},{$sort:{count:-1}},{$limit: 3}])
