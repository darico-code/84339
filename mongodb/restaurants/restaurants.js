/*10. Mostrare tutti i ristoranti esclusi quelli che si trovano a Brooklyn o nel Bronx*/

//console.log(db.restaurants.find({"borough": {$nin: ["Brooklyn", "Bronx"]}}))

/* 11. Mostrare i campi restaurant_id, name, borough e cuisine di tutti i documenti nella collezione. */

//console.log(db.restaurants.find({}, {"_id":0, restaurant_id": 1, "name":1, "borough":1, "cuisine":1}))

/*
12. Mostrare restaurant_id, name, borough e cuisine (escludere _id)
di un ristorante che si trova a Queens
*/

/*console.log(db.restaurants.findOne({"borough": "Queens"},
             {"_id": 0, "restaurant_id": 1, "name":1, "borough":1, "cuisine":1}))*/

// 13. Mostrare i primi 5 ristoranti che si trovano nel Bronx

// console.log(db.restaurants.find({"borough": "Bronx"}).limit(5))

/* 
14. Mostrare i prossimi 5 (escludendo i primi 5) ristoranti che si
trovano nel Bronx
*/

// console.log(db.restaurants.find({"borough": "Bronx"}).skip(5).limit(5))

/*
15. Mostrare restaurant_id, name, borough e cuisine per tutti i
ristoranti il cui nome inizia con 'Wil'
*/

// console.log(db.restaurants.find({"name": {$regex: /^Wil/}}, {"_id": 0, "restaurant_id": 1, "name":1, "borough":1, "cuisine":1}))

/*
16 Mostrare i ristoranti che hanno almeno un score >90
16bis: proiezione sui dati utili (nome, solo grades con score >90)
16ter. Mostrare i ristoranti che hanno un score >90 e <100
*/

//console.log(db.restaurants.find({grades: {$elemMatch: {score: {$gt: 90}}}}))

//console.log(db.restaurants.find({grades: {$elemMatch: {score: {$gt: 90}}}}, {_id : 0, name: 1, "grades.$": 1}))

//console.log(db.restaurants.find({grades: {$elemMatch: {score: {$gt: 90, $lt: 100}}}}))

/*
17. Mostrare i ristoranti che hanno cucina diversa da "American",
score>70 e latitudine (address.coord.0) <-65
*/

// console.log(db.restaurants.find({cuisine : {$ne: 'American'}, grades: { $elemMatch: {score: {$gt: 70}}}, "address.coord.0": {$lt: -65}}))

// 18. Mostrare i ristoranti che non hanno avuto un score >10

// console.log(db.restaurants.find({grades: {$not: {$elemMatch: {score: {$gt: 10}}}}}))

// 19. Contare i ristoranti nel cui indirizzo non è specificata la street

//db.restaurants.updateOne({"restaurant_id": "40368801"}, {$unset: {"address.street": ""}}) for test
//console.log(db.restaurants.find({"address.street": {$exists: false}}).count())

//20. Contare i ristoranti che hanno 6 voti (grades)

// console.log(db.restaurants.find({grades: {$size: 6}}).count())

// 21. Contare i ristoranti che hanno più di 6 voti

//console.log(db.restaurants.find({"grades.6": {$exists: true}}).count())

// 22. Visualizzare tutti i tipi distinti di cucina
// console.log(db.restaurants.distinct("cuisine", {}))